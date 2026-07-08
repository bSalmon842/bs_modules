android_jni_set_activity_title            :: (title : *u8)                                   #foreign SDL3 "Android_JNI_SetActivityTitle";
android_jni_set_window_style              :: (fullscreen : bool)                             #foreign SDL3 "Android_JNI_SetWindowStyle";
android_jni_set_orientation               :: (w : s32, h : s32, resizable : s32, hint : *u8) #foreign SDL3 "Android_JNI_SetOrientation";
android_jni_minimize_window               :: ()                                              #foreign SDL3 "Android_JNI_MinimizeWindow";
android_jni_should_minimize_on_focus_loss :: ()                                              #foreign SDL3 "Android_JNI_ShouldMinimizeOnFocusLoss";

android_jni_show_screen_keyboard :: (inputType : s32, inputRect : *Rect) #foreign SDL3 "Android_JNI_ShowScreenKeyboard";
android_jni_hide_screen_keyboard :: ()                                   #foreign SDL3 "Android_JNI_HideScreenKeyboard";
android_jni_get_native_window    :: () -> *ANativeWindow                 #foreign SDL3 "Android_JNI_GetNativeWindow";

android_jni_get_display_natural_orientation :: () -> Display_Orientation #foreign SDL3 "Android_JNI_GetDisplayNaturalOrientation";
android_jni_get_display_current_orientation :: () -> Display_Orientation #foreign SDL3 "Android_JNI_GetDisplayCurrentOrientation";

#scope_module
#import "Android";

