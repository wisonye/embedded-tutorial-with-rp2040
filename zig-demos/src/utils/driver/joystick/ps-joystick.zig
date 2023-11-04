pub const c = @cImport({
    @cInclude("stdio.h");
    @cInclude("pico/stdlib.h");
    @cInclude("hardware/adc.h");
    //
    // Make sure you use `f32` instead of `f16`, otherwise, you will see the
    // the following linking error:
    //
    // undefined reference to `__aeabi_f2h'
    // collect2: error: ld returned 1 exit status
    //
    @cInclude("pico/float.h");
});

const std = @import("std");
const build_options = @import("build_options");

//
// Why ADC max value is `(1 << 12)`, that's because RP2040 `ADC: RESULT
// Register` use 12 bits to store the simpling result.
//
// Register info located in "RP2040 datasheet"
// Chapter 4.9. ADC and Temperature Sensor, page 567
//
const ADC_MAX_RESULT: u16 = (1 << 12);

//
// GPIO26 ADC0 (pin31 in pin diagram) - X axis
// GPIO27 ADC1 (pin32 in pin diagram) - Y axis
// GPIO28 ADC2 (pin34 in pin diagram) - Z axis
//
const JOYSTICK_X_AXIS_PIN: u8 = 26;
const JOYSTICK_Y_AXIS_PIN: u8 = 27;
const JOYSTICK_Z_AXIS_PIN: u8 = 28;

//
//                     0
//
//                     ^
//                     |
//                     |
//                   YUVSF
//                   ------
//                 |   |    |
//                 |   |    |
// 0 < --- XLVSF --| Center | -- XRVSF ---> (ADC_MAX_RESULT)
//                 |   |    |
//                 |   |    |
//                   ------
//                   YDVSF
//                     |
//                     |
//                     v
//             (ADC_MAX_RESULT)
//
//
// Think about this as your joystick bird-view angle and movement range.
// The X/Y axis ADC value is 0 ~ ADC_MAX_RESULT (4096 - 1), that means:
//
// 1. Center point ADC value should be 2048 - 1, but it has a drift value range in fact
//    which is represented by the center box in the diagram even if you don't touch the
//    joystick.
//
// 2. That's why:
//    - XLVSF (X Left Value Start From) set to 1800 (out of the drift range)
//    - XRVSF (X Right Value Start From) set to 2200 (out of the drift range)
//    - YUVSF (Y Up Value Start From) set to 1800 (out of the drift range)
//    - YDVSF (Y Down Value Start From) set to 2200 (out of the drift range)
//
const JOYSTICK_X_LEFT_VALUE_START_FROM: u16 = 1800;
const JOYSTICK_X_RIGHT_VALUE_START_FROM: u16 = 2200;
const JOYSTICK_Y_UP_VALUE_START_FROM: u16 = 1800;
const JOYSTICK_Y_DOWN_VALUE_START_FROM: u16 = 2200;
const JOYSTICK_X_LEFT_RADIUS: u16 = 1800;
const JOYSTICK_X_RIGHT_RADIUS: u16 = (ADC_MAX_RESULT - 2200);
const JOYSTICK_Y_UP_RADIUS: u16 = 1800;
const JOYSTICK_Y_DOWN_RADIUS: u16 = (ADC_MAX_RESULT - 2200);

///
///
///
pub fn CreatePsJoystickWithCallbackParameterType(comptime T: type) type {
    return struct {
        //
        // Callback
        //
        pub const PSJoystickTouchClickCallback = ?*const fn (data: ?*const T) void;
        pub const PSJoystickNormalClickCallback = ?*const fn (data: ?*const T) void;
        pub const PSJoystickLongPressCallback = ?*const fn (data: ?*const T) void;

        ///
        ///
        ///
        const DebugPrintTypeLookupTable = [_][]const u8{
            "None",
            "Data", // Only works when defined "ENABLE_DEBUG_PRINT" macro
            "Bar", // Only works when defined "ENABLE_DEBUG_PRINT" macro
        };

        pub const DebugPrintType = enum {
            None,
            Data, // Only works when defined "ENABLE_DEBUG_PRINT" macro
            Bar, // Only works when defined "ENABLE_DEBUG_PRINT" macro
        };

        pub const Config = struct {
            x_axis_pin: ?u8,
            y_axis_pin: ?u8,
            z_axis_pin: ?u8,
            debug_print_type: DebugPrintType,
            callback_param: ?*const T,
            touch_click_callback: PSJoystickTouchClickCallback,
            normal_click_callback: PSJoystickNormalClickCallback,
            long_press_callback: PSJoystickLongPressCallback,
        };

        //
        // Direction description lookup table
        //
        const DirectionDescLookupTable = [_][]const u8{
            "X_LEFT",
            "X_CENTER",
            "X_RIGHT",
            "Y_UP",
            "Y_CENTER",
            "Y_DOWN",
        };

        ///
        ///
        ///
        pub const Direction = enum {
            X_DIRECTION_LEFT,
            X_DIRECTION_CENTER,
            X_DIRECTION_RIGHT,
            Y_DIRECTION_UP,
            Y_DIRECTION_CENTER,
            Y_DIRECTION_DOWN,
        };

        ///
        /// When `_direction == _DIRECTION_CENTER`, `_movement_percentage` is 0.
        ///
        /// Otherwise, `_movement_percentage` means the radius percentage in the given direction (how
        /// far from the center point to the edge):
        ///
        const PSJoystickUpdateResult = struct {
            x_direction: Direction,
            y_direction: Direction,
            x_movement_percentage: f32,
            y_movement_percentage: f32,
        };

        config: Config,

        //
        // Joystick press down amount
        //
        // Z-axis value:
        //
        // 650 ~ 850: normal state,
        // <= 20: press down
        //
        // For generating the `touch click/normal click/long press` event, you need to
        // count how long value has been less than 10:
        //
        // Touch click: at least happen once
        // Normal click: at least happen third times
        // Long press click: at least happen eight times
        //
        joystick_has_been_pressed_down: bool,
        press_down_happened_amount: u16,

        const Self = @This();

        ///
        ///
        ///
        pub fn init(comptime config: Config) Self {
            const me: Self = .{
                .config = .{
                    .x_axis_pin = config.x_axis_pin orelse JOYSTICK_X_AXIS_PIN,
                    .y_axis_pin = config.y_axis_pin orelse JOYSTICK_Y_AXIS_PIN,
                    .z_axis_pin = config.z_axis_pin orelse JOYSTICK_Z_AXIS_PIN,
                    .long_press_callback = config.long_press_callback,
                    .normal_click_callback = config.normal_click_callback,
                    .touch_click_callback = config.touch_click_callback,
                    .callback_param = config.callback_param,
                    .debug_print_type = config.debug_print_type,
                },
                .joystick_has_been_pressed_down = false,
                .press_down_happened_amount = 0,
            };

            if (build_options.enable_debug_log) {
                const debug_type_str = DebugPrintTypeLookupTable[@intFromEnum(me.config.debug_print_type)];
                _ = c.printf(
                    "\n>>> [ PsJoystick > init ] - {" ++
                        "\n\tx_axis_pin: GPIO_%d" ++
                        "\n\ty_axis_pin: GPIO_%d" ++
                        "\n\tz_axis_pin: GPIO_%d" ++
                        "\n\tdebug_print_type: %s" ++
                        "\n\tlong_press_callback: %s" ++
                        "\n\tnormal_click_callback: %s" ++
                        "\n\ttouch_click_callback: %s" ++
                        "\n\tcallback_param: %s" ++
                        "\n}\n",
                    me.config.x_axis_pin.?,
                    me.config.y_axis_pin.?,
                    me.config.z_axis_pin.?,
                    @as([*]const u8, @ptrCast(debug_type_str)),
                    if (me.config.long_press_callback == null) "NULL" else "long_press_callback has been set",
                    if (me.config.normal_click_callback == null) "NULL" else "normal_click_callback has been set",
                    if (me.config.touch_click_callback == null) "NULL" else "touch_click_callback has been set",
                    if (me.config.callback_param == null) "NULL" else "callback_param has been set",
                );
            }

            _ = c.adc_init();
            _ = c.adc_gpio_init(JOYSTICK_X_AXIS_PIN);
            _ = c.adc_gpio_init(JOYSTICK_Y_AXIS_PIN);
            _ = c.adc_gpio_init(JOYSTICK_Z_AXIS_PIN);

            if (build_options.enable_debug_log) {
                _ = c.printf(">>> [ PsJoystick > init ] - Init config done.\n");
            }

            return me;
        }

        ///
        ///
        ///
        pub fn update_status(self: *Self) PSJoystickUpdateResult {
            _ = c.adc_select_input(0);
            const adc_x_raw = c.adc_read();
            _ = c.adc_select_input(1);
            const adc_y_raw = c.adc_read();
            _ = c.adc_select_input(2);
            const adc_z_raw = c.adc_read();

            //
            // X axis
            //
            var x_direction: Direction = Direction.X_DIRECTION_CENTER;
            var x_movement_percentage: f32 = 0;

            // Center
            if (adc_x_raw >= JOYSTICK_X_LEFT_VALUE_START_FROM and
                adc_x_raw <= JOYSTICK_X_RIGHT_VALUE_START_FROM)
            {
                x_direction = Direction.X_DIRECTION_CENTER;
            }
            // Left
            else if (adc_x_raw < JOYSTICK_X_LEFT_VALUE_START_FROM) {
                x_direction = Direction.X_DIRECTION_LEFT;

                //
                // % measurement is start from the center point!!!
                //
                x_movement_percentage =
                    1.0 - (@as(f32, @floatFromInt(adc_x_raw)) / @as(f16, @floatFromInt(JOYSTICK_X_LEFT_RADIUS)));
            }
            // Right
            else if (adc_x_raw > JOYSTICK_X_RIGHT_VALUE_START_FROM) {
                x_direction = Direction.X_DIRECTION_RIGHT;

                //
                // % measurement is start from the center point!!!
                //
                x_movement_percentage =
                    (@as(f32, @floatFromInt(adc_x_raw)) -
                    @as(f32, @floatFromInt(JOYSTICK_X_RIGHT_VALUE_START_FROM))) /
                    @as(f32, @floatFromInt(JOYSTICK_X_RIGHT_RADIUS));
            }

            //
            // y axis
            //
            var y_direction: Direction = Direction.Y_DIRECTION_CENTER;
            var y_movement_percentage: f32 = 0;

            // Center
            if (adc_y_raw >= JOYSTICK_Y_UP_VALUE_START_FROM and
                adc_y_raw <= JOYSTICK_Y_DOWN_VALUE_START_FROM)
            {
                y_direction = Direction.Y_DIRECTION_CENTER;
            }
            // Up
            else if (adc_y_raw < JOYSTICK_Y_UP_VALUE_START_FROM) {
                y_direction = Direction.Y_DIRECTION_UP;

                //
                // % measurement is start from the center point!!!
                //
                y_movement_percentage =
                    1.0 - (@as(f32, @floatFromInt(adc_y_raw)) / @as(f16, @floatFromInt(JOYSTICK_Y_UP_RADIUS)));
            }
            // Down
            else if (adc_y_raw > JOYSTICK_Y_DOWN_VALUE_START_FROM) {
                y_direction = Direction.Y_DIRECTION_DOWN;

                //
                // % measurement is start from the center point!!!
                //
                y_movement_percentage =
                    (@as(f32, @floatFromInt(adc_y_raw)) -
                    @as(f32, @floatFromInt(JOYSTICK_Y_DOWN_VALUE_START_FROM))) /
                    @as(f32, @floatFromInt(JOYSTICK_Y_DOWN_RADIUS));
            }

            if (build_options.enable_debug_log) {
                switch (self.config.debug_print_type) {
                    DebugPrintType.Data => {
                        const x_tab_buffer = if (adc_x_raw >= 10) "\t" else "\t\t";
                        // char *y_tab_buffer = adc_y_raw >= 100 ? "\t" : "\t\t";
                        _ = c.printf(
                            "\n>>> [ ps_joystick_init ] - x: %d%s(%s, %.4f\\%), \ty: %d\t(%s, %.4f\\%), \tz: %d",
                            adc_x_raw,
                            @as([*]const u8, @ptrCast(x_tab_buffer)),
                            @as([*]const u8, @ptrCast(DirectionDescLookupTable[@intFromEnum(x_direction)])),
                            x_movement_percentage,
                            adc_y_raw,
                            @as([*]const u8, @ptrCast(DirectionDescLookupTable[@intFromEnum(y_direction)])),
                            y_movement_percentage,
                            adc_z_raw,
                        );
                    },
                    DebugPrintType.Bar => {
                        // Display the joystick position something like this :
                        // X: [     o     ] Y: [     o     ] Z: [     o     ]
                        const bar_width: u16 = 30;
                        const adc_max: u16 = ADC_MAX_RESULT - 1;
                        const bar_x_pos: u16 = adc_x_raw * bar_width / adc_max;
                        const bar_y_pos: u16 = adc_y_raw * bar_width / adc_max;
                        const bar_z_pos: u16 = adc_z_raw * bar_width / adc_max;

                        _ = c.printf("\rX: [");
                        for (0..bar_width) |i| {
                            _ = c.putchar(if (i == bar_x_pos) 'o' else ' ');
                        }

                        _ = c.printf("]  Y: [");
                        for (0..bar_width) |i| {
                            _ = c.putchar(if (i == bar_y_pos) 'o' else ' ');
                        }

                        _ = c.printf("] Z: [");
                        for (0..bar_width) |i| {
                            _ = c.putchar(if (i == bar_z_pos) 'o' else ' ');
                        }
                        _ = c.printf("]");
                    },
                    else => {},
                }
            }

            //
            // z axis events
            //
            const current_press_down_status = adc_z_raw <= 20;

            // Before state is pressed down and now it not, generate event
            if (!current_press_down_status and self.joystick_has_been_pressed_down) {
                // Long press click: at least happen eight times
                if (self.press_down_happened_amount >= 8) {
                    if (self.config.long_press_callback) |long_press_callback| {
                        long_press_callback(self.config.callback_param);
                    }
                }
                // Normal click: at least happen third times
                else if (self.press_down_happened_amount >= 3) {
                    if (self.config.normal_click_callback) |normal_click_callback| {
                        normal_click_callback(self.config.callback_param);
                    }
                }
                // Touch click: at least happen once
                else if (self.press_down_happened_amount >= 1) {
                    if (self.config.touch_click_callback) |touch_click_callback| {
                        touch_click_callback(self.config.callback_param);
                    }
                }

                // Reset state
                self.joystick_has_been_pressed_down = false;
                self.press_down_happened_amount = 0;
            }
            // Entry press down state
            else if (current_press_down_status and !self.joystick_has_been_pressed_down) {
                self.joystick_has_been_pressed_down = true;
                self.press_down_happened_amount = 1;
            }
            // Keep pressing down
            else if (current_press_down_status and
                self.joystick_has_been_pressed_down and
                self.press_down_happened_amount > 0)
            {
                self.press_down_happened_amount += 1;
            }

            return (PSJoystickUpdateResult){
                .x_direction = x_direction,
                .y_direction = y_direction,
                .x_movement_percentage = x_movement_percentage,
                .y_movement_percentage = y_movement_percentage,
            };
        }
    };
}
