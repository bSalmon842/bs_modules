// Bindings for Dear ImGui.

ImVec2      :: Vector2;
ImVec4      :: Vector4;
ImColor     :: Vector4;

ImVector :: struct (T: Type) {
    Size: s32;
    Capacity: s32;
    Data: *T;
}

ImDrawCallback :: #type (parent_list: *ImDrawList, cmd: *ImDrawCmd) #c_call;

// Jai friendly InputText from FallowWing on the Jai discord
InputText :: (label: string, str: *string, flags: InputTextFlags = 0) -> bool {
    flags |= .CallbackResize;
    flags |= .CallbackEdit;

    cbUserData: *InputTextCallbackUserData = talloc(size_of(InputTextCallbackUserData));
    cbUserData.str = str;

    cStr: *u8 = talloc(str.count+1);
    memset(cStr, 0, str.count+1);
    memcpy(cStr, str.data, str.count);
    return InputText(temp_c_string(label), cStr, cast(u64)(str.count+1), flags, InputTextCallbackFunc, cbUserData);
}

#scope_module

InputTextCallbackUserData :: struct {
    str : *string;
    chainCallback : InputTextCallback;
    chainCallBackUserData : *void;
}

InputTextCallbackFunc :: (data : *InputTextCallbackData) -> s32 #c_call {
    push_context {
        cbUserData := cast(*InputTextCallbackUserData)data.UserData;

        if data.EventFlag == .CallbackResize {
            array_resize(cast(*[]u8)cbUserData.str, data.BufTextLen);

            cStr: *u8 = talloc(cbUserData.str.count+1);
            memset(cStr, 0, cbUserData.str.count+1);
            memcpy(cStr, cbUserData.str.data, cbUserData.str.count);
            data.Buf = cStr;
        } else if data.EventFlag == .CallbackEdit {
            reset_string(cbUserData.str);
            cbUserData.str.* = copy_string(to_string(data.Buf));
        } else {
            print("Other callback\n");
        }
    }

    return 0;
}

reset_string :: (str: *string) {
    if str.count  free(str.data);
    str.count = 0;
}

#import "Basic";
#import "Math";

#if OS == .WINDOWS {
    #load "backend.jai";
    #load "windows.jai";
    #system_library,link_always "user32"; // Needed by imgui unless ImGui is compiled it with "IMGUI_DISABLE_WIN32_DEFAULT_CLIPBOARD_FUNCS"
} else {
    #load "unix.jai";
}

