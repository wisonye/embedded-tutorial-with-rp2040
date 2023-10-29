///
/// How this build works???
///
/// 1. Compile the `src/main.zig` obj file and save it into `zig-out/{output_obj_filename}`
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
// This value (without the `.o`) has to be the same as the cmake project
// name in the `CMakeLists.txt`
//
const output_obj_filename = "zig-blink.o";

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
};

///
/// 1.
///
fn createZigObjCompilation(
    b: *std.Build,
    sdk_path: []const u8,
) BuildError!*std.Build.Step.Compile {
    //
    // RP2040 target
    //
    const target = std.zig.CrossTarget{
        .abi = .eabi,
        .cpu_arch = .thumb,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m0plus },
        .os_tag = .freestanding,
    };

    const optimize = b.standardOptimizeOption(.{
        // For best binary size
        .preferred_optimize_mode = std.builtin.OptimizeMode.ReleaseSmall,
    });

    //
    // Compile object step
    //
    const lib = b.addObject(.{
        .name = "zig-object",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    //
    // Default arm-none-eabi includes or from env var `ARM_STD_INCLUDE`
    //
    lib.linkLibC();
    lib.addSystemIncludePath(.{ .path = "/usr/arm-none-eabi/include" });
    if (std.os.getenv("ARM_STD_INCLUDE")) |arm_std_include_path| {
        lib.addSystemIncludePath(.{ .path = arm_std_include_path });
    }

    //
    // Search for board header file
    //
    var board_header_file: ?[]const u8 = null;

    const boards_directory_path = b.pathJoin(&.{ sdk_path, "src/boards/include/boards/" });
    var boards_dir = try std.fs.cwd().openIterableDir(boards_directory_path, .{});
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
    const directories = b.exec(&find_argv);
    var splits = std.mem.splitSequence(u8, directories, "\n");

    while (splits.next()) |include_dir| {
        // filter host headers
        if (std.mem.containsAtLeast(u8, include_dir, 1, "src/host")) {
            continue;
        }

        lib.addIncludePath(std.build.LazyPath{ .path = include_dir });
    }

    //
    // Extra include folder for WIFI support
    //
    lib.defineCMacroRaw("PICO_CYW43_ARCH_THREADSAFE_BACKGROUND");
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
/// 2.
///
fn createCmakeCompilation(
    b: *std.Build,
    sdk_path: []const u8,
    obj_file_install_step: *std.Build.Step,
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

    const make_argv = [_][]const u8{ "make", "-C", "./build", make_thread_arg };
    const make_step = b.addSystemCommand(&make_argv);
    make_step.step.dependOn(&cmake_step.step);

    return make_step;
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
    const pico_sdk_path = std.os.getenv("PICO_SDK_PATH") orelse "";
    const pico_toolchain_path = std.os.getenv("PICO_TOOLCHAIN_PATH") orelse "";
    _ = pico_toolchain_path;

    if (pico_sdk_path.len <= 0) {
        print(">>> [ build ] - Env var 'PICO_SDK_PATH' is required, configure failed.\n", .{});
        return BuildError.PicoSdkPathIsMissing;
    }

    const obj_lib = try createZigObjCompilation(b, pico_sdk_path);
    const compiled = obj_lib.getEmittedBin();
    const install_step = b.addInstallFile(compiled, output_obj_filename);
    install_step.step.dependOn(&obj_lib.step);

    const cmake_step = try createCmakeCompilation(b, pico_sdk_path, &install_step.step);
    b.default_step = &cmake_step.step;

    // const uf2_create_step = b.addInstallFile(.{ .path = "build/mlem.uf2" }, "firmware.uf2");
    // uf2_create_step.step.dependOn(&make_step.step);

    // const uf2_step = b.step("uf2", "Create firmware.uf2");
    // uf2_step.dependOn(&uf2_create_step.step);
    // b.default_step = uf2_step;
}
