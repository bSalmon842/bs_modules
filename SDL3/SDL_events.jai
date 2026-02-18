Event_Type :: enum u32
{
    FIRST                          :: 0;

    // Application events
    QUIT                           :: 0x100;

    // Android/iOS events
    TERMINATING;
    LOW_MEMORY;
    WILL_ENTER_BACKGROUND;
    DID_ENTER_BACKGROUND;
    WILL_ENTER_FOREGROUND;
    DID_ENTER_FOREGROUND;
    LOCALE_CHANGED;
    SYSTEM_THEME_CHANGED;

    // Display events
    DISPLAY_ORIENTATION            :: 0x151;
    DISPLAY_ADDED;
    DISPLAY_REMOVED;
    DISPLAY_MOVED;
    DISPLAY_DESKTOP_MODE_CHANGED;
    DISPLAY_CURRENT_MODE_CHANGED;
    DISPLAY_CONTENT_SCALE_CHANGED;
    DISPLAY_FIRST :: DISPLAY_ORIENTATION;
    DISPLAY_LAST :: DISPLAY_CONTENT_SCALE_CHANGED;

    // Window events
    WINDOW_SHOWN                   :: 0x202;
    WINDOW_HIDDEN;
    WINDOW_EXPOSED;
    WINDOW_MOVED;
    WINDOW_RESIZED;
    WINDOW_PIXEL_SIZE_CHANGED;
    WINDOW_METAL_VIEW_RESIZED;
    WINDOW_MINIMIZED;
    WINDOW_MAXIMIZED;
    WINDOW_RESTORED;
    WINDOW_MOUSE_ENTER;
    WINDOW_MOUSE_LEAVE;
    WINDOW_FOCUS_GAINED;
    WINDOW_FOCUS_LOST;
    WINDOW_CLOSE_REQUESTED;
    WINDOW_HIT_TEST;
    WINDOW_ICCPROF_CHANGED;
    WINDOW_DISPLAY_CHANGED;
    WINDOW_DISPLAY_SCALE_CHANGED;
    WINDOW_SAFE_AREA_CHANGED;
    WINDOW_OCCLUDED;
    WINDOW_ENTER_FULLSCREEN;
    WINDOW_LEAVE_FULLSCREEN;
    WINDOW_DESTROYED;
    WINDOW_HDR_STATE_CHANGED;
    WINDOW_FIRST :: WINDOW_SHOWN;
    WINDOW_LAST :: WINDOW_HDR_STATE_CHANGED;

    // Keyboard events
    KEY_DOWN                       :: 0x300;
    KEY_UP;
    TEXT_EDITING;
    TEXT_INPUT;
    KEYMAP_CHANGED;
    KEYBOARD_ADDED;
    KEYBOARD_REMOVED;
    TEXT_EDITING_CANDIDATES;

    // Mouse events
    MOUSE_MOTION                   :: 0x400;
    MOUSE_BUTTON_DOWN;
    MOUSE_BUTTON_UP;
    MOUSE_WHEEL;
    MOUSE_ADDED;
    MOUSE_REMOVED;

    // Joystick events
    JOYSTICK_AXIS_MOTION           :: 0x600;
    JOYSTICK_BALL_MOTION;
    JOYSTICK_HAT_MOTION;
    JOYSTICK_BUTTON_DOWN;
    JOYSTICK_BUTTON_UP;
    JOYSTICK_ADDED;
    JOYSTICK_REMOVED;
    JOYSTICK_BATTERY_UPDATED;
    JOYSTICK_UPDATE_COMPLETE;

    // Gamepad events
    GAMEPAD_AXIS_MOTION            :: 0x650;
    GAMEPAD_BUTTON_DOWN;
    GAMEPAD_BUTTON_UP;
    GAMEPAD_ADDED;
    GAMEPAD_REMOVED;
    GAMEPAD_REMAPPED;
    GAMEPAD_TOUCHPAD_DOWN;
    GAMEPAD_TOUCHPAD_MOTION;
    GAMEPAD_TOUCHPAD_UP;
    GAMEPAD_SENSOR_UPDATE;
    GAMEPAD_UPDATE_COMPLETE;
    GAMEPAD_STEAM_HANDLE_UPDATED;

    // Touch events
    FINGER_DOWN                    :: 0x700;
    FINGER_UP;
    FINGER_MOTION;

    // Clipboard events
    CLIPBOARD_UPDATE               :: 0x900;

    // Drag and drop events
    DROP_FILE                      :: 0x1000;
    DROP_TEXT;
    DROP_BEGIN;
    DROP_COMPLETE;
    DROP_POSITION;

    // Audio hotplug events
    AUDIO_DEVICE_ADDED             :: 0x1100;
    AUDIO_DEVICE_REMOVED;
    AUDIO_DEVICE_FORMAT_CHANGED;

    // Sensor events
    SENSOR_UPDATE                  :: 0x1200;

    // Pressure-sensitive pen events
    PEN_PROXIMITY_IN               :: 0x1300;
    PEN_PROXIMITY_OUT;
    PEN_DOWN;
    PEN_UP;
    PEN_BUTTON_DOWN;
    PEN_BUTTON_UP;
    PEN_MOTION;
    PEN_AXIS;

    // Camera hotplug events
    CAMERA_DEVICE_ADDED            :: 0x1400;
    CAMERA_DEVICE_REMOVED;
    CAMERA_DEVICE_APPROVED;
    CAMERA_DEVICE_DENIED;

    // Render events
    RENDER_TARGETS_RESET           :: 0x2000;
    RENDER_DEVICE_RESET;
    RENDER_DEVICE_LOST;

    // Reserved events for private platforms
    PRIVATE0                       :: 0x4000;
    PRIVATE1;
    PRIVATE2;
    PRIVATE3;

    // Internal events
    POLL_SENTINEL                  :: 0x7F00;

    // Events USER through LAST are for your use, and should be allocated with RegisterEvents()
    USER                           :: 0x8000;

    // This last event is only for bounding internal arrays
    LAST                           :: 0xFFFF;

    // This just makes sure the enum is the size of Uint32
    ENUM_PADDING                   :: 0x7FFFFFFF;
}

Common_Event :: struct
{
    type:      u32;
    reserved:  u32;
    timestamp: u64;
}

Display_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    displayID: Display_ID;
    data1:     s32;
    data2:     s32;
}

Window_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    windowID:  Window_ID;
    data1:     s32;
    data2:     s32;
}

Keyboard_Device_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    which:     Keyboard_ID;
}

Keyboard_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    windowID:  Window_ID;
    which:     Keyboard_ID;
    scancode:  Scancode;
    key:       Keycode;
    mod:       Keymod;
    raw:       u16;
    down:      bool;
    repeat:    bool;
}

Text_Editing_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    windowID:  Window_ID;
    text:      *u8;
    start:     s32;
    length:    s32;
}

Text_Editing_Candidates_Event :: struct
{
    type:               Event_Type;
    reserved:           u32;
    timestamp:          u64;
    windowID:           Window_ID;
    candidates:         **u8;
    num_candidates:     s32;
    selected_candidate: s32;
    horizontal:         bool;
    padding1:           u8;
    padding2:           u8;
    padding3:           u8;
}

Text_Input_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    windowID:  Window_ID;
    text:      *u8;
}

Mouse_Device_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    which:     Mouse_ID;
}

Mouse_Motion_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    windowID:  Window_ID;
    which:     Mouse_ID;
    state:     Mouse_Button_Flags ;
    x:         float32;
    y:         float32;
    xrel:      float32;
    yrel:      float32;
}

Mouse_Button_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    windowID:  Window_ID;
    which:     Mouse_ID;
    button:    u8;
    down:      bool;
    clicks:    u8;
    padding:   u8;
    x:         float32;
    y:         float32;
}

Mouse_Wheel_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    windowID:  Window_ID;
    which:     Mouse_ID;
    x:         float32;
    y:         float32;
    direction: Mouse_Wheel_Direction;
    mouse_x:   float32;
    mouse_y:   float32;
}

Joy_Axis_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    which:     Joystick_ID;
    axis:      u8;
    padding1:  u8;
    padding2:  u8;
    padding3:  u8;
    value:     s16;
    padding4:  u16;
}

Joy_Ball_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    which:     Joystick_ID;
    ball:      u8;
    padding1:  u8;
    padding2:  u8;
    padding3:  u8;
    xrel:      s16;
    yrel:      s16;
}

Joy_Hat_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    which:     Joystick_ID;
    hat:       u8;
    value:     u8;
    padding1:  u8;
    padding2:  u8;
}

Joy_Button_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    which:     Joystick_ID;
    button:    u8;
    down:      bool;
    padding1:  u8;
    padding2:  u8;
}

Joy_Device_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    which:     Joystick_ID;
}

Joy_Battery_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    which:     Joystick_ID;
    state:     Power_State;
    percent:   s32;
}

Gamepad_Axis_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    which:     Joystick_ID;
    axis:      u8;
    padding1:  u8;
    padding2:  u8;
    padding3:  u8;
    value:     s16;
    padding4:  u16;
}

Gamepad_Button_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    which:     Joystick_ID;
    button:    u8;
    down:      bool;
    padding1:  u8;
    padding2:  u8;
}

Gamepad_Device_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    which:     Joystick_ID;
}

Gamepad_Touchpad_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    which:     Joystick_ID;
    touchpad:  s32;
    finger:    s32;
    x:         float32;
    y:         float32;
    pressure:  float32;
}

Gamepad_Sensor_Event :: struct
{
    type:             Event_Type;
    reserved:         u32;
    timestamp:        u64;
    which:            Joystick_ID;
    sensor:           s32;
    data:             [3] float32;
    sensor_timestamp: u64;
}

Audio_Device_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    which:     Audio_Device_ID;
    recording: bool;
    padding1:  u8;
    padding2:  u8;
    padding3:  u8;
}

Camera_Device_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    which:     Camera_ID;
}

Touch_Finger_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    touchID:   Touch_ID;
    fingerID:  Finger_ID;
    x:         float32;
    y:         float32;
    dx:        float32;
    dy:        float32;
    pressure:  float32;
    windowID:  Window_ID;
}

Pen_Proximity_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    windowID:  Window_ID;
    which:     Pen_ID;
}

Pen_Motion_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    windowID:  Window_ID;
    which:     Pen_ID;
    pen_state: Pen_Input_Flags ;
    x:         float32;
    y:         float32;
}

Pen_Touch_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    windowID:  Window_ID;
    which:     Pen_ID;
    pen_state: Pen_Input_Flags ;
    x:         float32;
    y:         float32;
    eraser:    bool;
    down:      bool;
}

Pen_Button_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    windowID:  Window_ID;
    which:     Pen_ID;
    pen_state: Pen_Input_Flags;
    x:         float32;
    y:         float32;
    button:    u8;
    down:      bool;
}

Pen_Axis_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    windowID:  Window_ID;
    which:     Pen_ID;
    pen_state: Pen_Input_Flags;
    x:         float32;
    y:         float32;
    axis:      Pen_Axis;
    value:     float32;
}

Drop_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
    windowID:  Window_ID;
    x:         float32;
    y:         float32;
    source:    *u8;
    data:      *u8;
}

Clipboard_Event :: struct
{
    type:         Event_Type;
    reserved:     u32;
    timestamp:    u64;
    owner:        bool;
    n_mime_types: s32;
    mime_types:   **u8;
}

Sensor_Event :: struct
{
    type:             Event_Type;
    reserved:         u32;
    timestamp:        u64;
    which:            Sensor_ID;
    data:             [6] float32;
    sensor_timestamp: u64;
}

Quit_Event :: struct
{
    type:      Event_Type;
    reserved:  u32;
    timestamp: u64;
}

User_Event :: struct
{
    type:      u32;
    reserved:  u32;
    windowID:  Window_ID;
    code:      s32;
    data1:     *void;
    data2:     *void;
}

Event :: union
{
    type:            Event_Type;
    common:          Common_Event;
    display:         Display_Event;
    window:          Window_Event;
    kdevice:         Keyboard_Device_Event;
    key:             Keyboard_Event;
    edit:            Text_Editing_Event;
    edit_candidates: Text_Editing_Candidates_Event;
    text:            Text_Input_Event;
    mdevice:         Mouse_Device_Event;
    motion:          Mouse_Motion_Event;
    button:          Mouse_Button_Event;
    wheel:           Mouse_Wheel_Event;
    jdevice:         Joy_Device_Event;
    jaxis:           Joy_Axis_Event;
    jball:           Joy_Ball_Event;
    jhat:            Joy_Hat_Event;
    jbutton:         Joy_Button_Event;
    jbattery:        Joy_Battery_Event;
    gdevice:         Gamepad_Device_Event;
    gaxis:           Gamepad_Axis_Event;
    gbutton:         Gamepad_Button_Event;
    gtouchpad:       Gamepad_Touchpad_Event;
    gsensor:         Gamepad_Sensor_Event;
    adevice:         Audio_Device_Event;
    cdevice:         Camera_Device_Event;
    sensor:          Sensor_Event;
    quit:            Quit_Event;
    user:            User_Event;
    tfinger:         Touch_Finger_Event;
    pproximity:      Pen_Proximity_Event;
    ptouch:          Pen_Touch_Event;
    pmotion:         Pen_Motion_Event;
    pbutton:         Pen_Button_Event;
    paxis:           Pen_Axis_Event;
    drop:            Drop_Event;
    clipboard:       Clipboard_Event;

    /* This is necessary for ABI compatibility between Visual C++ and GCC.
       Visual C++ will respect the push pack pragma and use 52 bytes (size of
       TextEditingEvent, the largest structure for 32-bit and 64-bit
       architectures) for this union, and GCC will use the alignment of the
       largest datatype within the union, which is 8 bytes on 64-bit
       architectures.

       So... we'll add padding to force the size to be the same for both.

       On architectures where pointers are 16 bytes, this needs rounding up to
       the next multiple of 16, 64, and on architectures where pointers are
       even larger the size of UserEvent will dominate as being 3 pointers.
    */
    padding:         [128] u8;
}

#assert(size_of(Event) == 128);

Event_Action :: enum u32
{
    ADDEVENT;
    PEEKEVENT;
    GETEVENT;
}

Event_Filter :: #type (user_data: *void, event: *Event) -> bool;

pump_events           :: ()                                                                                           #foreign SDL3 "SDL_PumpEvents";
peep_events           :: (events: *Event, num_events: s32, action: Event_Action, min_type: u32, max_type: u32) -> s32 #foreign SDL3 "SDL_PeepEvents";
has_event             :: (type: u32) -> bool                                                                          #foreign SDL3 "SDL_HasEvent";
has_events            :: (min_type: u32, max_type: u32) -> bool                                                       #foreign SDL3 "SDL_HasEvents";
flush_event           :: (type: u32)                                                                                  #foreign SDL3 "SDL_FlushEvent";
flush_events          :: (min_type: u32, max_type: u32)                                                               #foreign SDL3 "SDL_FlushEvents";
poll_event            :: (event: *Event) -> bool                                                                      #foreign SDL3 "SDL_PollEvent";
wait_event            :: (event: *Event) -> bool                                                                      #foreign SDL3 "SDL_WaitEvent";
wait_event_timeout    :: (event: *Event, timeout_ms: s32) -> bool                                                     #foreign SDL3 "SDL_WaitEventTimeout";
push_event            :: (event: *Event) -> bool                                                                      #foreign SDL3 "SDL_PushEvent";
set_event_filter      :: (filter: Event_Filter, user_data: *void)                                                     #foreign SDL3 "SDL_SetEventFilter";
get_event_filter      :: (filter: *Event_Filter, user_data: **void) -> bool                                           #foreign SDL3 "SDL_GetEventFilter";
add_event_watch       :: (filter: Event_Filter, user_data: *void) -> bool                                             #foreign SDL3 "SDL_AddEventWatch";
remove_event_watch    :: (filter: Event_Filter, user_data: *void)                                                     #foreign SDL3 "SDL_RemoveEventWatch";
filter_events         :: (filter: Event_Filter, user_data: *void)                                                     #foreign SDL3 "SDL_FilterEvents";
set_event_enabled     :: (type: u32, enabled: bool)                                                                   #foreign SDL3 "SDL_SetEventEnabled";
event_enabled         :: (type: u32) -> bool                                                                          #foreign SDL3 "SDL_EventEnabled";
register_events       :: (num_events: s32) -> u32                                                                     #foreign SDL3 "SDL_RegisterEvents";
get_window_from_event :: (event: *Event) -> Window                                                                    #foreign SDL3 "SDL_GetWindowFromEvent";
