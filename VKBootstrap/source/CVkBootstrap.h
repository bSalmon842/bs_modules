// A wrapper around vk bootstrap to allow compatibility between jai and c++.
// This wrapper will feature both C and C++ idioms to allow an easy and nice
// interface on the Jai side. This is due to the fact that this will never be
// actually interacted with on the C and C++ side anyways.

#pragma once

#include <stdint.h>
#include <vulkan/vulkan.h>

#ifdef VK_MAKE_API_VERSION
#define VKB_MAKE_VK_VERSION(variant, major, minor, patch) VK_MAKE_API_VERSION(variant, major, minor, patch)
#elif defined(VK_MAKE_VERSION)
#define VKB_MAKE_VK_VERSION(variant, major, minor, patch) VK_MAKE_VERSION(major, minor, patch)
#endif

#if defined(VK_API_VERSION_1_3) || defined(VK_VERSION_1_3)
#define VKB_VK_API_VERSION_1_3 VKB_MAKE_VK_VERSION(0, 1, 3, 0)
#endif

#if defined(VK_API_VERSION_1_2) || defined(VK_VERSION_1_2)
#define VKB_VK_API_VERSION_1_2 VKB_MAKE_VK_VERSION(0, 1, 2, 0)
#endif

#if defined(VK_API_VERSION_1_1) || defined(VK_VERSION_1_1)
#define VKB_VK_API_VERSION_1_1 VKB_MAKE_VK_VERSION(0, 1, 1, 0)
#endif

#if defined(VK_API_VERSION_1_0) || defined(VK_VERSION_1_0)
#define VKB_VK_API_VERSION_1_0 VKB_MAKE_VK_VERSION(0, 1, 0, 0)
#endif

// #define EXPORT 
// #ifndef EXPORT 
    #define EXPORT __declspec(dllexport)
// #endif

#ifndef _TYPEDEF 
    #define _TYPEDEF(name) typedef struct name##_T* name; 
#endif

enum class VkbInstanceError {
    NONE,
    VULKAN_UNAVAILABLE,
    VULKAN_VERSION_UNAVAILABLE,
    VULKAN_VERSION_1_1_UNAVAILABLE,
    VULKAN_VERSION_1_2_UNAVAILABLE,
    FAILED_CREATE_INSTANCE,
    FAILED_CREATE_DEBUG_MESSENGER,
    REQUESTED_LAYERS_NOT_PRESENT,
    REQUESTED_EXTENSIONS_NOT_PRESENT,
    WINDOWING_EXTENSIONS_NOT_PRESENT,
};

enum class VkbPhysicalDeviceError {
    NONE,
    NO_SURFACE_PROVIDED,
    FAILED_ENUMERATE_PHYSICAL_DEVICES,
    NO_PHYSICAL_DEVICES_FOUND,
    NO_SUITABLE_DEVICE,
};

enum class VkbQueueError {
    NONE,
    PRESENT_UNAVAILABLE,
    GRAPHICS_UNAVAILABLE,
    COMPUTE_UNAVAILABLE,
    TRANSFER_UNAVAILABLE,
    QUEUE_INDEX_OUT_OF_RANGE,
    INVALID_QUEUE_FAMILY_INDEX
};

enum class VkbDeviceError {
    NONE,
    FAILED_CREATE_DEVICE,
    VKPHYSICALDEVICEFEATURES2_IN_PNEXT_CHAIN_WHILE_USING_ADD_REQUIRED_EXTENSION_FEATURES,
};

enum class VkbSwapchainError {
    NONE,
    SURFACE_HANDLE_NOT_PROVIDED,
    FAILED_QUERY_SURFACE_SUPPORT_DETAILS,
    FAILED_CREATE_SWAPCHAIN,
    FAILED_GET_SWAPCHAIN_IMAGES,
    FAILED_CREATE_SWAPCHAIN_IMAGE_VIEWS,
    REQUIRED_MIN_IMAGE_COUNT_TOO_LOW,
    REQUIRED_USAGE_NOT_SUPPORTED
};

_TYPEDEF(VkbSystemInfo);

namespace VkbSystemInfoFunctions {
    EXPORT VkbInstanceError get_system_info(VkbSystemInfo* result);
    EXPORT VkbInstanceError get_system_info(PFN_vkGetInstanceProcAddr fp_vkGetInstanceProcAddr, VkbSystemInfo* result);
    
    EXPORT void delete_system_info(VkbSystemInfo* system_info);
    
    EXPORT bool is_layer_available(VkbSystemInfo system_info, const char* layer_name);
    EXPORT bool is_extension_available(VkbSystemInfo system_info, const char* extension_name);
    
    // This will return a slice or array view.
    EXPORT void get_available_layers(VkbSystemInfo system_info, VkLayerProperties** data, size_t* length);
    // This will return a slice or array view.
    EXPORT void get_available_extensions(VkbSystemInfo system_info, VkExtensionProperties** data, size_t* length);
    
    EXPORT bool is_validation_layers_available(VkbSystemInfo system_info);
    EXPORT bool is_debug_utils_available(VkbSystemInfo system_info);
} // namesapce VkbSystemInfoFunctions;

_TYPEDEF(VkbInstance);

namespace VkbInstanceFunctions {
    EXPORT VkInstance get_vk_instance(VkbInstance instance);
    EXPORT VkDebugUtilsMessengerEXT get_debug_messenger(VkbInstance instance);
    EXPORT VkAllocationCallbacks* get_allocation_callbacks(VkbInstance instance);
    
    EXPORT void destroy_instance(VkbInstance* instance);
} // namespace VkbInstanceFunctions

_TYPEDEF(VkbInstanceBuilder);

namespace VkbInstanceBuilderFunctions {
    EXPORT VkbInstanceBuilder make_instance_builder();
    EXPORT VkbInstanceBuilder make_instance_builder(PFN_vkGetInstanceProcAddr fp_vkGetInstanceProcAddr);
    EXPORT void delete_instance_builder(VkbInstanceBuilder* builder);
    
    // Create a VkInstance. Return a VkbInstanceError if it failed.
    EXPORT VkbInstanceError build(VkbInstanceBuilder builder, VkbInstance* result);
    
    // Sets the name of the application. Defaults to "" if none is provided.
    EXPORT void set_app_name(VkbInstanceBuilder builder, const char* app_name);
    
    // Sets the name of the engine. Defaults to "" if none is provided.
    EXPORT void set_engine_name(VkbInstanceBuilder builder, const char* engine_name);

    // Sets the version of the application.
    // Should be constructed with VK_MAKE_VERSION or VK_MAKE_API_VERSION.
    EXPORT void set_app_version(VkbInstanceBuilder builder, uint32_t app_version);
    // Sets the (major, minor, patch) version of the application.
    EXPORT void set_app_version(VkbInstanceBuilder builder, uint32_t major, uint32_t minor, uint32_t patch = 0);

    // Sets the version of the engine.
    // Should be constructed with VK_MAKE_VERSION or VK_MAKE_API_VERSION.
    EXPORT void set_engine_version(VkbInstanceBuilder builder, uint32_t engine_version);
    // Sets the (major, minor, patch) version of the engine.
    EXPORT void set_engine_version(VkbInstanceBuilder builder, uint32_t major, uint32_t minor, uint32_t patch = 0);

    // Require a vulkan API version. Will fail to create if this version isn't available.
    // Should be constructed with VK_MAKE_VERSION or VK_MAKE_API_VERSION.
    EXPORT void require_api_version(VkbInstanceBuilder builder, uint32_t required_api_version);
    // Require a vulkan API version. Will fail to create if this version isn't available.
    EXPORT void require_api_version(VkbInstanceBuilder builder, uint32_t major, uint32_t minor, uint32_t patch = 0);

    // Overrides required API version for instance creation. Will fail to create if this version isn't available.
    // Should be constructed with VK_MAKE_VERSION or VK_MAKE_API_VERSION.
    EXPORT void set_minimum_instance_version(VkbInstanceBuilder builder, uint32_t minimum_instance_version);
    // Overrides required API version for instance creation. Will fail to create if this version isn't available.
    EXPORT void set_minimum_instance_version(VkbInstanceBuilder builder, uint32_t major, uint32_t minor, uint32_t patch = 0);

    // Adds a layer to be enabled. Will fail to create an instance if the layer isn't available.
    EXPORT void enable_layer(VkbInstanceBuilder builder, const char* layer_name);
    // Adds an extension to be enabled. Will fail to create an instance if the extension isn't available.
    EXPORT void enable_extension(VkbInstanceBuilder builder, const char* extension_name);
	
	EXPORT void enable_extensions(VkbInstanceBuilder builder, const char** extensions_data, size_t array_length);
    EXPORT void enable_extensions(VkbInstanceBuilder builder, size_t count, const char** extensions);

    // Headless Mode does not load the required extensions for presentation. Defaults to true.
    EXPORT void set_headless(VkbInstanceBuilder builder, bool headless = true);

    // Enables the validation layers. Will fail to create an instance if the validation layers aren't available.
    EXPORT void enable_validation_layers(VkbInstanceBuilder builder, bool require_validation = true);
    // Checks if the validation layers are available and loads them if they are.
    EXPORT void request_validation_layers(VkbInstanceBuilder builder, bool enable_validation = true);

    // Use a default debug callback that prints to standard out.
    EXPORT void use_default_debug_messenger(VkbInstanceBuilder builder);
    // Provide a user defined debug callback.
    EXPORT void set_debug_callback(VkbInstanceBuilder builder, PFN_vkDebugUtilsMessengerCallbackEXT callback);
    // Sets the void* to use in the debug messenger - only useful with a custom callback
    EXPORT void set_debug_callback_user_data_pointer(VkbInstanceBuilder builder, void* user_data_pointer);
    // Set what message severity is needed to trigger the callback.
    EXPORT void set_debug_messenger_severity(VkbInstanceBuilder builder, VkDebugUtilsMessageSeverityFlagsEXT severity);
    // Add a message severity to the list that triggers the callback.
    EXPORT void add_debug_messenger_severity(VkbInstanceBuilder builder, VkDebugUtilsMessageSeverityFlagsEXT severity);
    // Set what message type triggers the callback.
    EXPORT void set_debug_messenger_type(VkbInstanceBuilder builder, VkDebugUtilsMessageTypeFlagsEXT type);
    // Add a message type to the list of that triggers the callback.
    EXPORT void add_debug_messenger_type(VkbInstanceBuilder builder, VkDebugUtilsMessageTypeFlagsEXT type);

    // Disable some validation checks.
    // Checks: All, and Shaders
    EXPORT void add_validation_disable(VkbInstanceBuilder builder, VkValidationCheckEXT check);

    // Enables optional parts of the validation layers.
    // Parts: best practices, gpu assisted, and gpu assisted reserve binding slot.
    EXPORT void add_validation_feature_enable(VkbInstanceBuilder builder, VkValidationFeatureEnableEXT enable);

    // Disables sections of the validation layers.
    // Options: All, shaders, thread safety, api parameters, object lifetimes, core checks, and unique handles.
    EXPORT void add_validation_feature_disable(VkbInstanceBuilder builder, VkValidationFeatureDisableEXT disable);

    // Provide custom allocation callbacks.
    EXPORT void set_allocation_callbacks(VkbInstanceBuilder builder, VkAllocationCallbacks* callbacks);
} // namespace VkbInstanceBuilderFunctions

_TYPEDEF(VkbPhysicalDevice);

namespace VkbPhysicalDeviceFunctions {
    EXPORT void get_name(VkbPhysicalDevice pdevice, const char** data, size_t* length);
    EXPORT VkPhysicalDevice get_vk_physical_device(VkbPhysicalDevice pdevice);
    EXPORT VkSurfaceKHR get_vk_surface(VkbPhysicalDevice* pdevice);
    
    EXPORT void destroy_physical_device(VkbPhysicalDevice pdevice, VkbInstance instance);
    
    EXPORT VkPhysicalDeviceFeatures get_vk_device_features(VkbPhysicalDevice pdevice);
    EXPORT VkPhysicalDeviceProperties get_vk_device_properties(VkbPhysicalDevice pdevice);
    EXPORT VkPhysicalDeviceMemoryProperties get_vk_device_memory_properties(VkbPhysicalDevice pdevice);
    
    // Has a queue family that supports compute operations but not graphics nor transfer.
    EXPORT bool has_dedicated_compute_queue(VkbPhysicalDevice pdevice);
    // Has a queue family that supports transfer operations but not graphics nor compute.
    EXPORT bool has_dedicated_transfer_queue(VkbPhysicalDevice pdevice);

    // Has a queue family that supports transfer operations but not graphics.
    EXPORT bool has_separate_compute_queue(VkbPhysicalDevice pdevice);
    // Has a queue family that supports transfer operations but not graphics.
    EXPORT bool has_separate_transfer_queue(VkbPhysicalDevice pdevice);

    // Advanced: Get the VkQueueFamilyProperties of the device if special queue setup is needed
    EXPORT void get_queue_families(VkbPhysicalDevice pdevice, VkQueueFamilyProperties** data, size_t* length);

    // Query the list of extensions which should be enabled
    // Note: string_lengths and array_data allocates with malloc(), this leaves the caller 
    // responsible to free the memory.
    EXPORT void get_extensions(VkbPhysicalDevice pdevice, const char*** array_data, size_t* array_length, size_t** string_lengths);
    // Query the list of extensions which the physical device supports
    // Note: string_lengths and array_data allocates with malloc(), this leaves the caller 
    // responsible to free the memory.
    EXPORT void get_available_extensions(VkbPhysicalDevice pdevice, const char*** array_data, size_t* array_length, size_t** string_lengths);

    // Returns true if an extension should be enabled on the device
    EXPORT bool is_extension_present(VkbPhysicalDevice pdevice, const char* extension);

    // If the given extension is present, make the extension be enabled on the device.
    // Returns true the extension is present.
    EXPORT bool enable_extension_if_present(VkbPhysicalDevice pdevice, const char* extension);
} // namespace VkbPhysicalDeviceFunctions

enum class VkbPreferredDeviceType {
    OTHER = 0,
    INTEGRATED = 1,
    DISCRETE = 2,
    VIRTUAL_GPU = 3,
    CPU = 4,
};

enum class VkbDeviceSelectionMode {
    // return all suitable and partially suitable devices
    PARTIALLY_AND_FULLY_SUITABLE,
    // return only physical devices which are fully suitable
    ONLY_FULLY_SUITABLE,  
};

// Enumerates the physical devices on the system, and based on the added criteria, returns a physical device or list of physical devies
// A device is considered suitable if it meets all the 'required' and 'desired' criteria.
// A device is considered partially suitable if it meets only the 'required' criteria.
_TYPEDEF(VkbPhysicalDeviceSelector);

namespace VkbPhysicalDeviceSelectorFunctions {
    EXPORT VkbPhysicalDeviceSelector make_physical_device_selector(VkbInstance instance);
    EXPORT VkbPhysicalDeviceSelector make_physical_device_selector(VkbInstance instance, VkSurfaceKHR surface);
    EXPORT void delete_physical_device_selector(VkbPhysicalDeviceSelector* selector);
    
    // Return the first device which is suitable
    // use the `selection` parameter to configure if partially
    EXPORT VkbPhysicalDeviceError select(VkbPhysicalDeviceSelector selector, VkbPhysicalDevice* result, VkbDeviceSelectionMode selection = VkbDeviceSelectionMode::PARTIALLY_AND_FULLY_SUITABLE);
    
     // Return all devices which are considered suitable - intended for applications which want to let the user pick the physical device
    EXPORT VkbPhysicalDeviceError select_devices(VkbPhysicalDeviceSelector selector, VkbPhysicalDevice** results, size_t* length, VkbDeviceSelectionMode selection = VkbDeviceSelectionMode::PARTIALLY_AND_FULLY_SUITABLE);
    
    // Return the names of all devices which are considered suitable - intended for applications which want to let the user pick the physical device
    // Note: string_lengths and array_data allocates with malloc(), this leaves the caller 
    // responsible to free the memory.
    EXPORT VkbPhysicalDeviceError select_device_names(VkbPhysicalDeviceSelector selector, const char*** array_data, size_t* array_length, size_t** string_lengths, VkbDeviceSelectionMode selection = VkbDeviceSelectionMode::PARTIALLY_AND_FULLY_SUITABLE);
    
    // Set the surface in which the physical device should render to.
    // Be sure to set it if swapchain functionality is to be used.
    EXPORT void set_surface(VkbPhysicalDeviceSelector selector, VkSurfaceKHR surface);

    // Set the name of the device to select.
    EXPORT void set_name(VkbPhysicalDeviceSelector selector, const char* name, size_t name_char_length);
    // Set the desired physical device type to select. Defaults to PreferredDeviceType::DISCRETE.
    EXPORT void prefer_gpu_device_type(VkbPhysicalDeviceSelector selector, VkbPreferredDeviceType type = VkbPreferredDeviceType::DISCRETE);
    // Allow selection of a gpu device type that isn't the preferred physical device type. Defaults to true.
    EXPORT void allow_any_gpu_device_type(VkbPhysicalDeviceSelector selector, bool allow_any_type = true);

    // Require that a physical device supports presentation. Defaults to true.
    EXPORT void require_present(VkbPhysicalDeviceSelector selector, bool require = true);

    // Require a queue family that supports compute operations but not graphics nor transfer.
    EXPORT void require_dedicated_compute_queue(VkbPhysicalDeviceSelector selector);
    // Require a queue family that supports transfer operations but not graphics nor compute.
    EXPORT void require_dedicated_transfer_queue(VkbPhysicalDeviceSelector selector);

    // Require a queue family that supports compute operations but not graphics.
    EXPORT void require_separate_compute_queue(VkbPhysicalDeviceSelector selector);
    // Require a queue family that supports transfer operations but not graphics.
    EXPORT void require_separate_transfer_queue(VkbPhysicalDeviceSelector selector);

    // Require a memory heap from VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT with `size` memory available.
    EXPORT void required_device_memory_size(VkbPhysicalDeviceSelector selector, VkDeviceSize size);

    // Require a physical device which supports a specific extension.
    EXPORT void add_required_extension(VkbPhysicalDeviceSelector selector, const char* extension);
    // Require a physical device which supports a set of extensions.
    EXPORT void add_required_extensions(VkbPhysicalDeviceSelector selector, const char** extensions, size_t length);

    // Require a physical device that supports a (major, minor) version of vulkan.
    EXPORT void set_minimum_version(VkbPhysicalDeviceSelector selector, uint32_t major, uint32_t minor);

    // By default PhysicalDeviceSelector enables the portability subset if available
    // This function disables that behavior
    EXPORT void disable_portability_subset(VkbPhysicalDeviceSelector selector);

    // Require a physical device which supports a specific set of general/extension features.
    // If this function is used, the user should not put their own VkPhysicalDeviceFeatures2 in
    // the pNext chain of VkDeviceCreateInfo.
    //
    // Original function:
    //     template <typename T> PhysicalDeviceSelector& add_required_extension_features(T const& features) {
    //         criteria.extended_features_chain.push_back(features);
    //         return *this;
    //     }
    EXPORT void add_required_extension_features(VkbPhysicalDevice selector, void* data, size_t size);

    // Require a physical device which supports the features in VkPhysicalDeviceFeatures.
    EXPORT void set_required_features(VkbPhysicalDeviceSelector selector, VkPhysicalDeviceFeatures const& features);
#if defined(VKB_VK_API_VERSION_1_2)
    // Require a physical device which supports the features in VkPhysicalDeviceVulkan11Features.
    // Must have vulkan version 1.2 - This is due to the VkPhysicalDeviceVulkan11Features struct being added in 1.2, not 1.1
    EXPORT void set_required_features_11(VkbPhysicalDeviceSelector selector, VkPhysicalDeviceVulkan11Features features_11);
    // Require a physical device which supports the features in VkPhysicalDeviceVulkan12Features.
    // Must have vulkan version 1.2
    EXPORT void set_required_features_12(VkbPhysicalDeviceSelector selector, VkPhysicalDeviceVulkan12Features features_12);
#endif
#if defined(VKB_VK_API_VERSION_1_3)
    // Require a physical device which supports the features in VkPhysicalDeviceVulkan13Features.
    // Must have vulkan version 1.3
    EXPORT void set_required_features_13(VkbPhysicalDeviceSelector selector, VkPhysicalDeviceVulkan13Features features_13);
#endif

    // Used when surface creation happens after physical device selection.
    // Warning: This disables checking if the physical device supports a given surface.
    EXPORT void defer_surface_initialization(VkbPhysicalDeviceSelector selector);

    // Ignore all criteria and choose the first physical device that is available.
    // Only use when: The first gpu in the list may be set by global user preferences and an application may wish to respect it.
    EXPORT void select_first_device_unconditionally(VkbPhysicalDeviceSelector selector, bool unconditionally = true);
} // namespace VkbPhysicalDeviceSelectorFunctions

enum class VkbQueueType {
    PRESENT,
    GRAPHICS,
    COMPUTE,
    TRANSFER,
};

_TYPEDEF(VkbDevice);

namespace VkbDeviceFunctions {
    EXPORT VkDevice get_vk_device(VkbDevice device);
    EXPORT void get_queue_families(VkbDevice device, VkQueueFamilyProperties** queue_families, size_t* length);
    EXPORT VkAllocationCallbacks* get_allocation_callbacks(VkbDevice device);
    
    EXPORT void destroy_device(VkbDevice* device);
    
    EXPORT VkbQueueError get_queue_index(VkbDevice device, VkbQueueType type, uint32_t* result);
    // Only a compute or transfer queue type is valid. All other queue types do not support a 'dedicated' queue index
    EXPORT VkbQueueError get_dedicated_queue_index(VkbDevice device, VkbQueueType type, uint32_t* result);
    
    EXPORT VkbQueueError get_queue(VkbDevice device, VkbQueueType type, VkQueue* result);
    // Only a compute or transfer queue type is valid. All other queue types do not support a 'dedicated' queue
    EXPORT VkbQueueError get_dedicated_queue(VkbDevice device, VkbQueueType type, VkQueue* result);
} // namespace VkbDeviceFunctions

_TYPEDEF(VkbDeviceBuilder);

namespace VkbDeviceBuilderFunctions {
    EXPORT VkbDeviceBuilder make_device_builder(VkbPhysicalDevice physical_device);
    EXPORT void delete_device_builder(VkbDeviceBuilder* builder);
    
    EXPORT VkbDeviceError build(VkbDeviceBuilder builder, VkbDevice* result);
    
    EXPORT void add_pNext(VkbDeviceBuilder builder, VkBaseOutStructure* structure);    

    EXPORT void set_allocation_callbacks(VkbDeviceBuilder builder, VkAllocationCallbacks* callbacks);
} // namespace VkbDeviceBuilderFunctions

_TYPEDEF(VkbSwapchain);

namespace VkbSwapchainFunctions {
    EXPORT VkSwapchainKHR get_vk_swapchain(VkbSwapchain swapchain);
    EXPORT uint32_t get_image_count(VkbSwapchain swapchain);
    EXPORT VkFormat get_image_format(VkbSwapchain swapchain);
    EXPORT VkColorSpaceKHR get_color_space(VkbSwapchain swapchain);
    EXPORT VkExtent2D get_extent(VkbSwapchain swapchain);
    EXPORT VkImageUsageFlags get_image_usage_flags(VkbSwapchain swapchain);
    EXPORT VkPresentModeKHR get_present_mode(VkbSwapchain swapchain);
    EXPORT VkAllocationCallbacks* get_allocation_callbacks(VkbSwapchain swapchain);
    
    EXPORT void destroy_swapchain(VkbSwapchain* swapchain);
    
    // Returns a vector of VkImage handles to the swapchain.
    // 
    // Alllocates memory that needs to be freed with "destroy_images"
    EXPORT VkbSwapchainError get_images(VkbSwapchain swapchain, VkImage** data, size_t* length);
    EXPORT void destroy_images(VkImage* data);
    
    // Returns a vector of VkImageView's to the VkImage's of the swapchain.
    // VkImageViews must be destroyed.  The pNext chain must be a nullptr or a valid
    // structure.
    //
    // Compared to the original function, this will allocate memory for the data variable,
    // This means that the user won't have to worry about the lifetime of the data as it's
    // not bound to a vector. All that'll need to be done in the end is calling the destroy
    // method.
    EXPORT VkbSwapchainError get_image_views(VkbSwapchain swapchain, VkImageView** data, size_t* length);
    EXPORT VkbSwapchainError get_image_views(VkbSwapchain swapchain, const void* pNext, VkImageView** data, size_t* length);
    EXPORT void destroy_image_views(VkbSwapchain swapchain, VkImageView* data, size_t length);
} // namespace VkbSwapchainFunctions

_TYPEDEF(VkbSwapchainBuilder);

namespace VkbSwapchainBuilderFunctions {
    EXPORT VkbSwapchainBuilder make_swapchain_builder(VkbDevice device);
    EXPORT VkbSwapchainBuilder make_swapchain_builder(VkbDevice device, VkSurfaceKHR surface);
    EXPORT void delete_swapchain_builder(VkbSwapchainBuilder* builder);
    
    EXPORT VkbSwapchainError build(VkbSwapchainBuilder builder, VkbSwapchain* result);

    // Set the oldSwapchain member of VkSwapchainCreateInfoKHR.
    // For use in rebuilding a swapchain.
    EXPORT void set_old_swapchain(VkbSwapchainBuilder builder, VkSwapchainKHR old_swapchain);
    EXPORT void set_old_swapchain(VkbSwapchainBuilder builder, VkbSwapchain old_swapchain);
    
    // Desired size of the swapchain. By default, the swapchain will use the size
    // of the window being drawn to.
    EXPORT void set_desired_extent(VkbSwapchainBuilder builder, uint32_t width, uint32_t height);

    // When determining the surface format, make this the first to be used if supported.
    EXPORT void set_desired_format(VkbSwapchainBuilder builder, VkSurfaceFormatKHR format);
    // Add this swapchain format to the end of the list of formats selected from.
    EXPORT void add_fallback_format(VkbSwapchainBuilder builder, VkSurfaceFormatKHR format);
    // Use the default swapchain formats. This is done if no formats are provided.
    // Default surface format is {VK_FORMAT_B8G8R8A8_SRGB, VK_COLOR_SPACE_SRGB_NONLINEAR_KHR}
    EXPORT void use_default_format_selection(VkbSwapchainBuilder builder);

    // When determining the present mode, make this the first to be used if supported.
    EXPORT void set_desired_present_mode(VkbSwapchainBuilder builder, VkPresentModeKHR present_mode);
    // Add this present mode to the end of the list of present modes selected from.
    EXPORT void add_fallback_present_mode(VkbSwapchainBuilder builder, VkPresentModeKHR present_mode);
    // Use the default presentation mode. This is done if no present modes are provided.
    // Default present modes: VK_PRESENT_MODE_MAILBOX_KHR with fallback VK_PRESENT_MODE_FIFO_KHR
    EXPORT void use_default_present_mode_selection(VkbSwapchainBuilder builder);

    // Set the bitmask of the image usage for acquired swapchain images.
    // If the surface capabilities cannot allow it, building the swapchain will result in the `SwapchainError::required_usage_not_supported` error.
    EXPORT void set_image_usage_flags(VkbSwapchainBuilder builder, VkImageUsageFlags usage_flags);
    // Add a image usage to the bitmask for acquired swapchain images.
    EXPORT void add_image_usage_flags(VkbSwapchainBuilder builder, VkImageUsageFlags usage_flags);
    // Use the default image usage bitmask values. This is the default if no image usages
    // are provided. The default is VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT
    EXPORT void use_default_image_usage_flags(VkbSwapchainBuilder builder);

    // Set the number of views in for multiview/stereo surface
    EXPORT void set_image_array_layer_count(VkbSwapchainBuilder builder, uint32_t array_layer_count);

    // Convenient named constants for passing to set_desired_min_image_count().
    // Note that it is not an `enum class`, so its constants can be passed as an integer value without casting
    // In other words, these might as well be `static const int`, but they benefit from being grouped together this way.
    enum BufferMode {
        SINGLE_BUFFERING = 1,
        DOUBLE_BUFFERING = 2,
        TRIPLE_BUFFERING = 3,
    };

    // Sets the desired minimum image count for the swapchain.
    // Note that the presentation engine is always free to create more images than requested.
    // You may pass one of the values specified in the BufferMode enum, or any integer value.
    // For instance, if you pass DOUBLE_BUFFERING, the presentation engine is allowed to give you a double buffering setup, triple buffering, or more. This is up to the drivers.
    EXPORT void set_desired_min_image_count(VkbSwapchainBuilder builder, uint32_t min_image_count);

    // Sets a required minimum image count for the swapchain.
    // If the surface capabilities cannot allow it, building the swapchain will result in the `SwapchainError::required_min_image_count_too_low` error.
    // Otherwise, the same observations from set_desired_min_image_count() apply.
    // A value of 0 is specially interpreted as meaning "no requirement", and is the behavior by default.
    EXPORT void set_required_min_image_count(VkbSwapchainBuilder builder, uint32_t required_min_image_count);

    // Set whether the Vulkan implementation is allowed to discard rendering operations that
    // affect regions of the surface that are not visible. Default is true.
    // Note: Applications should use the default of true if they do not expect to read back the content
    // of presentable images before presenting them or after reacquiring them, and if their fragment
    // shaders do not have any side effects that require them to run for all pixels in the presentable image.
    EXPORT void set_clipped(VkbSwapchainBuilder builder, bool clipped = true);

    // Set the VkSwapchainCreateFlagBitsKHR.
    EXPORT void set_create_flags(VkbSwapchainBuilder builder, VkSwapchainCreateFlagBitsKHR create_flags);
    // Set the transform to be applied, like a 90 degree rotation. Default is no transform.
    EXPORT void set_pre_transform_flags(VkbSwapchainBuilder builder, VkSurfaceTransformFlagBitsKHR pre_transform_flags);
    // Set the alpha channel to be used with other windows in on the system. Default is VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR.
    EXPORT void set_composite_alpha_flags(VkbSwapchainBuilder builder, VkCompositeAlphaFlagBitsKHR composite_alpha_flags);

    // Add a structure to the pNext chain of VkSwapchainCreateInfoKHR.
    // The structure must be valid when SwapchainBuilder::build() is called.
    //
    // Original Code:
    //     template <typename T> SwapchainBuilder& add_pNext(T* structure) {
    //         info.pNext_chain.push_back(reinterpret_cast<VkBaseOutStructure*>(structure));
    //         return *this;
    //     }
    EXPORT void add_pNext(VkbSwapchainBuilder builder, VkBaseOutStructure* structure);

    // Provide custom allocation callbacks.
    EXPORT void set_allocation_callbacks(VkbSwapchainBuilder builder, VkAllocationCallbacks* callbacks);
} // namespace VkbSwapchainBuilderFunctions

// A quick little c wrapper to help remove any allocated memory.
EXPORT void _vkb_impl_c_free(void* data);