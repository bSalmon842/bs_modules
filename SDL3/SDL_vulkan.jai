vulkan_load_library :: (path : *u8) -> bool                             #foreign SDL3 "SDL_Vulkan_LoadLibrary";
vulkan_get_vk_get_instance_proc_addr :: () -> PFN_vkGetInstanceProcAddr #foreign SDL3 "SDL_Vulkan_GetVkGetInstanceProcAddr";

vulkan_create_surface :: (window : *Window, instance : VkInstance, allocator : *VkAllocationCallbacks, surface : *VkSurfaceKHR) -> bool #foreign SDL3 "SDL_Vulkan_CreateSurface";

#scope_module

#import "Vulkan_1_3";


