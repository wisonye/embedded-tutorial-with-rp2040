pub const c = @cImport({
    @cInclude("stdio.h");
    @cInclude("pico/stdlib.h");
    // @cInclude("hardware/gpio.h");
});
const std = @import("std");
const build_options = @import("build_options");

///
/// GPIO10 (pin14 in pin diagram)
///
const TOUCH_SWITCH_BUTTON_DEFAULT_SIGNAL_PIN = 10;

///
/// Create `TouchSwitchButton` type
///
pub fn CreateTouchSwitchButtonWithCallbackParameterType(comptime T: type) type {
    return struct {
        ///
        /// Butto pressed callback
        ///
        pub const TouchSwitchButtonPressedCallback = ?*const fn (data: *const T) void;
        pub const TouchSwitchButtonInterruptCallback = ?*const fn (
            gpio: u32,
            event_mask: u32,
        ) callconv(.C) void;

        ///
        /// - `signal_pin`: set to GPIO10 (pin14 in pin diagram) by default.
        ///
        /// - `use_interrupt`:
        ///
        ///		If true, the given `callback` will be called when `signal_gpio`
        ///		goes through a GPIO_IRQ_EDGE_FALL (1 -> 0).
        ///
        ///		If false, you have to run `swb_press_check` periodically to
        ///		trigger the given `callback`.
        ///
        /// - `param_pass_to_callback`:
        ///		the extra data you want to pass to `callback`.
        ///
        pub const Config = struct {
            signal_pin: u8,
            use_interrupt: bool,
            interrupt_callback: TouchSwitchButtonInterruptCallback,
            callback: TouchSwitchButtonPressedCallback,
            data_to_callback: *const T,
        };

        config: Config,

        ///
        /// "Touch switch button" hardware returns `1` when the button doesn't press
        /// down and returns `0` when it has been pressed down.
        ///
        /// Fire once `pressed event` when encountering a `0 -> 1`
        ///
        last_press_down_sequence: [2]bool,

        const Self = @This();

        ///
        /// Init `TouchSwitchButton` instance with default settings, if you want to use custom PIN
        /// or trigger by interrupt, then you should call `TSB_init` instead.
        ///
        pub fn init_with_default_settings(
            comptime button_pressed_callback: TouchSwitchButtonPressedCallback,
            comptime data_to_callback: *const T,
        ) Self {
            const me: Self = .{
                .config = .{
                    .signal_pin = TOUCH_SWITCH_BUTTON_DEFAULT_SIGNAL_PIN,
                    .use_interrupt = false,
                    .interrupt_callback = null,
                    .callback = button_pressed_callback,
                    .data_to_callback = data_to_callback,
                },
                .last_press_down_sequence = [_]bool{ false, false },
            };

            if (build_options.enable_debug_log) {
                _ = c.printf(
                    "\n>>> [ TSB_init_with_default_settings ] - {" ++
                        "\n\tsignal_pin: GPIO_%d" ++
                        "\n\tuse_interrupt: %s" ++
                        "\n\tinterrupt_callback: %s" ++
                        "\n\tcallback: %s" ++
                        "\n}\n",
                    me.config.signal_pin,
                    if (me.config.use_interrupt) "true" else "false",
                    if (me.config.interrupt_callback == null) "NULL" else "interrupt_callback has been set",
                    if (me.config.callback == null) "NULL" else "callback has been set",
                );
            }

            //
            // Init and set GPIO to in and pull-up
            //
            c.gpio_init(me.config.signal_pin);
            c.gpio_set_dir(me.config.signal_pin, false);
            c.gpio_pull_up(me.config.signal_pin);

            if (build_options.enable_debug_log) {
                _ = c.printf(
                    "\n>>> [ TSB_init_with_default_settings ] - setup GPIO_%d successfully.\n",
                    me.config.signal_pin,
                );
            }

            return me;
        }

        ///
        /// Init `TouchSwitchButton` instance with custom settings
        ///
        /// When `use_interrupt` set to `true`, `interrupt_callback` has to be set, otherwise, compile
        /// time error.
        ///
        pub fn init(comptime config: Config) Self {
            if (config.use_interrupt and config.interrupt_callback == null) {
                @compileError("'interrupt_callback' has to be provided when 'use_interrupt' set to 'true'.");
            }

            const me: Self = .{
                .config = .{
                    .signal_pin = config.signal_pin,
                    .use_interrupt = config.use_interrupt,
                    .interrupt_callback = config.interrupt_callback,
                    .callback = config.callback,
                    .data_to_callback = config.data_to_callback,
                },
                .last_press_down_sequence = [_]bool{ false, false },
            };

            if (build_options.enable_debug_log) {
                _ = c.printf(
                    "\n>>> [ TSB_init ] - {" ++
                        "\n\tsignal_pin: GPIO_%d" ++
                        "\n\tuse_interrupt: %s" ++
                        "\n\tinterrupt_callback: %s" ++
                        "\n\tcallback: %s" ++
                        "\n}\n",
                    me.config.signal_pin,
                    if (me.config.use_interrupt) "true" else "false",
                    if (me.config.interrupt_callback == null) "NULL" else "interrupt_callback has been set",
                    if (me.config.callback == null) "NULL" else "callback has been set",
                );
            }

            //
            // Setup GPIO interrupt
            //
            if (me.config.use_interrupt) {
                c.gpio_set_irq_enabled_with_callback(
                    me.config.signal_pin,
                    c.GPIO_IRQ_EDGE_FALL,
                    true,
                    me.config.interrupt_callback,
                );

                if (build_options.enable_debug_log) {
                    _ = c.printf(
                        "\n>>> [ TSB_init ] - enable GPIO_%d interrupt successfully.\n",
                        me.config.signal_pin,
                    );
                }
            }
            //
            // Init and set GPIO to in and pull-up
            //
            else {
                c.gpio_init(me.config.signal_pin);
                c.gpio_set_dir(me.config.signal_pin, false);
                c.gpio_pull_up(me.config.signal_pin);

                if (build_options.enable_debug_log) {
                    _ = c.printf(
                        "\n>>> [ TSB_init ] - setup GPIO_%d successfully.\n",
                        me.config.signal_pin,
                    );
                }
            }

            return me;
        }

        ///
        /// When `self.config.use_interrupt` is ture, it does nothing!!!
        ///
        /// When `self.config.use_interrupt` is false, the given `callback` will be called when
        /// `signal_gpio` goes through a EDGE_FALL (1 -> 0).
        ///
        pub fn press_check(self: *Self) void {
            if (self.config.use_interrupt) return;

            const value: bool = c.gpio_get(self.config.signal_pin);

            // First `0`
            if (!value and !self.last_press_down_sequence[0]) {
                self.last_press_down_sequence[0] = true;
            }
            // Second `1`
            else if (value and self.last_press_down_sequence[0]) {
                self.last_press_down_sequence[1] = true;
            }

            // Pressed once
            if (self.last_press_down_sequence[0] and self.last_press_down_sequence[1]) {
                if (build_options.enable_debug_log) {
                    _ = c.printf("\n>>> [ TSB_press_check ] - touch switch button pressed once.\n");
                }

                // Reset
                self.last_press_down_sequence[0] = false;
                self.last_press_down_sequence[1] = false;

                // Invoke the callback
                if (self.config.callback != null) {
                    self.config.callback.?(self.config.data_to_callback);
                }
            }
        }
    };
}
