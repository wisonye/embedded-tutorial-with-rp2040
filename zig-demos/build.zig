///
/// How this build works???
///
/// 1. Compile the `src/xxx/main.zig` obj file and save it into `zig-out/{output_obj_filename}`
///
/// 2. Run `cmake` to build the entire project and link the `zig-out/{output_obj_filename}`
///    to produce the `build/{CMAKE_PROJECT_NAME}.elf/uf2`
///
const std = @import("std");
const print = std.log.err;

//
// Your pico board
//
const pico_board = "pico_w";

//
// Custom build error
//
const BuildError = error{
    PicoSdkPathIsMissing,
    UnsupportedPicoBoard,
    OutOfMemory,
    SystemResources,
    SymLinkLoop,
    ProcessFdQuotaExceeded,
    SystemFdQuotaExceeded,
    DeviceBusy,
    Unexpected,
    FileNotFound,
    NotDir,
    InvalidHandle,
    AccessDenied,
    NameTooLong,
    NoDevice,
    InvalidUtf8,
    BadPathName,
    NetworkNotFound,
    InvalidWtf8,
    PathAlreadyExists,
    NoSpaceLeft,
    SharingViolation,
    PipeBusy,
    AntivirusInterference,
    FileTooBig,
    IsDir,
    FileLocksNotSupported,
    FileBusy,
    WouldBlock,
};

///
/// 1. Compile the `src/xxx/main.zig` obj file and save it into `zig-out/{output_obj_filename}`
///
fn createZigObjCompilation(
    b: *std.Build,
    sdk_path: []const u8,
    zig_src: []const u8,
    cmake_project_name: []const u8,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    custom_build_options: *std.Build.Step.Options,
) BuildError!*std.Build.Step.Compile {

    //
    // Compile object step
    //
    const lib = b.addObject(.{
        .name = cmake_project_name,
        .root_source_file = .{ .path = zig_src },
        .target = target,
        .optimize = optimize,
    });

    lib.root_module.addOptions("build_options", custom_build_options);

    //
    // Default arm-none-eabi includes or from env var `ARM_STD_INCLUDE`
    //
    lib.linkLibC();
    lib.addSystemIncludePath(.{ .path = "/usr/arm-none-eabi/include" });
    if (std.posix.getenv("ARM_STD_INCLUDE")) |arm_std_include_path| {
        lib.addSystemIncludePath(.{ .path = arm_std_include_path });
    }

    //
    // Search for board header file
    //
    var board_header_file: ?[]const u8 = null;

    const boards_directory_path = b.pathJoin(&.{ sdk_path, "src/boards/include/boards/" });
    var boards_dir = try std.fs.openDirAbsolute(boards_directory_path, .{ .iterate = true });
    defer boards_dir.close();

    var dir_iter = boards_dir.iterate();
    while (try dir_iter.next()) |file| {
        if (std.mem.containsAtLeast(u8, file.name, 1, pico_board)) {
            board_header_file = file.name;
            break;
        }
    }

    if (board_header_file == null) {
        print("\n>>> [ createZigObjCompilation ] - Unsupported pico board: {s}", .{pico_board});

        return BuildError.UnsupportedPicoBoard;
    }

    //
    // Autogenerate the header file like the pico sdk would:
    //
    // 1. `build/generated/pico_base/pico/config_autogen.h`
    //
    // 2. `build/generated/pico_base/pico/version.h`, we don't need this, it's inside
    //    `extra_include/pico/version.h` which copied from generated
    //    `build/generated/pico_base/pico/version.h` (I believe it won't change?:)
    //
    const auto_config_content = try std.fmt.allocPrint(b.allocator,
        \\#include "{s}/src/boards/include/boards/{s}"
        \\#include "{s}/src/rp2_common/cmsis/include/cmsis/rename_exceptions.h"
    , .{
        sdk_path,
        board_header_file.?,
        sdk_path,
    });

    const config_autogen_step = b.addWriteFile("pico/config_autogen.h", auto_config_content);
    lib.step.dependOn(&config_autogen_step.step);

    // `build/generated/pico_base/pico` should be added to the include path
    lib.addIncludePath(config_autogen_step.getDirectory());
    lib.addSystemIncludePath(.{ .path = "build/generated/pico_base" });

    //
    // Search all PICO SDK `include` folders and add them to include path
    //
    // `find -type d -name include`
    // `fd --type d include`
    //
    const pico_sdk_src = try std.fmt.allocPrint(b.allocator, "{s}/src", .{sdk_path});
    const find = try b.findProgram(&.{"find"}, &.{});
    const find_argv = [_][]const u8{ find, pico_sdk_src, "-type", "d", "-name", "include" };
    const directories = b.run(&find_argv);
    var splits = std.mem.splitSequence(u8, directories, "\n");

    while (splits.next()) |include_dir| {
        // filter host headers
        if (std.mem.containsAtLeast(u8, include_dir, 1, "src/host")) {
            continue;
        }

        lib.addIncludePath(std.Build.LazyPath{ .path = include_dir });
    }

    //
    // Extra include folder for WIFI support
    //
    lib.defineCMacro("PICO_CYW43_ARCH_THREADSAFE_BACKGROUND", null);
    const cyw43_include = try std.fmt.allocPrint(
        b.allocator,
        "{s}/lib/cyw43-driver/src",
        .{sdk_path},
    );
    lib.addIncludePath(.{ .path = cyw43_include });

    const lwip_include = try std.fmt.allocPrint(
        b.allocator,
        "{s}/lib/lwip/src/include",
        .{sdk_path},
    );
    lib.addIncludePath(.{ .path = lwip_include });

    //
    // This folder contains:
    //
    // 1. Generated version file copied from SDK generated result (then you don't need to
    //    generate it manually).
    //
    //    Otherwise, you get error:
    //    src/common/pico_base/include/pico.h:25:10: error: 'pico/version.h' file not found
    //
    // 2. WIFI needed header file for Pico W
    //
    lib.addIncludePath(.{ .path = "extra_include/" });

    return lib;
}

///
/// 2. Run `cmake` to build the entire project and link the `zig-out/{output_obj_filename}`
///    to produce the `build/{CMAKE_PROJECT_NAME}.elf/uf2`
///
fn createCmakeCompilation(
    b: *std.Build,
    sdk_path: []const u8,
    obj_file_install_step: *std.Build.Step,
    cmake_project_name: []const u8,
) !*std.Build.Step.Run {
    //
    // create build directory
    //
    if (std.fs.cwd().makeDir("build")) |_| {} else |err| {
        if (err != error.PathAlreadyExists) return err;
    }

    const cmake_pico_sdk_path = b.fmt("-DPICO_SDK_PATH={s}", .{sdk_path});
    const cmake_argv = [_][]const u8{
        "cmake",
        "-B",
        "./build",
        "-S .",
        "-DPICO_BOARD=" ++ pico_board,
        cmake_pico_sdk_path,
    };
    const cmake_step = b.addSystemCommand(&cmake_argv);
    cmake_step.step.dependOn(obj_file_install_step);

    const threads = try std.Thread.getCpuCount();
    const make_thread_arg = try std.fmt.allocPrint(b.allocator, "-j{d}", .{threads});

    const make_argv = [_][]const u8{
        "make",
        "-C",
        "./build",
        make_thread_arg,
        cmake_project_name, // Only build the given target!!!
    };
    const make_step = b.addSystemCommand(&make_argv);
    make_step.step.dependOn(&cmake_step.step);

    return make_step;
}

///
/// Combind steps `1.` and `2.` into a single `zig build` step
///
pub fn create_build_step(
    b: *std.Build,
    pico_sdk_path: []const u8,
    step_name: []const u8,
    step_desc: []const u8,
    zig_src: []const u8,
    cmake_project_name: []const u8,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    custom_build_options: *std.Build.Step.Options,
) anyerror!void {
    //
    // 1.
    //
    const obj_lib = try createZigObjCompilation(
        b,
        pico_sdk_path,
        zig_src,
        cmake_project_name,
        target,
        optimize,
        custom_build_options,
    );
    const compiled = obj_lib.getEmittedBin();
    var obj_filename_buffer = [_]u8{0x00} ** 1024;
    const output_obj_filename = std.fmt.bufPrint(
        &obj_filename_buffer,
        "{s}.o",
        .{cmake_project_name},
    ) catch "";
    const install_step = b.addInstallFile(compiled, output_obj_filename);
    install_step.step.dependOn(&obj_lib.step);

    //
    // 2.
    //
    const cmake_step = try createCmakeCompilation(
        b,
        pico_sdk_path,
        &install_step.step,
        cmake_project_name,
    );

    //
    // Combine build step
    //
    const build_step = b.step(step_name, step_desc);
    build_step.dependOn(&cmake_step.step);
}

///
///
///
pub fn build(b: *std.Build) anyerror!void {
    //
    // The following env vars required!!!
    //
    // - `PICO_SDK_PATH` set to your pico-sdk git clone folder
    //
    // - `PICO_TOOLCHAIN_PATH` needed if `arm-none-eabi-gcc` doesn't in ypur `$PATH`
    //
    const pico_sdk_path = std.posix.getenv("PICO_SDK_PATH") orelse "";
    const pico_toolchain_path = std.posix.getenv("PICO_TOOLCHAIN_PATH") orelse "";
    _ = pico_toolchain_path;

    if (pico_sdk_path.len <= 0) {
        print(">>> [ build ] - Env var 'PICO_SDK_PATH' is required, configure failed.\n", .{});
        return BuildError.PicoSdkPathIsMissing;
    }

    //
    // RP2040 target, optimize and custom build options
    //
    const rp2040_target = b.resolveTargetQuery(.{
        .abi = .eabi,
        .cpu_arch = .thumb,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m0plus },
        .os_tag = .freestanding,
    });

    const optimize = b.standardOptimizeOption(.{
        // For best binary size
        .preferred_optimize_mode = std.builtin.OptimizeMode.ReleaseSmall,
    });

    const build_options = b.addOptions();
    build_options.addOption(bool, "enable_debug_log", b.option(
        bool,
        "enable_debug_log",
        "Enable debug log or not.",
    ) orelse false);

    // ---------------------------------------------------------------------------
    // Default usage echo step
    // ---------------------------------------------------------------------------
    const usage_echo_command = b.addSystemCommand(&[_][]const u8{
        "echo",
        "\n[ Available demo build commands ]\n\n" ++
            "zig-blink-builtin-led\n" ++
            "zig-blink-register\n" ++
            "touch-switch-button-demo\n" ++
            "ps-joystick-demo\n" ++
            "oled-1351-demo\n",
    });
    const default_step = b.step("help", "Show usage");
    default_step.dependOn(&usage_echo_command.step);
    b.default_step = default_step;

    // ---------------------------------------------------------------------------
    // Demo build steps
    // ---------------------------------------------------------------------------
    try create_build_step(
        b,
        pico_sdk_path,
        "zig-blink-builtin-led",
        "Blink PICO-W built-in LED.",
        "src/zig-blink-builtin-led.zig",
        "zig-blink-builtin-led",
        rp2040_target,
        optimize,
        build_options,
    );

    try create_build_step(
        b,
        pico_sdk_path,
        "zig-blink-register",
        "Blink LED on GPIO_0 pin by RP2040 register.",
        "src/zig-blink-register.zig",
        "zig-blink-register",
        rp2040_target,
        optimize,
        build_options,
    );

    try create_build_step(
        b,
        pico_sdk_path,
        "touch-switch-button-demo",
        "TouchSwitchButton driver demo.",
        "src/touch-switch-button-demo.zig",
        "touch-switch-button-demo",
        rp2040_target,
        optimize,
        build_options,
    );

    try create_build_step(
        b,
        pico_sdk_path,
        "ps-joystick-demo",
        "PS Joystick driver demo.",
        "src/ps-joystick-demo.zig",
        "ps-joystick-demo",
        rp2040_target,
        optimize,
        build_options,
    );

    try create_build_step(
        b,
        pico_sdk_path,
        "oled-1351-demo",
        "OLED SSD1351 demo.",
        "src/oled-1351-demo.zig",
        "oled-1351-demo",
        rp2040_target,
        optimize,
        build_options,
    );
}
