Touch_ID  :: u64;
Finger_ID :: u64;

MOUSE_TOUCHID :: (cast,no_check(Touch_ID) -1);
TOUCH_MOUSEID :: (cast,no_check(Mouse_ID) -1);

Finger :: struct {
    id       : Finger_ID;
    x        : float32;
    y        : float32;
    pressure : float32;
}

get_touch_devices :: (count : *s32) -> *Touch_ID #foreign SDL3 "SDL_GetTouchDevices";
get_touch_fingers :: (touchID : Touch_ID, count : *s32) -> **Finger #foreign SDL3 "SDL_GetTouchFingers";
