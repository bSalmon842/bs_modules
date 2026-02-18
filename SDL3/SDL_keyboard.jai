Keyboard_ID :: u32;


has_keyboard             :: () -> bool                                                          #foreign SDL3 "SDL_HasKeyboard";
get_keyboards            :: (count: *s32) -> *Keyboard_ID                                       #foreign SDL3 "SDL_GetKeyboards";
get_keyboard_name_for_id :: (instance_id: Keyboard_ID) -> *u8                                   #foreign SDL3 "SDL_GetKeyboardNameForID";
get_keyboard_focus       :: () -> *Window                                                       #foreign SDL3 "SDL_GetKeyboardFocus";
get_keyboard_state       :: (num_keys: *s32) -> *bool                                           #foreign SDL3 "SDL_GetKeyboardState";
reset_keyboard           :: ()                                                                  #foreign SDL3 "SDL_ResetKeyboard";
get_mod_state            :: () -> Keymod                                                        #foreign SDL3 "SDL_GetModState";
set_mod_state            :: (mod_state: Keymod)                                                 #foreign SDL3 "SDL_SetModState";
get_key_from_scancode    :: (scancode: Scancode, mod_state: Keymod, key_event: bool) -> Keycode #foreign SDL3 "SDL_GetKeyFromScancode";
get_scancode_from_key    :: (key: Keycode, mod_state: *Keymod) -> Scancode                      #foreign SDL3 "SDL_GetScancodeFromKey";
set_scancode_name        :: (scancode: Scancode, name: *u8) -> bool                             #foreign SDL3 "SDL_SetScancodeName";
get_scancode_name        :: (scancode: Scancode) -> *u8                                         #foreign SDL3 "SDL_GetScancodeName";
get_scancode_from_name   :: (name: *u8) -> Scancode                                             #foreign SDL3 "SDL_GetScancodeFromName";
get_key_name             :: (key: Keycode) -> *u8                                               #foreign SDL3 "SDL_GetKeyName";
get_key_from_name        :: (name: *u8) -> Keycode                                              #foreign SDL3 "SDL_GetKeyFromName";
start_text_input         :: (window: *Window) -> bool                                           #foreign SDL3 "SDL_StartTextInput";

Text_Input_Type :: enum u32
{
    TEXT;
    TEXT_NAME;
    TEXT_EMAIL;
    TEXT_USERNAME;
    TEXT_PASSWORD_HIDDEN;
    TEXT_PASSWORD_VISIBLE;
    NUMBER;
    NUMBER_PASSWORD_HIDDEN;
    NUMBER_PASSWORD_VISIBLE;
}

Capitalization :: enum u32
{
    NONE;
    SENTENCES;
    WORDS;
    LETTERS;
}


start_text_input_with_properties :: (window: *Window, props: Properties_ID) -> bool      #foreign SDL3 "SDL_StartTextInputWithProperties";
text_input_active                :: (window: *Window) -> bool                            #foreign SDL3 "SDL_TextInputActive";
stop_text_input                  :: (window: *Window) -> bool                            #foreign SDL3 "SDL_StopTextInput";
clear_composition                :: (window: *Window) -> bool                            #foreign SDL3 "SDL_ClearComposition";
set_text_input_area              :: (window: *Window, rect: *Rect, cursor: s32) -> bool  #foreign SDL3 "SDL_SetTextInputArea";
get_text_input_area              :: (window: *Window, rect: *Rect, cursor: *s32) -> bool #foreign SDL3 "SDL_GetTextInputArea";
has_screen_keyboard_support      :: () -> bool                                           #foreign SDL3 "SDL_HasScreenKeyboardSupport";
screen_keyboard_shown            :: (window: *Window) -> bool                            #foreign SDL3 "SDL_ScreenKeyboardShown";

PROP_TEXTINPUT_TYPE_NUMBER                  :: "SDL.textinput.type";
PROP_TEXTINPUT_CAPITALIZATION_NUMBER        :: "SDL.textinput.capitalization";
PROP_TEXTINPUT_AUTOCORRECT_BOOLEAN          :: "SDL.textinput.autocorrect";
PROP_TEXTINPUT_MULTILINE_BOOLEAN            :: "SDL.textinput.multiline";
PROP_TEXTINPUT_ANDROID_INPUTTYPE_NUMBER     :: "SDL.textinput.android.inputtype";
