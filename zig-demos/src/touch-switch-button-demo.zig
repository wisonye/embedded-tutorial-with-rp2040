pub const c = @cImport({
    @cInclude("stdio.h");
    @cInclude("pico/stdlib.h");
});
const std = @import("std");
const CreateTouchSwitchButtonWithCallbackParameterType = @import("./utils/driver/button/touch-switch-button.zig").CreateTouchSwitchButtonWithCallbackParameterType;

const Game = struct {
    name: []const u8,
};

///
///
///
fn my_button_interrupt_callback(gpio: u32, event_mask: u32) void {
    _ = event_mask;
    _ = gpio;
    _ = c.printf("\n>>> my_interrupt_callback", .{});
}

///
///
///
fn button_1_pressed_callbcak(data: *const Game) void {
    _ = data;
    _ = c.printf("\n>>> button_1_press_callback");
}

///
///
///
fn button_2_pressed_callbcak(data: *const Game) void {
    _ = data;
    _ = c.printf("\n>>> button_2_press_callback");
}

///
///
///
fn button_3_pressed_callbcak(data: *const Game) void {
    _ = data;
    c.print("\n>>> button_3_press_callback");
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
        .name = "Fun Game",
    };

    var button1 = MyTouchSwitchButton.init_with_default_settings(
        button_1_pressed_callbcak,
        &my_game,
    );

    var button2 = MyTouchSwitchButton.init(.{
        .signal_pin = 11,
        .use_interrupt = false,
        .interrupt_callback = null,
        .callback = button_2_pressed_callbcak,
        .data_to_callback = &my_game,
    });

    while (true) {
        button1.press_check();
        button2.press_check();
        c.sleep_ms(10);
    }
}
