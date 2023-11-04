pub const c = @cImport({
    @cInclude("stdio.h");
    @cInclude("pico/stdlib.h");
});
const std = @import("std");
const CreatePsJoystickWithCallbackParameterType = @import("./utils/driver/joystick/ps-joystick.zig").CreatePsJoystickWithCallbackParameterType;

///
///
///
const Game = struct {
    _name: []const u8,

    const Self = @This();

    pub fn init(game_name: []const u8) Self {
        return Self{
            ._name = game_name,
        };
    }

    pub fn get_name(self: *const Self) []const u8 {
        return self._name;
    }
};

fn long_press_callback(data: ?*const Game) void {
    _ = c.printf(
        "\n>>> long_press_callback, data (game name): %s",
        if (data) |d|
            @as([*]const u8, @ptrCast(d.get_name()))
        else
            "NULL",
    );
}

fn normal_click_callback(data: ?*const Game) void {
    _ = c.printf(
        "\n>>> normal_click_callback, data (game name): %s",
        if (data) |d|
            @as([*]const u8, @ptrCast(d.get_name()))
        else
            "NULL",
    );
}

fn touch_click_callback(data: ?*const Game) void {
    _ = c.printf(
        "\n>>> touch_click_callback, data (game name): %s",
        if (data) |d|
            @as([*]const u8, @ptrCast(d.get_name()))
        else
            "NULL",
    );
}

///
///
///
const MyPsJoyStick = CreatePsJoystickWithCallbackParameterType(Game);

///
/// `export` the `main` in the compiled object file, then `CMake` is able to
/// link it to create the final ELF executable
///
export fn main() c_int {
    _ = c.stdio_init_all();

    _ = c.printf("\n>>> [ Zig PS Joystick Demo ]");

    const my_game = Game{
        ._name = "My fun game:)",
    };

    var joystick = MyPsJoyStick.init(.{
        .x_axis_pin = null,
        .y_axis_pin = null,
        .z_axis_pin = null,
        .long_press_callback = long_press_callback,
        .normal_click_callback = normal_click_callback,
        .touch_click_callback = touch_click_callback,
        .callback_param = &my_game,
        .debug_print_type = MyPsJoyStick.DebugPrintType.Data,
    });

    // var joystick = MyPsJoyStick.init(.{
    //     .x_axis_pin = 10,
    //     .y_axis_pin = 11,
    //     .z_axis_pin = 12,
    //     .long_press_callback = null,
    //     .normal_click_callback = null,
    //     .touch_click_callback = null,
    //     .callback_param = null,
    //     .debug_print_type = MyPsJoyStick.DebugPrintType.Bar,
    // });

    while (true) {
        _ = joystick.update_status();
        c.sleep_ms(10);
    }
}
