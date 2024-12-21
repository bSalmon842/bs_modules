/*
Module: BS842 Vk Bootstrap
File: swapchain_misc.jai
Author: Brock Salmon
Created: 21DEC2024
Last Edit: 21DEC2024
*/

SurfaceSupportError :: enum {
    Success;
    Surface_Handle_Null;
    Failed_To_Get_Surface_Capabilities;
    Failed_To_Enumerate_Surface_Formats;
    Failed_To_Enumerate_Present_Modes;
    No_Suitable_Desired_Format;
}

SurfaceSupportDetails :: struct {
    capabilities : VkSurfaceCapabilitiesKHR;
    formats : [..] VkSurfaceFormatKHR;
    presentModes : [..] VkPresentModeKHR;
}

query_surface_support_details :: (physicalDevice : VkPhysicalDevice, surface : VkSurfaceKHR) -> SurfaceSupportDetails, SurfaceSupportError {
    if surface == VK_NULL_HANDLE then return .{}, .Surface_Handle_Null;
    
    capabilities : VkSurfaceCapabilitiesKHR;
    if vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice, surface, *capabilities) != .SUCCESS {
        return .{}, .Failed_To_Get_Surface_Capabilities;
    }
    
    formats : [..] VkSurfaceFormatKHR;
    formatCount : u32;
    if vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice, surface, *formatCount, null) == .SUCCESS {
        array_resize(*formats, formatCount);
        vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice, surface, *formatCount, formats.data);
    } else {
        return .{}, .Failed_To_Enumerate_Surface_Formats;
    }
    
    presentModes : [..] VkPresentModeKHR;
    modeCount : u32;
    if vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice, surface, *modeCount, null) == .SUCCESS {
        array_resize(*presentModes, modeCount);
        vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice, surface, *modeCount, presentModes.data);
    } else {
        return .{}, .Failed_To_Enumerate_Present_Modes;
    }
    
    return .{ capabilities, formats, presentModes }, .Success;
}

find_desired_surface_format :: (availableFormats : [..] VkSurfaceFormatKHR, desiredFormats : [..] VkSurfaceFormatKHR) -> VkSurfaceFormatKHR, SurfaceSupportError {
    for desired : desiredFormats {
        for available : availableFormats {
            if desired.format == available.format && desired.colorSpace == available.colorSpace then return desired, .Success;
        }
    }
    
    return .{}, .No_Suitable_Desired_Format;
}

find_best_surface_format :: (availableFormats : [..] VkSurfaceFormatKHR, desiredFormats : [..] VkSurfaceFormatKHR) -> VkSurfaceFormatKHR {
    surfaceFormat : VkSurfaceFormatKHR;
    format, error := find_desired_surface_format(availableFormats, desiredFormats);
    if error == .Success then return format;
    
    return availableFormats[0];
}

find_extent :: (capabilities : VkSurfaceCapabilitiesKHR, desiredWidth : u32, desiredHeight : u32) -> VkExtent2D {
    if capabilities.currentExtent.width != U32_MAX then return capabilities.currentExtent;
    
    actualExtent := VkExtent2D.{
        clamp(desiredWidth, capabilities.minImageExtent.width, capabilities.maxImageExtent.width),
        clamp(desiredHeight, capabilities.minImageExtent.height, capabilities.maxImageExtent.height)
    };
    
    return actualExtent;
}

find_present_mode :: (availableModes : [..] VkPresentModeKHR, desiredModes : [..] VkPresentModeKHR) -> VkPresentModeKHR {
    for desired : desiredModes {
        for available : availableModes {
            if desired == available then return desired;
        }
    }
    
    return .FIFO_KHR;
}