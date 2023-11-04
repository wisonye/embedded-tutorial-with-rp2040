pub const c = @cImport({
    @cInclude("stdio.h");
    @cInclude("pico/stdlib.h");
    @cInclude("hardware/adc.h");
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
        pub const PSJoystickTouchClickCallback = ?*const fn (data: *const T) void;
        pub const PSJoystickNormalClickCallback = ?*const fn (data: *const T) void;
        pub const PSJoystickLongPressCallback = ?*const fn (data: *const T) void;

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

        ///
        ///
        ///
        pub const PSJoystickDirection = enum {
            PSJoystick_X_DIRECTION_LEFT,
            PSJoystick_X_DIRECTION_CENTER,
            PSJoystick_X_DIRECTION_RIGHT,
            PSJoystick_Y_DIRECTION_UP,
            PSJoystick_Y_DIRECTION_CENTER,
            PSJoystick_Y_DIRECTION_DOWN,
        };

        ///
        /// When `_direction == _DIRECTION_CENTER`, `_movement_percentage` is 0.
        ///
        /// Otherwise, `_movement_percentage` means the radius percentage in the given direction (how
        /// far from the center point to the edge):
        ///
        const PSJoystickUpdateResult = struct {
            x_direction: PSJoystickDirection,
            y_direction: PSJoystickDirection,
            x_movement_percentage: f16,
            y_movement_percentage: f16,
        };

        config: Config,

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

            return me;
        }

        ///
        ///
        ///
        pub fn update_status(self: *Self) PSJoystickUpdateResult {
            _ = self;
        }
    };
}
