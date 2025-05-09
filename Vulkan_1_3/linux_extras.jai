VK_KHR_XLIB_SURFACE_EXTENSION_NAME :: "VK_KHR_xlib_surface";

VkXlibSurfaceCreateFlagsKHR :: VkFlags;
VkXlibSurfaceCreateInfoKHR :: struct {
    sType:     VkStructureType = .XLIB_SURFACE_CREATE_INFO_KHR;
    pNext:     *void;
    flags:     VkXlibSurfaceCreateFlagsKHR;
    display:   *X11.Display;
    window:    X11.Window;
}

#scope_file
X11 :: #import "X11";
