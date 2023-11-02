pub const c = @cImport({
    @cInclude("stdio.h");
    @cInclude("pico/stdlib.h");
});
const std = @import("std");
const CreateTouchSwitchButtonWithCallbackParameterType = @import("./utils/driver/button/touch-switch-button.zig").CreateTouchSwitchButtonWithCallbackParameterType;

//
// Button pins
//
// const BUTTON_1_PIN = 10; // Default pin
const BUTTON_2_PIN = 11;
const BUTTON_3_PIN = 12;

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

///
///
///
fn my_button_interrupt_callback(gpio: u32, event_mask: u32) callconv(.C) void {
    _ = event_mask;
    _ = gpio;
    _ = c.printf("\n>>> my_interrupt_callback");
}

///
///
///
fn button_1_pressed_callbcak(data: *const Game) void {
    _ = c.printf(
        "\n>>> button_1_press_callback, data (game name): %s",
        @as([*]const u8, @ptrCast(data.get_name())),
    );
}

///
///
///
fn button_2_pressed_callbcak(data: *const Game) void {
    _ = c.printf(
        "\n>>> button_2_press_callback, data (game name): %s",
        @as([*]const u8, @ptrCast(data.get_name())),
    );
}

///
///
///
fn button_3_pressed_callbcak(data: *const Game) void {
    _ = c.printf(
        "\n>>> button_3_press_callback, data (game name): %s",
        @as([*]const u8, @ptrCast(data.get_name())),
    );
}

///
///
///
const MyTouchSwitchButton = CreateTouchSwitchButtonWithCallbackParameterType(Game);

///
/// `export` the `main` in the compiled object file, then `CMake` is able to
/// link it to create the final ELF executable
///
export fn main() c_int {
    _ = c.stdio_init_all();

    _ = c.printf("\n>>> [ Zig Touch Switch Button Demo ]");

    const my_game = Game{
        ._name = "My fun game:)",
    };

    var button1 = MyTouchSwitchButton.init_with_default_settings(
        button_1_pressed_callbcak,
        &my_game,
    );

    var button2 = MyTouchSwitchButton.init(.{
        .signal_pin = BUTTON_2_PIN,
        .use_interrupt = false,
        .interrupt_callback = null,
        .callback = button_2_pressed_callbcak,
        .data_to_callback = &my_game,
    });

    const button3 = MyTouchSwitchButton.init(.{
        .signal_pin = BUTTON_3_PIN,
        .use_interrupt = true,
        .interrupt_callback = my_button_interrupt_callback,
        .callback = null,
        .data_to_callback = &my_game,
    });
    _ = button3;

    while (true) {
        button1.press_check();
        button2.press_check();
        c.sleep_ms(10);
    }
}
