/*
Module: BS842 Vk Bootstrap
File: swapchain.jai
Author: Brock Salmon
Created: 20DEC2024
*/

SwapchainError :: enum {
    Success;
    Surface_Handle_Not_Provided;
    Failed_To_Query_Surface_Support_Details;
    Failed_To_Create_Swapchain;
    Failed_To_Get_Swapchain_Images;
    Failed_To_Create_Swapchain_Image_Views;
    Required_Minimum_Image_Count_Too_Low;
    Required_Usage_Not_Supported;
}

Swapchain :: struct {
    device : VkDevice = VK_NULL_HANDLE;
    swapchain : VkSwapchainKHR = VK_NULL_HANDLE;
    imgCount : u32;
    imgFormat : VkFormat = .UNDEFINED;
    imgUsageFlags : VkImageUsageFlags;
    colourSpace : VkColorSpaceKHR = .COLOR_SPACE_SRGB_NONLINEAR_KHR;
    extent := VkExtent2D.{ 0, 0 };
    requestedMinImgCount : u32;
    presentMode : VkPresentModeKHR = .IMMEDIATE_KHR;
    instanceVersion : u32 = VK_API_VERSION_1_0;
    allocCallbacks : *VkAllocationCallbacks = VK_NULL_HANDLE;
}

get_images :: (swapchain : Swapchain) -> [..] VkImage, SwapchainError {
    images : [..] VkImage;
    imageCount : u32;
    if vkGetSwapchainImagesKHR(swapchain.device, swapchain.swapchain, *imageCount, null) == .SUCCESS {
        array_resize(*images, imageCount);
        vkGetSwapchainImagesKHR(swapchain.device, swapchain.swapchain, *imageCount, images.data);
    } else {
        return images, .Failed_To_Get_Swapchain_Images;
    }
    
    return images, .Success;
}

get_image_views :: (swapchain : Swapchain, pNext : *void = null) -> [..] VkImageView, SwapchainError {
    images, getImagesError := get_images(swapchain);
    if getImagesError {
        errReturn : [..] VkImageView;
        return errReturn, getImagesError;
    }
    
    alreadyContainsImageViewUsage := false;
    while pNext && !alreadyContainsImageViewUsage {
        castIn := cast(*VkBaseInStructure) pNext;
        if castIn.sType == .IMAGE_VIEW_CREATE_INFO {
            alreadyContainsImageViewUsage = true;
        }
        pNext = castIn.pNext; 
    }
    
    desiredFlags := VkImageViewUsageCreateInfo.{
        pNext = pNext,
        usage = swapchain.imgUsageFlags
    };
    
    imageViews : [..] VkImageView;
    array_resize(*imageViews, images.count);
    for images {
        createInfo := VkImageViewCreateInfo.{
            .IMAGE_VIEW_CREATE_INFO,
            ifx swapchain.instanceVersion >= VK_API_VERSION_1_1 && !alreadyContainsImageViewUsage then *desiredFlags else pNext,
            0,
            it,
            ._2D,
            swapchain.imgFormat,
            .{ .IDENTITY, .IDENTITY, .IDENTITY, .IDENTITY },
            .{ .COLOR_BIT, 0, 1, 0, 1 }
        };
        
        if vkCreateImageView(swapchain.device, *createInfo, swapchain.allocCallbacks, *imageViews[it_index]) != .SUCCESS {
            return imageViews, .Failed_To_Create_Swapchain_Image_Views;
        }
    }
    
    return imageViews, .Success;
}

destroy_image_views :: (swapchain : Swapchain, imageViews : [..] VkImageView) {
    for imageViews {
        vkDestroyImageView(swapchain.device, it, swapchain.allocCallbacks);
    }
}

SwapchainBuilder :: struct {
    physicalDevice        : VkPhysicalDevice = VK_NULL_HANDLE;
    device                : VkDevice = VK_NULL_HANDLE;
    pNextChain            : [..] *VkBaseOutStructure;
    createFlags           : VkSwapchainCreateFlagBitsKHR;
    surface               : VkSurfaceKHR = VK_NULL_HANDLE;
    desiredFormats        : [..] VkSurfaceFormatKHR;
    instanceVersion       : u32 = VK_API_VERSION_1_0;
    desiredWidth          : u32 = 256;
    desiredHeight         : u32 = 256;
    arrayLayerCount       : u32 = 1;
    desiredMinImageCount  : u32;
    requiredMinImageCount : u32;
    imageUsageFlags       : VkImageUsageFlags = .COLOR_ATTACHMENT_BIT;
    graphicsQueueIndex    : u32;
    presentQueueIndex     : u32;
    preTransform          : VkSurfaceTransformFlagBitsKHR;
    desiredPresentModes   : [..] VkPresentModeKHR;
    clipped               : bool = true;
    oldSwapchain          : VkSwapchainKHR = VK_NULL_HANDLE;
    allocCallbacks        : *VkAllocationCallbacks = VK_NULL_HANDLE;
    
    #if OS == .ANDROID {
        compositeAlpha : VkCompositeAlphaFlagBitsKHR = .INHERIT_BIT_KHR;
    } else {
        compositeAlpha : VkCompositeAlphaFlagBitsKHR = .OPAQUE_BIT_KHR;
    }
}

make_swapchain_builder :: (device : Device) -> *SwapchainBuilder {
    return make_swapchain_builder(device, device.surface);
}

make_swapchain_builder :: (device : Device, surface : VkSurfaceKHR) -> *SwapchainBuilder {
    builder := New(SwapchainBuilder);
    
    builder.physicalDevice = device.physicalDevice.physicalDevice;
    builder.device = device.device;
    builder.surface = surface;
    builder.instanceVersion = device.instanceVersion;
    builder.allocCallbacks = device.allocCallbacks;
    
    presentIndex, presentIndexError   := get_queue_index(device, .Present);
    assert(presentIndexError == .Success, "Present Queue Index must be valid");
    builder.presentQueueIndex = presentIndex;
    
    graphicsIndex, graphicsIndexError := get_queue_index(device, .Graphics);
    assert(graphicsIndexError == .Success, "Graphics Queue Index must be valid");
    builder.graphicsQueueIndex = graphicsIndex;
    
    return builder;
}

make_swapchain_builder :: (device : Device, surface : VkSurfaceKHR, graphicsIndex : u32, presentIndex : u32) -> *SwapchainBuilder {
    builder.physicalDevice = device.physicalDevice.physicalDevice;
    builder.device = device.device;
    builder.surface = surface;
    builder.instanceVersion = device.instanceVersion;
    builder.allocCallbacks = device.allocCallbacks;
    builder.presentQueueIndex = presentIndex;
    builder.graphicsQueueIndex = graphicsIndex;
    
    if presentIndex == QUEUE_INDEX_MAX_VALUE {
        newPresentIndex, presentIndexError   := get_queue_index(device, .Present);
        assert(presentIndexError == .Success, "Present Queue Index must be valid");
        builder.presentQueueIndex = newPresentIndex;
    }
    
    if graphicsIndex == QUEUE_INDEX_MAX_VALUE {
        newGraphicsIndex, graphicsIndexError := get_queue_index(device, .Graphics);
        assert(graphicsIndexError == .Success, "Graphics Queue Index must be valid");
        builder.graphicsQueueIndex = newGraphicsIndex;
    }
    
    return builder;
}

set_old_swapchain :: (using builder : *SwapchainBuilder, otherSwapchain : VkSwapchainKHR) {
    oldSwapchain = otherSwapchain;
}

set_old_swapchain :: (using builder : *SwapchainBuilder, swapchain : Swapchain) {
    oldSwapchain = swapchain.swapchain;
}

set_desired_extent :: (using builder : *SwapchainBuilder, width : u32, height : u32) {
    desiredWidth = width;
    desiredHeight = height;
}

set_desired_format :: (using builder : *SwapchainBuilder, format : VkSurfaceFormatKHR) {
    array_insert_at(*desiredFormats, format, 0);
}

add_fallback_format :: (using builder : *SwapchainBuilder, format : VkSurfaceFormatKHR) {
    array_add(*desiredFormats, format);
}

add_desired_formats :: (formats : *[..] VkSurfaceFormatKHR) {
    array_add(formats, .{ .B8G8R8A8_SRGB, .COLOR_SPACE_SRGB_NONLINEAR_KHR });
    array_add(formats, .{ .R8G8B8A8_SRGB, .COLOR_SPACE_SRGB_NONLINEAR_KHR });
}

use_default_format_selection :: (using builder : *SwapchainBuilder) {
    array_reset(*desiredFormats);
    add_desired_formats(*desiredFormats);
}

set_desired_present_mode :: (using builder : *SwapchainBuilder, presentMode : VkPresentModeKHR) {
    array_insert_at(*desiredPresentModes, presentMode, 0);
}

add_fallback_present_mode :: (using builder : *SwapchainBuilder, presentMode : VkPresentModeKHR) {
    array_add(*desiredPresentModes, presentMode);
}

add_desired_present_modes :: (modes : *[..] VkPresentModeKHR) {
    array_add(modes, .MAILBOX_KHR);
    array_add(modes, .FIFO_KHR);
}

use_default_present_mode_selection :: (using builder : *SwapchainBuilder) {
    array_reset(*desiredPresentModes);
    add_desired_present_modes(*desiredPresentModes);
}

set_image_usage_flags :: (using builder : *SwapchainBuilder, usageFlags : VkImageUsageFlags) {
    imageUsageFlags = usageFlags;
}

add_image_usage_flags :: (using builder : *SwapchainBuilder, usageFlags : VkImageUsageFlags) {
    imageUsageFlags |= usageFlags;
}

use_default_image_usage_flags :: (using builder : *SwapchainBuilder) {
    imageUsageFlags = .COLOR_ATTACHMENT_BIT;
}

set_image_array_layer_count :: (using builder : *SwapchainBuilder, arrayLayerCount : u32) {
    arrayLayerCount = arrayLayerCount;
}

set_desired_min_image_count :: (using builder : *SwapchainBuilder, minImageCount : u32) {
    desiredMinImageCount = minImageCount;
}

set_required_min_image_count :: (using builder : *SwapchainBuilder, minImageCount : u32) {
    requiredMinImageCount = minImageCount;
}

set_clipped :: (using builder : *SwapchainBuilder, clip := true) {
    clipped = clip;
}

set_create_flags :: (using builder : *SwapchainBuilder, flags : VkSwapchainCreateFlagBitsKHR) {
    createFlags = flags;
}

set_pre_transform_flags :: (using builder : *SwapchainBuilder, flags : VkSurfaceTransformFlagBitsKHR) {
    preTransform = flags;
}

set_composite_alpha_flags :: (using builder : *SwapchainBuilder, flags : VkCompositeAlphaFlagBitsKHR) {
    compositeAlpha = flags;
}

set_allocation_callbacks :: (using builder : *SwapchainBuilder, callbacks : *VkAllocationCallbacks) {
    allocCallbacks = callbacks;
}

add_pNext :: (using builder : *SwapchainBuilder, structure : *$T) {
    array_add(*pNextChain, cast(*VkBaseOutStructure) structure);
}

build :: (builder : *SwapchainBuilder) -> Swapchain, SwapchainError {
    if builder.surface == VK_NULL_HANDLE then return .{}, .Surface_Handle_Not_Provided;
    
    desiredFormats := builder.desiredFormats;
    if desiredFormats.count == 0 then add_desired_formats(*desiredFormats);
    desiredPresentModes := builder.desiredPresentModes;
    if desiredPresentModes.count == 0 then add_desired_present_modes(*desiredPresentModes);
    
    surfaceSupport, supportError := query_surface_support_details(builder.physicalDevice, builder.surface);
    if supportError return .{}, .Failed_To_Query_Surface_Support_Details;
    
    imageCount := builder.desiredMinImageCount;
    if builder.requiredMinImageCount >= 1 {
        if builder.requiredMinImageCount < surfaceSupport.capabilities.minImageCount then return .{}, .Required_Minimum_Image_Count_Too_Low;    
        imageCount = builder.requiredMinImageCount;
    } else if builder.desiredMinImageCount == 0 {
        imageCount = surfaceSupport.capabilities.minImageCount + 1;
    } else {
        imageCount = max(imageCount, surfaceSupport.capabilities.minImageCount);
    }
    if surfaceSupport.capabilities.maxImageCount > 0 then imageCount = min(imageCount, surfaceSupport.capabilities.minImageCount);
    
    surfaceFormat := find_best_surface_format(surfaceSupport.formats, desiredFormats);
    extent := find_extent(surfaceSupport.capabilities, builder.desiredWidth, builder.desiredHeight);
    
    imageArrayLayerCount := builder.arrayLayerCount;
    if surfaceSupport.capabilities.maxImageArrayLayers < builder.arrayLayerCount then imageArrayLayerCount = surfaceSupport.capabilities.maxImageArrayLayers;
    if builder.arrayLayerCount == 0 then imageArrayLayerCount = 1;
    
    queueFamilyIndices := u32.[ builder.graphicsQueueIndex, builder.presentQueueIndex ];
    presentMode := find_present_mode(surfaceSupport.presentModes, desiredPresentModes);
    isUnextendedPresentMode := presentMode == .IMMEDIATE_KHR || presentMode == .MAILBOX_KHR || presentMode == .FIFO_KHR || presentMode == .FIFO_RELAXED_KHR;
    
    if isUnextendedPresentMode && (builder.imageUsageFlags & surfaceSupport.capabilities.supportedUsageFlags) != builder.imageUsageFlags {
        return .{}, .Required_Usage_Not_Supported;
    }
    
    preTransform := builder.preTransform;
    if builder.preTransform == 0 then preTransform = surfaceSupport.capabilities.currentTransform;
    
    swapchainCreateInfo : VkSwapchainCreateInfoKHR;
    setup_pNext_chain(*swapchainCreateInfo, *builder.pNextChain);
    swapchainCreateInfo.flags = builder.createFlags;
    swapchainCreateInfo.surface = builder.surface;
    swapchainCreateInfo.minImageCount = imageCount;
    swapchainCreateInfo.imageFormat = surfaceFormat.format;
    swapchainCreateInfo.imageColorSpace = surfaceFormat.colorSpace;
    swapchainCreateInfo.imageExtent = extent;
    swapchainCreateInfo.imageArrayLayers = imageArrayLayerCount;
    swapchainCreateInfo.imageUsage = builder.imageUsageFlags;
    
    if builder.graphicsQueueIndex != builder.presentQueueIndex {
        swapchainCreateInfo.imageSharingMode = .CONCURRENT;
        swapchainCreateInfo.queueFamilyIndexCount = 2;
        swapchainCreateInfo.pQueueFamilyIndices = queueFamilyIndices.data;
    } else {
        swapchainCreateInfo.imageSharingMode = .EXCLUSIVE;
    }
    
    swapchainCreateInfo.preTransform = preTransform;
    swapchainCreateInfo.compositeAlpha = builder.compositeAlpha;
    swapchainCreateInfo.presentMode = presentMode;
    swapchainCreateInfo.clipped = cast(u32) builder.clipped;
    swapchainCreateInfo.oldSwapchain = builder.oldSwapchain;
    
    swapchain : Swapchain;
    if vkCreateSwapchainKHR(builder.device, *swapchainCreateInfo, builder.allocCallbacks, *swapchain.swapchain) != .SUCCESS {
        return swapchain, .Failed_To_Create_Swapchain;
    }
    
    swapchain.device = builder.device;
    
    images, error := get_images(swapchain);
    if error then return swapchain, .Failed_To_Get_Swapchain_Images;
    
    swapchain.imgCount = cast(u32) images.count;
    swapchain.imgFormat = surfaceFormat.format;
    swapchain.imgUsageFlags = builder.imageUsageFlags;
    swapchain.colourSpace = surfaceFormat.colorSpace;
    swapchain.extent = extent;
    swapchain.requestedMinImgCount = imageCount;
    swapchain.presentMode = presentMode;
    swapchain.instanceVersion = builder.instanceVersion;
    swapchain.allocCallbacks = builder.allocCallbacks;
    
    return swapchain, .Success;
}