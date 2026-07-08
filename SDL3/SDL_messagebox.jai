MessageBoxFlags :: enum_flags u32 {
    ERROR                 :: 0x10;
    WARNING               :: 0x20;
    INFORMATION           :: 0x40;
    BUTTONS_LEFT_TO_RIGHT :: 0x80;
    BUTTONS_RIGHT_TO_LEFT :: 0x100;
}

MessageBoxButtonFlags :: enum_flags u32 {
    RETURNKEY_DEFAULT :: 0x1;
    ESCAPEKEY_DEFAULT :: 0x2;
}

MessageBoxButtonData :: struct {
    flags    : MessageBoxButtonFlags;
    buttonID : s32;
    text     : *u8;
}

MessageBoxColor :: struct {
    r, g, b : u8;
}

MessageBoxColorType :: enum {
    BACKGROUND;
    TEXT;
    BUTTON_BORDER;
    BUTTON_BACKGROUND;
    BUTTON_SELECTED;
}

MessageBoxColorScheme :: struct {
    colors : [#run enum_highest_value(MessageBoxColorType)] MessageBoxColor;
}

MessageBoxData :: struct {
    flags   : MessageBoxFlags;
    window  : *Window;
    title   : *u8;
    message : *u8;

    numButtons : s32;
    buttons    : *MessageBoxButtonData;

    colorScheme : *MessageBoxColorScheme;
}


