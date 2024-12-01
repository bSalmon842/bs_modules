#include "CVkBootstrap.h"
#include "VkBootstrap.h"

#include <stdlib.h>
#include <utility>

// #define EXPORT __declspec(dllexport)

// Error memory structure:
// std::error_code type;
// VkResult vk_result = VK_SUCCESS; // optional error value if a vulkan call failed

// Result memory structure:
// union {
//     T m_value;
//     Error m_error;
// };
//
// bool m_init;
//
// Useful methods:
//
// std::error_code error()
// bool has_value()
//
// My own method: T get_value()

namespace VkbSystemInfoFunctions {
    EXPORT VkbInstanceError get_system_info(VkbSystemInfo* result) {
        return get_system_info(nullptr, result);
    }
    
    EXPORT VkbInstanceError get_system_info(PFN_vkGetInstanceProcAddr fp_vkGetInstanceProcAddr, VkbSystemInfo* result) {
        auto system_info_result = vkb::SystemInfo::get_system_info(fp_vkGetInstanceProcAddr);
        
        auto error = VkbInstanceError::NONE;
        
        if (system_info_result.has_value()) {
            *result = (VkbSystemInfo)malloc(sizeof(vkb::SystemInfo));
            memcpy(*result, &std::move(system_info_result), sizeof(vkb::SystemInfo));
        } else {
            error = (VkbInstanceError)(system_info_result.error().value() + 1);
        }
        
        return error;
    }
    
    EXPORT void delete_system_info(VkbSystemInfo* system_info) {
        auto* vkb_system_info = (vkb::SystemInfo*)*system_info;
        
        (*vkb_system_info).~SystemInfo();
        
        free((void*)*system_info);
        system_info = nullptr;
    }
    
    EXPORT bool is_layer_available(VkbSystemInfo system_info, const char* layer_name) {
        auto* vkb_system_info = (vkb::SystemInfo*)system_info;
        
        return vkb_system_info->is_layer_available(layer_name);
    }
    
    EXPORT bool is_extension_available(VkbSystemInfo system_info, const char* extension_name) {
        auto* vkb_system_info = (vkb::SystemInfo*)system_info;
        
        return vkb_system_info->is_extension_available(extension_name);
    }
    
    EXPORT void get_available_layers(VkbSystemInfo system_info, VkLayerProperties** data, size_t* length) {
        auto* vkb_system_info = (vkb::SystemInfo*)system_info;
        
        *data = vkb_system_info->available_layers.data();
        *length = vkb_system_info->available_extensions.size(); 
    }
    
    EXPORT void get_available_extensions(VkbSystemInfo system_info, VkExtensionProperties** data, size_t* length) {
        auto* vkb_system_info = (vkb::SystemInfo*)system_info;
        
        *data = vkb_system_info->available_extensions.data();
        *length = vkb_system_info->available_extensions.size();
    }
    
    EXPORT bool is_validation_layers_available(VkbSystemInfo system_info) {
        auto* vkb_system_info = (vkb::SystemInfo*)system_info;
        
        return vkb_system_info->validation_layers_available;    
    }
    
    EXPORT bool is_debug_utils_available(VkbSystemInfo system_info) {
        auto* vkb_system_info = (vkb::SystemInfo*)system_info;
        
        return vkb_system_info->debug_utils_available;
    }
} // namesapce VkbSystemInfoFunctions;

namespace VkbInstanceFunctions {
    EXPORT VkInstance get_vk_instance(VkbInstance instance) {
        auto* vkb_instance = (vkb::Instance*)instance;
        
        return vkb_instance->instance;    
    }
    
    EXPORT VkDebugUtilsMessengerEXT get_debug_messenger(VkbInstance instance) {
        auto* vkb_instance = (vkb::Instance*)instance;
        
        return vkb_instance->debug_messenger;
    }
    
    EXPORT VkAllocationCallbacks* get_allocation_callbacks(VkbInstance instance) {
        auto* vkb_instance = (vkb::Instance*)instance;
        
        return vkb_instance->allocation_callbacks;
    }
    
    EXPORT void destroy_instance(VkbInstance* instance) {
        auto* vkb_instance = (vkb::Instance*)*instance;
        
        vkb::destroy_instance(*vkb_instance);
        free((void*)*instance);
        instance = nullptr;
    }
} // namespace VkbInstanceFunctions

namespace VkbInstanceBuilderFunctions {
    EXPORT VkbInstanceBuilder make_instance_builder() {
        return make_instance_builder(nullptr);
    }
    
    EXPORT VkbInstanceBuilder make_instance_builder(PFN_vkGetInstanceProcAddr fp_vkGetInstanceProcAddr) {
        vkb::InstanceBuilder builder (fp_vkGetInstanceProcAddr);
        
        auto* result = (VkbInstanceBuilder)malloc(sizeof(vkb::InstanceBuilder));
        memcpy(result, &std::move(builder), sizeof(vkb::InstanceBuilder));
        
        return result;        
    }
    
    EXPORT void delete_instance_builder(VkbInstanceBuilder* builder) {
        auto* vkb_builder = (vkb::InstanceBuilder*)*builder;
        
        (*vkb_builder).~InstanceBuilder();
        
        free((void*)*builder);
        builder = nullptr;
    }
    
    EXPORT VkbInstanceError build(VkbInstanceBuilder builder, VkbInstance* result) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
        
        auto instance_result = vkb_builder->build();
        
        auto error = VkbInstanceError::NONE;
        
        if (instance_result.has_value()) {
            *result = (VkbInstance)malloc(sizeof(vkb::Instance));
            memcpy(*result, &std::move(instance_result), sizeof(vkb::Instance));
        } else {
            error = (VkbInstanceError)(instance_result.error().value() + 1);
        }
        
        return error;
    }
    
    EXPORT void set_app_name(VkbInstanceBuilder builder, const char* app_name) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
        
        vkb_builder->set_app_name(app_name);
    }
    
    EXPORT void set_engine_name(VkbInstanceBuilder builder, const char* engine_name) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
        
        vkb_builder->set_engine_name(engine_name);
    }

    EXPORT void set_app_version(VkbInstanceBuilder builder, uint32_t app_version) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
        
        vkb_builder->set_app_version(app_version);
    }
    
    EXPORT void set_app_version(VkbInstanceBuilder builder, uint32_t major, uint32_t minor, uint32_t patch) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
        
        vkb_builder->set_app_version(major, minor, patch);
    }

    EXPORT void set_engine_version(VkbInstanceBuilder builder, uint32_t engine_version) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
        
        vkb_builder->set_engine_version(engine_version);
    }
    
    EXPORT void set_engine_version(VkbInstanceBuilder builder, uint32_t major, uint32_t minor, uint32_t patch) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
        
        vkb_builder->set_engine_version(major, minor, patch);
    }

    EXPORT void require_api_version(VkbInstanceBuilder builder, uint32_t required_api_version) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
        
        vkb_builder->require_api_version(required_api_version);
    }
    
    EXPORT void require_api_version(VkbInstanceBuilder builder, uint32_t major, uint32_t minor, uint32_t patch) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
        
        vkb_builder->require_api_version(major, minor, patch);
    }

    EXPORT void set_minimum_instance_version(VkbInstanceBuilder builder, uint32_t minimum_instance_version) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
    
        vkb_builder->set_minimum_instance_version(minimum_instance_version);
    }
    
    EXPORT void set_minimum_instance_version(VkbInstanceBuilder builder, uint32_t major, uint32_t minor, uint32_t patch) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
    
        vkb_builder->set_minimum_instance_version(major, minor, patch);
    }

    EXPORT void enable_layer(VkbInstanceBuilder builder, const char* layer_name) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
        
        vkb_builder->enable_layer(layer_name);
    }
    
    EXPORT void enable_extension(VkbInstanceBuilder builder, const char* extension_name) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
        
        vkb_builder->enable_extension(extension_name);
    }
	
	EXPORT void enable_extensions(VkbInstanceBuilder builder, const char** extensions_data, size_t array_length) {
		auto* vkb_builder = (vkb::InstanceBuilder*)builder;
		
		vkb_builder->enable_extensions(std::vector<const char*>(extensions_data, extensions_data + array_length));
	}
	
	EXPORT void enable_extensions(VkbInstanceBuilder builder, size_t count, const char** extensions) {
		auto* vkb_builder = (vkb::InstanceBuilder*)builder;
		
		vkb_builder->enable_extensions(count, extensions);
	}

    EXPORT void set_headless(VkbInstanceBuilder builder, bool headless) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
        
        vkb_builder->set_headless(headless);
    }

    EXPORT void enable_validation_layers(VkbInstanceBuilder builder, bool require_validation) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
        
        vkb_builder->enable_validation_layers(require_validation);
    }
    
    EXPORT void request_validation_layers(VkbInstanceBuilder builder, bool enable_validation) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
    
        vkb_builder->request_validation_layers(enable_validation);
    }

    EXPORT void use_default_debug_messenger(VkbInstanceBuilder builder) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
        
        vkb_builder->use_default_debug_messenger();
    }
    
    EXPORT void set_debug_callback(VkbInstanceBuilder builder, PFN_vkDebugUtilsMessengerCallbackEXT callback) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
        
        vkb_builder->set_debug_callback(callback);
    }
    
    EXPORT void set_debug_callback_user_data_pointer(VkbInstanceBuilder builder, void* user_data_pointer) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
        
        vkb_builder->set_debug_callback_user_data_pointer(user_data_pointer);
    }
    
    EXPORT void set_debug_messenger_severity(VkbInstanceBuilder builder, VkDebugUtilsMessageSeverityFlagsEXT severity) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
        
        vkb_builder->set_debug_messenger_severity(severity);
    }
    
    EXPORT void add_debug_messenger_severity(VkbInstanceBuilder builder, VkDebugUtilsMessageSeverityFlagsEXT severity) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
    
        vkb_builder->add_debug_messenger_severity(severity);
    }
    
    EXPORT void set_debug_messenger_type(VkbInstanceBuilder builder, VkDebugUtilsMessageTypeFlagsEXT type) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
    
        vkb_builder->set_debug_messenger_type(type);
    }
    
    EXPORT void add_debug_messenger_type(VkbInstanceBuilder builder, VkDebugUtilsMessageTypeFlagsEXT type) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
    
        vkb_builder->add_debug_messenger_type(type);
    }

    EXPORT void add_validation_disable(VkbInstanceBuilder builder, VkValidationCheckEXT check) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
        
        vkb_builder->add_validation_disable(check);
    }

    EXPORT void add_validation_feature_enable(VkbInstanceBuilder builder, VkValidationFeatureEnableEXT enable) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
        
        vkb_builder->add_validation_feature_enable(enable);
    }

    EXPORT void add_validation_feature_disable(VkbInstanceBuilder builder, VkValidationFeatureDisableEXT disable) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
        
        vkb_builder->add_validation_feature_disable(disable);
    }

    EXPORT void set_allocation_callbacks(VkbInstanceBuilder builder, VkAllocationCallbacks* callbacks) {
        auto* vkb_builder = (vkb::InstanceBuilder*)builder;
        
        vkb_builder->set_allocation_callbacks(callbacks);
    }
} // namespace VkbInstanceBuilderFunctions

namespace VkbPhysicalDeviceFunctions {
    EXPORT void get_name(VkbPhysicalDevice pdevice, const char** data, size_t* length) {
        auto* vkb_pdevice = (vkb::PhysicalDevice*)pdevice;
        
        *data = vkb_pdevice->name.c_str();
        *length = vkb_pdevice->name.size();
    }
    
    EXPORT VkPhysicalDevice get_vk_physical_device(VkbPhysicalDevice pdevice) {
        auto* vkb_pdevice = (vkb::PhysicalDevice*)pdevice;
        
        return vkb_pdevice->physical_device;
    }
    
    EXPORT VkSurfaceKHR get_vk_surface(VkbPhysicalDevice pdevice) {
        auto* vkb_pdevice = (vkb::PhysicalDevice*)pdevice;
    
        return vkb_pdevice->surface;
    }
    
    EXPORT void destroy_physical_device(VkbPhysicalDevice* pdevice, VkbInstance instance) {
        auto* vkb_pdevice = (vkb::PhysicalDevice*)pdevice;
        auto* vkb_instance = (vkb::Instance*)instance;
        
        vkb::destroy_surface(*vkb_instance, vkb_pdevice->surface);
        
        free(pdevice);
    }
    
    EXPORT VkPhysicalDeviceFeatures get_vk_device_features(VkbPhysicalDevice pdevice) {
        auto* vkb_pdevice = (vkb::PhysicalDevice*)pdevice;
        
        return vkb_pdevice->features;
    }
    
    EXPORT VkPhysicalDeviceProperties get_vk_device_properties(VkbPhysicalDevice pdevice) {
        auto* vkb_pdevice = (vkb::PhysicalDevice*)pdevice;
    
        return vkb_pdevice->properties;
    }
    
    EXPORT VkPhysicalDeviceMemoryProperties get_vk_device_memory_properties(VkbPhysicalDevice pdevice) {
        auto* vkb_pdevice = (vkb::PhysicalDevice*)pdevice;
        
        return vkb_pdevice->memory_properties;
    }
    
    EXPORT bool has_dedicated_compute_queue(VkbPhysicalDevice pdevice) {
        auto* vkb_pdevice = (vkb::PhysicalDevice*)pdevice;
        
        return vkb_pdevice->has_dedicated_compute_queue();
    }
    
    EXPORT bool has_dedicated_transfer_queue(VkbPhysicalDevice pdevice) {
        auto* vkb_pdevice = (vkb::PhysicalDevice*)pdevice;
        
        return vkb_pdevice->has_dedicated_transfer_queue();
    }

    EXPORT bool has_separate_compute_queue(VkbPhysicalDevice pdevice) {
        auto* vkb_pdevice = (vkb::PhysicalDevice*)pdevice;
    
        return vkb_pdevice->has_separate_compute_queue();
    }
    
    EXPORT bool has_separate_transfer_queue(VkbPhysicalDevice pdevice) {
        auto* vkb_pdevice = (vkb::PhysicalDevice*)pdevice;
        
        return vkb_pdevice->has_separate_transfer_queue();
    }

    EXPORT void get_queue_families(VkbPhysicalDevice pdevice, VkQueueFamilyProperties** data, size_t* length) {
        auto* vkb_pdevice = (vkb::PhysicalDevice*)pdevice;
        
        auto queue_families = vkb_pdevice->get_queue_families();
        
        *data = queue_families.data();
        *length = queue_families.size();
    }

    EXPORT void get_extensions(VkbPhysicalDevice pdevice, const char*** array_data, size_t* array_length, size_t** string_lengths) {
        auto* vkb_pdevice = (vkb::PhysicalDevice*)pdevice;
        
        auto extensions = vkb_pdevice->get_extensions();
        
        size_t* _string_lengths = (size_t*)malloc(sizeof(size_t) * extensions.size());
        const char** _array_data = (const char**)malloc(sizeof(const char*) * extensions.size());
        
        auto i = 0;
        for (auto extension : extensions) {
            _string_lengths[i] = extension.size();
            _array_data[i] = extension.data();
            
            i += 1;
        }
        
        *array_data = _array_data;
        *string_lengths = _string_lengths;
        *array_length = extensions.size();
    }

    EXPORT void get_available_extensions(VkbPhysicalDevice pdevice, const char*** array_data, size_t* array_length, size_t** string_lengths) {
        auto* vkb_pdevice = (vkb::PhysicalDevice*)pdevice;
        
        auto extensions = vkb_pdevice->get_available_extensions();
        
        size_t* _string_lengths = (size_t*)malloc(sizeof(size_t) * extensions.size());
        const char** _array_data = (const char**)malloc(sizeof(const char*) * extensions.size());
        
        auto i = 0;
        for (auto extension : extensions) {
            _string_lengths[i] = extension.size();
            _array_data[i] = extension.data();
            
            i++;
        }
        
        *array_data = _array_data;
        *string_lengths = _string_lengths;
        *array_length = extensions.size();
    }

    EXPORT bool is_extension_present(VkbPhysicalDevice pdevice, const char* extension) {
        auto* vkb_pdevice = (vkb::PhysicalDevice*)pdevice;
        
        return vkb_pdevice->is_extension_present(extension);
    }

    EXPORT bool enable_extension_if_present(VkbPhysicalDevice pdevice, const char* extension) {
        auto* vkb_pdevice = (vkb::PhysicalDevice*)pdevice;
        
        return vkb_pdevice->enable_extension_if_present(extension);
    }
} // namespace VkbPhysicalDeviceFunctions

namespace VkbPhysicalDeviceSelectorFunctions {
    EXPORT VkbPhysicalDeviceSelector make_physical_device_selector(VkbInstance instance) {
        return make_physical_device_selector(instance, VK_NULL_HANDLE);
    }
    
    EXPORT VkbPhysicalDeviceSelector make_physical_device_selector(VkbInstance instance, VkSurfaceKHR surface) {
        auto* vkb_instance = (vkb::Instance*)instance;
        
        vkb::PhysicalDeviceSelector selector((vkb::Instance&)vkb_instance, surface);
        
        auto* result = (VkbPhysicalDeviceSelector)malloc(sizeof(vkb::PhysicalDeviceSelector));
        
        memcpy(result, &std::move(selector), sizeof(vkb::PhysicalDeviceSelector));
        
        return result;
    }
    
    EXPORT void delete_physical_device_selector(VkbPhysicalDeviceSelector* selector) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)*selector;
        
        (*vkb_selector).~PhysicalDeviceSelector();
        free((void*)*selector);
        selector = nullptr;
    }
    
    VkbPhysicalDevice copy_vkb_physical_device(vkb::Result<vkb::PhysicalDevice>&& pdevice) {
        auto result = (VkbPhysicalDevice)malloc(sizeof(vkb::PhysicalDevice));
        memcpy(result, &std::move(pdevice), sizeof(vkb::PhysicalDevice));
        return result;
    }
    
    EXPORT VkbPhysicalDeviceError select(VkbPhysicalDeviceSelector selector, VkbPhysicalDevice* result, VkbDeviceSelectionMode selection) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)selector;
        
        auto physical_device_result = vkb_selector->select((vkb::DeviceSelectionMode)selection);
        
        auto error = VkbPhysicalDeviceError::NONE;
        
        if (physical_device_result.has_value()) {
            *result = copy_vkb_physical_device(std::move(physical_device_result));
        } else {
            error = (VkbPhysicalDeviceError)(physical_device_result.error().value()+1);
        }
        
        return error;
    }
    
    EXPORT VkbPhysicalDeviceError select_devices(VkbPhysicalDeviceSelector selector, VkbPhysicalDevice** results, size_t* length, VkbDeviceSelectionMode selection) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)selector;
        
        auto physical_device_results = vkb_selector->select_devices((vkb::DeviceSelectionMode)selection); 
        
        auto error = VkbPhysicalDeviceError::NONE;
        
        if (physical_device_results.has_value()) {
            auto* physical_devices = (VkbPhysicalDevice*)malloc(sizeof(VkbPhysicalDevice) * physical_device_results.get_value().size());
            
            auto i = 0;
            for (auto physical_device_result : physical_device_results.get_value()) {
                physical_devices[i] = copy_vkb_physical_device(std::move(physical_device_result));
                
                i += 1;
            }
            
            *results = physical_devices;
            *length = physical_device_results.get_value().size();
        } else {
            error = (VkbPhysicalDeviceError)(physical_device_results.error().value()+1);
        }
        
        return error;
    }
    
    EXPORT VkbPhysicalDeviceError select_device_names(VkbPhysicalDeviceSelector selector, const char*** array_data, size_t* array_length, size_t** string_lengths, VkbDeviceSelectionMode selection) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)selector;
        
        auto device_name_results = vkb_selector->select_device_names((vkb::DeviceSelectionMode)selection); 
        
        auto error = VkbPhysicalDeviceError::NONE;
        
        if (device_name_results.has_value()) {
            size_t* _string_lengths = (size_t*)malloc(sizeof(size_t) * device_name_results.get_value().size());
            const char** _array_data = (const char**)malloc(sizeof(const char*) * device_name_results.get_value().size());
            
            auto i = 0;
            for (auto device_name : device_name_results.get_value()) {
                _string_lengths[i] = device_name.size();
                _array_data[i] = device_name.data();
                
                i += 1;
            }
            
            *array_data = _array_data;
            *string_lengths = _string_lengths;
            *array_length = device_name_results.get_value().size();
        } else {
            error = (VkbPhysicalDeviceError)(device_name_results.error().value() + 1);
        }
        
        return error;
    }
    
    EXPORT void set_surface(VkbPhysicalDeviceSelector selector, VkSurfaceKHR surface) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)selector;
    
        vkb_selector->set_surface(surface);
    }

    EXPORT void set_name(VkbPhysicalDeviceSelector selector, const char* name, size_t name_char_length) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)selector;
        
        std::string the_name(name, name_char_length);
        
        vkb_selector->set_name(the_name);
    }
    
    EXPORT void prefer_gpu_device_type(VkbPhysicalDeviceSelector selector, VkbPreferredDeviceType type) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)selector;
        
        vkb_selector->prefer_gpu_device_type((vkb::PreferredDeviceType)type);
    }
    
    EXPORT void allow_any_gpu_device_type(VkbPhysicalDeviceSelector selector, bool allow_any_type) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)selector;
        
        vkb_selector->allow_any_gpu_device_type(allow_any_type);
    }

    EXPORT void require_present(VkbPhysicalDeviceSelector selector, bool require) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)selector;
    
        vkb_selector->require_present(require);
    }

    EXPORT void require_dedicated_compute_queue(VkbPhysicalDeviceSelector selector) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)selector;
        
        vkb_selector->require_dedicated_compute_queue();
    }
    
    EXPORT void require_dedicated_transfer_queue(VkbPhysicalDeviceSelector selector) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)selector;
        
        vkb_selector->require_dedicated_transfer_queue();
    }

    EXPORT void require_separate_compute_queue(VkbPhysicalDeviceSelector selector) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)selector;
        
        vkb_selector->require_separate_compute_queue();
    }
    
    EXPORT void require_separate_transfer_queue(VkbPhysicalDeviceSelector selector) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)selector;
        
        vkb_selector->require_separate_transfer_queue();
    }

    EXPORT void required_device_memory_size(VkbPhysicalDeviceSelector selector, VkDeviceSize size) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)selector;
        
        vkb_selector->required_device_memory_size(size);
    }

    EXPORT void add_required_extension(VkbPhysicalDeviceSelector selector, const char* extension) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)selector;
        
        vkb_selector->add_required_extension(extension);
    }
    
    EXPORT void add_required_extensions(VkbPhysicalDeviceSelector selector, const char** extensions, size_t length) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)selector;
        
        std::vector<const char*> the_extensions(length);
        
        memcpy(the_extensions.data(), extensions, sizeof(const char*) * length);
        
        vkb_selector->add_required_extensions(the_extensions);
    }

    EXPORT void set_minimum_version(VkbPhysicalDeviceSelector selector, uint32_t major, uint32_t minor) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)selector;
    
        vkb_selector->set_minimum_version(major, minor);
    }

    EXPORT void disable_portability_subset(VkbPhysicalDeviceSelector selector) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)selector;
        
        vkb_selector->disable_portability_subset();
    }

    EXPORT void add_required_extension_features(VkbPhysicalDevice selector, void* data, size_t size) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)selector;
        
        vkb::detail::GenericFeaturesPNextNode node;
        memcpy(&node, data, size);
        
        vkb_selector->add_required_extension_features(node);
    }

    EXPORT void set_required_features(VkbPhysicalDeviceSelector selector, VkPhysicalDeviceFeatures const& features) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)selector;
        
        vkb_selector->set_required_features(features);
    }
    
#if defined(VKB_VK_API_VERSION_1_2)
    EXPORT void set_required_features_11(VkbPhysicalDeviceSelector selector, VkPhysicalDeviceVulkan11Features features_11) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)selector;
        
        vkb_selector->set_required_features_11(features_11);
    }
    
    EXPORT void set_required_features_12(VkbPhysicalDeviceSelector selector, VkPhysicalDeviceVulkan12Features features_12) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)selector;
        
        vkb_selector->set_required_features_12(features_12);
    }
#endif
#if defined(VKB_VK_API_VERSION_1_3)
    EXPORT void set_required_features_13(VkbPhysicalDeviceSelector selector, VkPhysicalDeviceVulkan13Features features_13) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)selector;
    
        vkb_selector->set_required_features_13(features_13);
    }
#endif

    EXPORT void defer_surface_initialization(VkbPhysicalDeviceSelector selector) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)selector;
        
        vkb_selector->defer_surface_initialization();
    }

    EXPORT void select_first_device_unconditionally(VkbPhysicalDeviceSelector selector, bool unconditionally) {
        auto vkb_selector = (vkb::PhysicalDeviceSelector*)selector;
        
        vkb_selector->select_first_device_unconditionally();
    }
} // namespace VkbPhysicalDeviceSelectorFunctions

namespace VkbDeviceFunctions {
    EXPORT VkDevice get_vk_device(VkbDevice device) {
        auto* vkb_device = (vkb::Device*)device;
        
        return vkb_device->device;
    }
    
    EXPORT void get_queue_families(VkbDevice device, VkQueueFamilyProperties** queue_families, size_t* length) {
        auto* vkb_device = (vkb::Device*)device;
        
        *queue_families = vkb_device->queue_families.data();
        *length = vkb_device->queue_families.size();
    }
    
    EXPORT VkAllocationCallbacks* get_allocation_callbacks(VkbDevice device) {
        auto* vkb_device = (vkb::Device*)device;
        
        return vkb_device->allocation_callbacks;
    }
    
    EXPORT void destroy_device(VkbDevice* device) {
        auto* vkb_device = (vkb::Device*)*device;
        
        vkb::destroy_device(*vkb_device);
        
        free((void*)*device);
        device = nullptr;
    }
    
    #define GetQueueLogic(function_name)                                        \
        auto* vkb_device = (vkb::Device*)device;                                \
                                                                                \
        auto queue_result = vkb_device->##function_name##((vkb::QueueType)type);\
                                                                                \
        auto error = VkbQueueError::NONE;                                       \
                                                                                \
        if (queue_result.has_value()) {                                         \
            *result = queue_result.get_value();                                 \
        } else {                                                                \
            error = (VkbQueueError)(queue_result.error().value()+1);            \
        }                                                                       \
                                                                                \
        return error;
    
    EXPORT VkbQueueError get_queue_index(VkbDevice device, VkbQueueType type, uint32_t* result) {
        GetQueueLogic(get_queue_index);
    }
    
    EXPORT VkbQueueError get_dedicated_queue_index(VkbDevice device, VkbQueueType type, uint32_t* result) {
        GetQueueLogic(get_dedicated_queue_index);
    }
    
    EXPORT VkbQueueError get_queue(VkbDevice device, VkbQueueType type, VkQueue* result) {
        GetQueueLogic(get_queue);
    }
    
    EXPORT VkbQueueError get_dedicated_queue(VkbDevice device, VkbQueueType type, VkQueue* result) {
        GetQueueLogic(get_dedicated_queue);
    }
} // namespace VkbDeviceFunctions

namespace VkbDeviceBuilderFunctions {
    EXPORT VkbDeviceBuilder make_device_builder(VkbPhysicalDevice physical_device) {
        auto* vkb_pdevice = (vkb::PhysicalDevice*)physical_device;
        
        vkb::DeviceBuilder builder(*vkb_pdevice);
        
        auto result = (VkbDeviceBuilder)malloc(sizeof(vkb::DeviceBuilder));
        
        memcpy(result, &std::move(builder), sizeof(vkb::DeviceBuilder));
        
        return result;
    }
    
    EXPORT void delete_device_builder(VkbDeviceBuilder* builder) {
        auto vkb_builder = (vkb::DeviceBuilder*)builder;
        
        (*vkb_builder).~DeviceBuilder();
        
        free((void*)*builder);
        builder = nullptr;
    }
    
    EXPORT VkbDeviceError build(VkbDeviceBuilder builder, VkbDevice* result) {
        auto vkb_builder = (vkb::DeviceBuilder*)builder;
        
        auto device_result = vkb_builder->build();
        
        auto error = VkbDeviceError::NONE;
        
        if (device_result.has_value()) {
            *result = (VkbDevice)malloc(sizeof(vkb::Device));
            memcpy(*result, &std::move(device_result), sizeof(vkb::Device));
        } else {
            error = (VkbDeviceError)(device_result.error().value() + 1);
        }
        
        return error;
    }
    
    EXPORT void add_pNext(VkbDeviceBuilder builder, VkBaseOutStructure* structure) {
        auto vkb_builder = (vkb::DeviceBuilder*)builder;
        
        vkb_builder->add_pNext(structure);
    }

    EXPORT void set_allocation_callbacks(VkbDeviceBuilder builder, VkAllocationCallbacks* callbacks) {
        auto vkb_builder = (vkb::DeviceBuilder*)builder;
        
        vkb_builder->set_allocation_callbacks(callbacks);
    }
} // namespace VkbDeviceBuilderFunctions

namespace VkbSwapchainFunctions {
    EXPORT uint32_t get_image_count(VkbSwapchain swapchain) {
        auto* vkb_swapchain = (vkb::Swapchain*)swapchain;
        
        return vkb_swapchain->image_count;
    }
    
    EXPORT VkFormat get_image_format(VkbSwapchain swapchain) {
        auto* vkb_swapchain = (vkb::Swapchain*)swapchain;
    
        return vkb_swapchain->image_format;
    }
    
    EXPORT VkColorSpaceKHR get_color_space(VkbSwapchain swapchain) {
        auto* vkb_swapchain = (vkb::Swapchain*)swapchain;
        
        return vkb_swapchain->color_space;
    }
    
    EXPORT VkExtent2D get_extent(VkbSwapchain swapchain) {
        auto* vkb_swapchain = (vkb::Swapchain*)swapchain;
        
        return vkb_swapchain->extent;
    }
    
    EXPORT VkImageUsageFlags get_image_usage_flags(VkbSwapchain swapchain) {
        auto* vkb_swapchain = (vkb::Swapchain*)swapchain;
        
        return vkb_swapchain->image_usage_flags;
    }
    
    EXPORT VkPresentModeKHR get_present_mode(VkbSwapchain swapchain) {
        auto* vkb_swapchain = (vkb::Swapchain*)swapchain;
    
        return vkb_swapchain->present_mode;
    }
    
    EXPORT VkAllocationCallbacks* get_allocation_callbacks(VkbSwapchain swapchain) {
        auto* vkb_swapchain = (vkb::Swapchain*)swapchain;
        
        return vkb_swapchain->allocation_callbacks;
    }
    
    EXPORT void destroy_swapchain(VkbSwapchain* swapchain) {
        auto* vkb_swapchain = (vkb::Swapchain*)*swapchain;
        
        vkb::destroy_swapchain(*vkb_swapchain);
        
        // (*vkb_swapchain).~Swapchain();
        free((void*)*swapchain);
        swapchain = nullptr;
    }
    
    EXPORT VkbSwapchainError get_images(VkbSwapchain swapchain, VkImage** data, size_t* length) {
        auto* vkb_swapchain = (vkb::Swapchain*)swapchain;
        
        auto result_vector = vkb_swapchain->get_images(); 
        
        auto error = VkbSwapchainError::NONE;
        
        if (result_vector.has_value()) {
            auto* new_vector_data = (VkImage*)malloc(sizeof(VkImage)*result_vector.get_value().size());
            
            memcpy(new_vector_data, result_vector.get_value().data(), sizeof(VkImage) * result_vector.get_value().size());
            
            *data = new_vector_data;
            *length = result_vector.get_value().size();
        } else {
            error = (VkbSwapchainError)(result_vector.error().value() + 1);
        }
        
        return error;
    }
    
    EXPORT void destroy_images(VkImage* data) {
        free((void*)data);
    }
    
    EXPORT VkbSwapchainError get_image_views(VkbSwapchain swapchain, VkImageView** data, size_t* length) {
        return get_image_views(swapchain, nullptr, data, length);
    }
    
    EXPORT VkbSwapchainError get_image_views(VkbSwapchain swapchain, const void* pNext, VkImageView** data, size_t* length) {
        auto* vkb_swapchain = (vkb::Swapchain*)swapchain;
        
        auto result_vector = vkb_swapchain->get_image_views(pNext);
        
        auto error = VkbSwapchainError::NONE;
        
        if (result_vector.has_value()) {
            auto* new_vector_data = (VkImageView*)malloc(sizeof(VkImageView) * result_vector.get_value().size());
            
            memcpy(new_vector_data, result_vector.get_value().data(), sizeof(VkImageView) * result_vector.get_value().size());
            
            *data = new_vector_data;
            *length = result_vector.get_value().size();
        } else {
            error = (VkbSwapchainError)(result_vector.error().value() + 1);
        }
        
        return error;
    }
    
    EXPORT void destroy_image_views(VkbSwapchain swapchain, VkImageView* data, size_t length) {
        auto* vkb_swapchain = (vkb::Swapchain*)swapchain;
        
        std::vector<VkImageView> image_views(length);
        memcpy(image_views.data(), data, length * sizeof(VkImageView));

        vkb_swapchain->destroy_image_views(image_views);
        
        free((void*)data);        
    }
} // namespace VkbSwapchainFunctions

namespace VkbSwapchainBuilderFunctions {
    EXPORT VkbSwapchainBuilder make_swapchain_builder(VkbDevice device) {
        return make_swapchain_builder(device, VK_NULL_HANDLE);
    }
    
    EXPORT VkbSwapchainBuilder make_swapchain_builder(VkbDevice device, VkSurfaceKHR surface) {
        auto* vkb_device = (vkb::Device*)device;
        
        vkb::SwapchainBuilder builder(*vkb_device, surface);
        
        auto* result = (VkbSwapchainBuilder)malloc(sizeof(vkb::SwapchainBuilder));
        
        memcpy(result, &std::move(builder), sizeof(vkb::SwapchainBuilder));
        
        return result;
    }
    
    EXPORT void delete_swapchain_builder(VkbSwapchainBuilder* builder) {
        auto* vkb_builder = (vkb::SwapchainBuilder*)*builder;
        
        (*vkb_builder).~SwapchainBuilder();
        free((void*)*builder);
        builder = nullptr;
    }
    
    EXPORT VkbSwapchainError build(VkbSwapchainBuilder builder, VkbSwapchain* result) {
        auto* vkb_builder = (vkb::SwapchainBuilder*)builder;
        
        auto swapchain_result = vkb_builder->build();
        
        auto error = VkbSwapchainError::NONE;
        
        if (swapchain_result.has_value()) {
            *result = (VkbSwapchain)malloc(sizeof(vkb::Swapchain));
            memcpy(*result, &std::move(swapchain_result), sizeof(vkb::Swapchain));
        } else {
            error = (VkbSwapchainError)(swapchain_result.error().value() + 1);
        }
        
        return error;
    }

    EXPORT void set_old_swapchain(VkbSwapchainBuilder builder, VkSwapchainKHR old_swapchain) {
        auto* vkb_builder = (vkb::SwapchainBuilder*)builder;
        
        vkb_builder->set_old_swapchain(old_swapchain);
    }
    
    EXPORT void set_old_swapchain(VkbSwapchainBuilder builder, VkbSwapchain old_swapchain) {
        auto* vkb_builder = (vkb::SwapchainBuilder*)builder;
        
        auto* vkb_swapchain = (vkb::Swapchain*)old_swapchain;
        
        vkb_builder->set_old_swapchain(*vkb_swapchain);
    }
    
    EXPORT void set_desired_extent(VkbSwapchainBuilder builder, uint32_t width, uint32_t height) {
        auto* vkb_builder = (vkb::SwapchainBuilder*)builder;
        
        vkb_builder->set_desired_extent(width, height);
    }

    EXPORT void set_desired_format(VkbSwapchainBuilder builder, VkSurfaceFormatKHR format) {
        auto* vkb_builder = (vkb::SwapchainBuilder*)builder;
        
        vkb_builder->set_desired_format(format);
    }
    
    EXPORT void add_fallback_format(VkbSwapchainBuilder builder, VkSurfaceFormatKHR format) {
        auto* vkb_builder = (vkb::SwapchainBuilder*)builder;
    
        vkb_builder->add_fallback_format(format);
    }
    
    EXPORT void use_default_format_selection(VkbSwapchainBuilder builder) {
        auto* vkb_builder = (vkb::SwapchainBuilder*)builder;
        
        vkb_builder->use_default_format_selection();
    }

    EXPORT void set_desired_present_mode(VkbSwapchainBuilder builder, VkPresentModeKHR present_mode) {
        auto* vkb_builder = (vkb::SwapchainBuilder*)builder;
        
        vkb_builder->set_desired_present_mode(present_mode);
    }
    
    EXPORT void add_fallback_present_mode(VkbSwapchainBuilder builder, VkPresentModeKHR present_mode) {
        auto* vkb_builder = (vkb::SwapchainBuilder*)builder;
        
        vkb_builder->add_fallback_present_mode(present_mode);
    }
    
    EXPORT void use_default_present_mode_selection(VkbSwapchainBuilder builder) {
        auto* vkb_builder = (vkb::SwapchainBuilder*)builder;
        
        vkb_builder->use_default_present_mode_selection();
    }

    EXPORT void set_image_usage_flags(VkbSwapchainBuilder builder, VkImageUsageFlags usage_flags) {
        auto* vkb_builder = (vkb::SwapchainBuilder*)builder;
        
        vkb_builder->set_image_usage_flags(usage_flags);
    }
    
    EXPORT void add_image_usage_flags(VkbSwapchainBuilder builder, VkImageUsageFlags usage_flags) {
        auto* vkb_builder = (vkb::SwapchainBuilder*)builder;
        
        vkb_builder->add_image_usage_flags(usage_flags);
    }
    
    EXPORT void use_default_image_usage_flags(VkbSwapchainBuilder builder) {
        auto* vkb_builder = (vkb::SwapchainBuilder*)builder;
        
        vkb_builder->use_default_image_usage_flags();
    }

    EXPORT void set_image_array_layer_count(VkbSwapchainBuilder builder, uint32_t array_layer_count) {
        auto* vkb_builder = (vkb::SwapchainBuilder*)builder;
        
        vkb_builder->set_image_array_layer_count(array_layer_count);
    }

    EXPORT void set_desired_min_image_count(VkbSwapchainBuilder builder, uint32_t min_image_count) {
        auto* vkb_builder = (vkb::SwapchainBuilder*)builder;
        
        vkb_builder->set_desired_min_image_count(min_image_count);
    }

    EXPORT void set_required_min_image_count(VkbSwapchainBuilder builder, uint32_t required_min_image_count) {
        auto* vkb_builder = (vkb::SwapchainBuilder*)builder;
        
        vkb_builder->set_required_min_image_count(required_min_image_count);
    }

    EXPORT void set_clipped(VkbSwapchainBuilder builder, bool clipped) {
        auto* vkb_builder = (vkb::SwapchainBuilder*)builder;
        
        vkb_builder->set_clipped(clipped);
    }

    EXPORT void set_create_flags(VkbSwapchainBuilder builder, VkSwapchainCreateFlagBitsKHR create_flags) {
        auto* vkb_builder = (vkb::SwapchainBuilder*)builder;
        
        vkb_builder->set_create_flags(create_flags);
    }
    
    EXPORT void set_pre_transform_flags(VkbSwapchainBuilder builder, VkSurfaceTransformFlagBitsKHR pre_transform_flags) {
        auto* vkb_builder = (vkb::SwapchainBuilder*)builder;
        
        vkb_builder->set_pre_transform_flags(pre_transform_flags);
    }
    
    EXPORT void set_composite_alpha_flags(VkbSwapchainBuilder builder, VkCompositeAlphaFlagBitsKHR composite_alpha_flags) {
        auto* vkb_builder = (vkb::SwapchainBuilder*)builder;
        
        vkb_builder->set_composite_alpha_flags(composite_alpha_flags);
    }

    EXPORT void add_pNext(VkbSwapchainBuilder builder, VkBaseOutStructure* structure) {
        auto* vkb_builder = (vkb::SwapchainBuilder*)builder;
        
        vkb_builder->add_pNext(structure);
    }

    EXPORT void set_allocation_callbacks(VkbSwapchainBuilder builder, VkAllocationCallbacks* callbacks) {
        auto* vkb_builder = (vkb::SwapchainBuilder*)builder;
        
        vkb_builder->set_allocation_callbacks(callbacks);
    }
} // namespace VkbSwapchainBuilderFunctions

// A quick little c wrapper to help remove any allocated memory.
EXPORT void _vkb_impl_c_free(void* data) {
    free(data);
}