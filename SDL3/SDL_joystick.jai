Joystick    :: void;
Joystick_ID :: u32;

Joystick_Connection_State :: enum s32
{
    INVALID :: -1;
    UNKNOWN;
    WIRED;
    WIRELESS;
}

PROP_JOYSTICK_CAP_MONO_LED_BOOLEAN          :: "SDL.joystick.cap.mono_led";
PROP_JOYSTICK_CAP_RGB_LED_BOOLEAN           :: "SDL.joystick.cap.rgb_led";
PROP_JOYSTICK_CAP_PLAYER_LED_BOOLEAN        :: "SDL.joystick.cap.player_led";
PROP_JOYSTICK_CAP_RUMBLE_BOOLEAN            :: "SDL.joystick.cap.rumble";
PROP_JOYSTICK_CAP_TRIGGER_RUMBLE_BOOLEAN    :: "SDL.joystick.cap.trigger_rumble";
