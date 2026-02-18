Gamepad :: void;

Gamepad_Type :: enum u32
{
    UNKNOWN :: 0;
    STANDARD;
    XBOX360;
    XBOXONE;
    PS3;
    PS4;
    PS5;
    NINTENDO_SWITCH_PRO;
    NINTENDO_SWITCH_JOYCON_LEFT;
    NINTENDO_SWITCH_JOYCON_RIGHT;
    NINTENDO_SWITCH_JOYCON_PAIR;
    COUNT;
}

Gamepad_Button :: enum s32
{
    INVALID :: -1;
    SOUTH;
    EAST;
    WEST;
    NORTH;
    BACK;
    GUIDE;
    START;
    LEFT_STICK;
    RIGHT_STICK;
    LEFT_SHOULDER;
    RIGHT_SHOULDER;
    DPAD_UP;
    DPAD_DOWN;
    DPAD_LEFT;
    DPAD_RIGHT;
    MISC1;
    RIGHT_PADDLE1;
    LEFT_PADDLE1;
    RIGHT_PADDLE2;
    LEFT_PADDLE2;
    TOUCHPAD;
    MISC2;
    MISC3;
    MISC4;
    MISC5;
    MISC6;
    COUNT;
}

Gamepad_Button_Label :: enum u32
{
    UNKNOWN;
    A;
    B;
    X;
    Y;
    CROSS;
    CIRCLE;
    SQUARE;
    TRIANGLE;
}

Gamepad_Axis :: enum s32
{
    INVALID :: -1;
    LEFTX;
    LEFTY;
    RIGHTX;
    RIGHTY;
    LEFT_TRIGGER;
    RIGHT_TRIGGER;
    COUNT;
}

Gamepad_Binding_Type :: enum u32
{
    NONE :: 0;
    BUTTON;
    AXIS;
    HAT;
}

Gamepad_Binding :: struct
{
    input_type: Gamepad_Binding_Type;
    input: union
    {
        button: s32;
        axis: struct {axis, axis_min, axis_max: u32;};
        hat : struct {hat, hat_mask: u32;};
    };

    output_type: Gamepad_Binding_Type;
    output: union
    {
        button: Gamepad_Button;
        axis: struct
        {
            axis: Gamepad_Axis;
            axis_min, axis_max: u32;
        };
    };
}

add_gamepad_mapping                          :: (mapping: *u8) -> s32                                                                                              #foreign SDL3 "SDL_AddGamepadMapping";
add_gamepad_mappings_from_io                 :: (src: *IO_Stream, close_io: bool) -> s32                                                                           #foreign SDL3 "SDL_AddGamepadMappingsFromIO";
add_gamepad_mappings_from_file               :: (file: *u8) -> s32                                                                                                 #foreign SDL3 "SDL_AddGamepadMappingsFromFile";
reload_gamepad_mappings                      :: () -> bool                                                                                                         #foreign SDL3 "SDL_ReloadGamepadMappings";
get_gamepad_mappings                         :: (count: *s32) -> **u8                                                                                              #foreign SDL3 "SDL_GetGamepadMappings";
get_gamepad_mapping_for_guid                 :: (guid: GUID) -> *u8                                                                                                #foreign SDL3 "SDL_GetGamepadMappingForGUID";
get_gamepad_mapping                          :: (gamepad: Gamepad) -> *u8                                                                                          #foreign SDL3 "SDL_GetGamepadMapping";
set_gamepad_mapping                          :: (instance_id: Joystick_ID, mapping: *u8) -> bool                                                                   #foreign SDL3 "SDL_SetGamepadMapping";
has_gamepad                                  :: () -> bool                                                                                                         #foreign SDL3 "SDL_HasGamepad";
get_gamepads                                 :: (count: *s32) -> *Joystick_ID                                                                                      #foreign SDL3 "SDL_GetGamepads";
is_gamepad                                   :: (instance_id: Joystick_ID) -> bool                                                                                 #foreign SDL3 "SDL_IsGamepad";
get_gamepad_name_for_id                      :: (instance_id: Joystick_ID) -> *u8                                                                                  #foreign SDL3 "SDL_GetGamepadNameForID";
get_gamepad_path_for_id                      :: (instance_id: Joystick_ID) -> *u8                                                                                  #foreign SDL3 "SDL_GetGamepadPathForID";
get_gamepad_player_index_for_id              :: (instance_id: Joystick_ID) -> s32                                                                                  #foreign SDL3 "SDL_GetGamepadPlayerIndexForID";
get_gamepad_guid_for_id                      :: (instance_id: Joystick_ID) -> GUID                                                                                 #foreign SDL3 "SDL_GetGamepadGUIDForID";
get_gamepad_vendor_for_id                    :: (instance_id: Joystick_ID) -> u16                                                                                  #foreign SDL3 "SDL_GetGamepadVendorForID";
get_gamepad_product_for_id                   :: (instance_id: Joystick_ID) -> u16                                                                                  #foreign SDL3 "SDL_GetGamepadProductForID";
get_gamepad_product_version_for_id           :: (instance_id: Joystick_ID) -> u16                                                                                  #foreign SDL3 "SDL_GetGamepadProductVersionForID";
get_gamepad_type_for_id                      :: (instance_id: Joystick_ID) -> Gamepad_Type                                                                         #foreign SDL3 "SDL_GetGamepadTypeForID";
get_real_gamepad_type_for_id                 :: (instance_id: Joystick_ID) -> Gamepad_Type                                                                         #foreign SDL3 "SDL_GetRealGamepadTypeForID";
get_gamepad_mapping_for_id                   :: (instance_id: Joystick_ID) -> *u8                                                                                  #foreign SDL3 "SDL_GetGamepadMappingForID";
open_gamepad                                 :: (instance_id: Joystick_ID) -> *Gamepad                                                                             #foreign SDL3 "SDL_OpenGamepad";
get_gamepad_from_id                          :: (instance_id: Joystick_ID) -> *Gamepad                                                                             #foreign SDL3 "SDL_GetGamepadFromID";
get_gamepad_from_player_index                :: (player_index: s32) -> *Gamepad                                                                                    #foreign SDL3 "SDL_GetGamepadFromPlayerIndex";
get_gamepad_properties                       :: (gamepad: *Gamepad) -> Properties_ID                                                                               #foreign SDL3 "SDL_GetGamepadProperties";
get_gamepad_id                               :: (gamepad: *Gamepad) -> Joystick_ID                                                                                 #foreign SDL3 "SDL_GetGamepadID";
get_gamepad_name                             :: (gamepad: *Gamepad) -> *u8                                                                                         #foreign SDL3 "SDL_GetGamepadName";
get_gamepad_path                             :: (gamepad: *Gamepad) -> *u8                                                                                         #foreign SDL3 "SDL_GetGamepadPath";
get_gamepad_type                             :: (gamepad: *Gamepad) -> Gamepad_Type                                                                                #foreign SDL3 "SDL_GetGamepadType";
get_real_gamepad_type                        :: (gamepad: *Gamepad) -> Gamepad_Type                                                                                #foreign SDL3 "SDL_GetRealGamepadType";
get_gamepad_player_index                     :: (gamepad: *Gamepad) -> s32                                                                                         #foreign SDL3 "SDL_GetGamepadPlayerIndex";
set_gamepad_player_index                     :: (gamepad: *Gamepad, player_index: s32) -> bool                                                                     #foreign SDL3 "SDL_SetGamepadPlayerIndex";
get_gamepad_vendor                           :: (gamepad: *Gamepad) -> u16                                                                                         #foreign SDL3 "SDL_GetGamepadVendor";
get_gamepad_product                          :: (gamepad: *Gamepad) -> u16                                                                                         #foreign SDL3 "SDL_GetGamepadProduct";
get_gamepad_product_version                  :: (gamepad: *Gamepad) -> u16                                                                                         #foreign SDL3 "SDL_GetGamepadProductVersion";
get_gamepad_firmware_version                 :: (gamepad: *Gamepad) -> u16                                                                                         #foreign SDL3 "SDL_GetGamepadFirmwareVersion";
get_gamepad_serial                           :: (gamepad: *Gamepad) -> *u8                                                                                         #foreign SDL3 "SDL_GetGamepadSerial";
get_gamepad_steam_handle                     :: (gamepad: *Gamepad) -> u64                                                                                         #foreign SDL3 "SDL_GetGamepadSteamHandle";
get_gamepad_connection_state                 :: (gamepad: *Gamepad) -> Joystick_Connection_State                                                                   #foreign SDL3 "SDL_GetGamepadConnectionState";
get_gamepad_power_info                       :: (gamepad: *Gamepad, percent: *s32) -> Power_State                                                                  #foreign SDL3 "SDL_GetGamepadPowerInfo";
gamepad_connected                            :: (gamepad: *Gamepad) -> bool                                                                                        #foreign SDL3 "SDL_GamepadConnected";
get_gamepad_joystick                         :: (gamepad: *Gamepad) -> *Joystick                                                                                   #foreign SDL3 "SDL_GetGamepadJoystick";
set_gamepad_events_enabled                   :: (enabled: bool)                                                                                                    #foreign SDL3 "SDL_SetGamepadEventsEnabled";
gamepad_events_enabled                       :: () -> bool                                                                                                         #foreign SDL3 "SDL_GamepadEventsEnabled";
get_gamepad_bindings                         :: (gamepad: *Gamepad, count: *s32) -> **Gamepad_Binding                                                              #foreign SDL3 "SDL_GetGamepadBindings";
update_gamepads                              :: ()                                                                                                                 #foreign SDL3 "SDL_UpdateGamepads";
get_gamepad_type_from_string                 :: (str: *u8) -> Gamepad_Type                                                                                         #foreign SDL3 "SDL_GetGamepadTypeFromString";
get_gamepad_string_for_type                  :: (type: Gamepad_Type) -> *u8                                                                                        #foreign SDL3 "SDL_GetGamepadStringForType";
get_gamepad_axis_from_string                 :: (str: *u8) -> Gamepad_Axis                                                                                         #foreign SDL3 "SDL_GetGamepadAxisFromString";
get_gamepad_string_for_axis                  :: (axis: Gamepad_Axis) -> *u8                                                                                        #foreign SDL3 "SDL_GetGamepadStringForAxis";
gamepad_has_axis                             :: (gamepad: *Gamepad, axis: Gamepad_Axis) -> bool                                                                    #foreign SDL3 "SDL_GamepadHasAxis";
get_gamepad_axis                             :: (gamepad: *Gamepad, axis: Gamepad_Axis) -> s16                                                                     #foreign SDL3 "SDL_GetGamepadAxis";
get_gamepad_button_from_string               :: (str: *u8) -> Gamepad_Button                                                                                       #foreign SDL3 "SDL_GetGamepadButtonFromString";
get_gamepad_string_for_button                :: (button: Gamepad_Button) -> *u8                                                                                    #foreign SDL3 "SDL_GetGamepadStringForButton";
gamepad_has_button                           :: (gamepad: *Gamepad, button: Gamepad_Button) -> bool                                                                #foreign SDL3 "SDL_GamepadHasButton";
get_gamepad_button                           :: (gamepad: *Gamepad, button: Gamepad_Button) -> bool                                                                #foreign SDL3 "SDL_GetGamepadButton";
get_gamepad_button_label_for_type            :: (type: Gamepad_Type, button: Gamepad_Button) -> Gamepad_Button_Label                                               #foreign SDL3 "SDL_GetGamepadButtonLabelForType";
get_gamepad_button_label                     :: (gamepad: *Gamepad, button: Gamepad_Button) -> Gamepad_Button_Label                                                #foreign SDL3 "SDL_GetGamepadButtonLabel";
get_num_gamepad_touchpads                    :: (gamepad: *Gamepad) -> s32                                                                                         #foreign SDL3 "SDL_GetNumGamepadTouchpads";
get_num_gamepad_touchpad_fingers             :: (gamepad: *Gamepad, touchpad: s32) -> s32                                                                          #foreign SDL3 "SDL_GetNumGamepadTouchpadFingers";
get_gamepad_touchpad_finger                  :: (gamepad: *Gamepad, touchpad: s32, finger: s32, down: *bool, x: *float32, y: *float32, pressure: *float32) -> bool #foreign SDL3 "SDL_GetGamepadTouchpadFinger";
gamepad_has_sensor                           :: (gamepad: *Gamepad, type: Sensor_Type) -> bool                                                                     #foreign SDL3 "SDL_GamepadHasSensor";
set_gamepad_sensor_enabled                   :: (gamepad: *Gamepad, type: Sensor_Type, enabled: bool) -> bool                                                      #foreign SDL3 "SDL_SetGamepadSensorEnabled";
gamepad_sensor_enabled                       :: (gamepad: *Gamepad, type: Sensor_Type) -> bool                                                                     #foreign SDL3 "SDL_GamepadSensorEnabled";
get_gamepad_sensor_data_rate                 :: (gamepad: *Gamepad, type: Sensor_Type) -> float32                                                                  #foreign SDL3 "SDL_GetGamepadSensorDataRate";
get_gamepad_sensor_data                      :: (gamepad: *Gamepad, type: Sensor_Type, data: *float32, num_values: s32) -> bool                                    #foreign SDL3 "SDL_GetGamepadSensorData";
rumble_gamepad                               :: (gamepad: *Gamepad, low_frequency_rumble: u16, high_frequency_rumble: u16, duration_ms: u32) -> bool               #foreign SDL3 "SDL_RumbleGamepad";
rumble_gamepad_triggers                      :: (gamepad: *Gamepad, left_rumble: u16, right_rumble: u16, duration_ms: u32) -> bool                                 #foreign SDL3 "SDL_RumbleGamepadTriggers";
set_gamepad_led                              :: (gamepad: *Gamepad, red: u8, green: u8, blue: u8) -> bool                                                          #foreign SDL3 "SDL_SetGamepadLED";
send_gamepad_effect                          :: (gamepad: *Gamepad, data: *void, size: s32) -> bool                                                                #foreign SDL3 "SDL_SendGamepadEffect";
close_gamepad                                :: (gamepad: *Gamepad)                                                                                                #foreign SDL3 "SDL_CloseGamepad";
get_gamepad_apple_sf_symbols_name_for_button :: (gamepad: *Gamepad, button: Gamepad_Button) -> *u8                                                                 #foreign SDL3 "SDL_GetGamepadAppleSFSymbolsNameForButton";
get_gamepad_apple_sf_symbols_name_for_axis   :: (gamepad: *Gamepad, axis: Gamepad_Axis) -> *u8                                                                     #foreign SDL3 "SDL_GetGamepadAppleSFSymbolsNameForAxis";


PROP_GAMEPAD_CAP_MONO_LED_BOOLEAN       :: PROP_JOYSTICK_CAP_MONO_LED_BOOLEAN;
PROP_GAMEPAD_CAP_RGB_LED_BOOLEAN        :: PROP_JOYSTICK_CAP_RGB_LED_BOOLEAN;
PROP_GAMEPAD_CAP_PLAYER_LED_BOOLEAN     :: PROP_JOYSTICK_CAP_PLAYER_LED_BOOLEAN;
PROP_GAMEPAD_CAP_RUMBLE_BOOLEAN         :: PROP_JOYSTICK_CAP_RUMBLE_BOOLEAN;
PROP_GAMEPAD_CAP_TRIGGER_RUMBLE_BOOLEAN :: PROP_JOYSTICK_CAP_TRIGGER_RUMBLE_BOOLEAN;
