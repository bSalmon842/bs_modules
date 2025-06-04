VK_KHR_ANDROID_SURFACE_EXTENSION_NAME :: "VK_KHR_android_surface";

VkAndroidSurfaceCreateFlagsKHR :: VkFlags;
VkAndroidSurfaceCreateInfoKHR :: struct {
    sType:     VkStructureType = .ANDROID_SURFACE_CREATE_INFO_KHR;
    pNext:     *void;
    flags:     VkAndroidSurfaceCreateFlagsKHR;
    window:    *Android.ANativeWindow;
}

#scope_file
Android :: #import "Android"();
