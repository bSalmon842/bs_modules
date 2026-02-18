SOFTWARE_RENDERER ::   "software";

Vertex :: struct
{
    position:  F_Point;
    color:     F_Color;
    tex_coord: F_Point;
}

Texture_Access :: enum u32
{
    STATIC;
    STREAMING;
    TARGET;
}

Renderer_Logical_Presentation :: enum u32
{
    DISABLED;
    STRETCH;
    LETTERBOX;
    OVERSCAN;
    INTEGER_SCALE;
}

Renderer :: void;
Texture  :: void;

get_num_render_drivers               :: () -> s32                                                                                                                                                                                                               #foreign SDL3 "SDL_GetNumRenderDrivers";
get_render_driver                    :: (index: s32) -> *u8                                                                                                                                                                                                     #foreign SDL3 "SDL_GetRenderDriver";
create_window_and_renderer           :: (title: *u8, width: s32, height: s32, window_flags: Window_Flags, window: **Window, renderer: **Renderer) -> bool                                                                                                       #foreign SDL3 "SDL_CreateWindowAndRenderer";
create_renderer                      :: (window: *Window, name: *u8) -> *Renderer                                                                                                                                                                               #foreign SDL3 "SDL_CreateRenderer";
create_renderer_with_properties      :: (props: Properties_ID) -> *Renderer                                                                                                                                                                                     #foreign SDL3 "SDL_CreateRendererWithProperties";
create_software_renderer             :: (surface: *Surface) -> *Renderer                                                                                                                                                                                        #foreign SDL3 "SDL_CreateSoftwareRenderer";
get_renderer                         :: (window: *Window) -> *Renderer                                                                                                                                                                                          #foreign SDL3 "SDL_GetRenderer";
get_render_window                    :: (renderer: *Renderer) -> *Window                                                                                                                                                                                        #foreign SDL3 "SDL_GetRenderWindow";
get_renderer_name                    :: (renderer: *Renderer) -> *u8                                                                                                                                                                                            #foreign SDL3 "SDL_GetRendererName";
get_renderer_properties              :: (renderer: *Renderer) -> Properties_ID                                                                                                                                                                                  #foreign SDL3 "SDL_GetRendererProperties";
get_render_output_size               :: (renderer: *Renderer, w: *s32, h: *s32) -> bool                                                                                                                                                                         #foreign SDL3 "SDL_GetRenderOutputSize";
get_current_render_output_size       :: (renderer: *Renderer, w: *s32, h: *s32) -> bool                                                                                                                                                                         #foreign SDL3 "SDL_GetCurrentRenderOutputSize";
create_texture                       :: (renderer: *Renderer, format: Pixel_Format, access: Texture_Access, w: s32, h: s32) -> *Texture                                                                                                                          #foreign SDL3 "SDL_CreateTexture";
create_texture_from_surface          :: (renderer: *Renderer, surface: *Surface) -> *Texture                                                                                                                                                                    #foreign SDL3 "SDL_CreateTextureFromSurface";
create_texture_with_properties       :: (renderer: *Renderer, props: Properties_ID) -> *Texture                                                                                                                                                                 #foreign SDL3 "SDL_CreateTextureWithProperties";
get_texture_properties               :: (texture: *Texture) -> Properties_ID                                                                                                                                                                                    #foreign SDL3 "SDL_GetTextureProperties";
get_renderer_from_texture            :: (texture: *Texture) -> *Renderer                                                                                                                                                                                        #foreign SDL3 "SDL_GetRendererFromTexture";
get_texture_size                     :: (texture: *Texture, w: *float32, h: *float32) -> bool                                                                                                                                                                   #foreign SDL3 "SDL_GetTextureSize";
set_texture_color_mod                :: (texture: *Texture, r: u8, g: u8, b: u8) -> bool                                                                                                                                                                        #foreign SDL3 "SDL_SetTextureColorMod";
set_texture_color_mod_float          :: (texture: *Texture, r: float32, g: float32, b: float32) -> bool                                                                                                                                                         #foreign SDL3 "SDL_SetTextureColorModFloat";
get_texture_color_mod                :: (texture: *Texture, r: *u8, g: *u8, b: *u8) -> bool                                                                                                                                                                     #foreign SDL3 "SDL_GetTextureColorMod";
get_texture_color_mod_float          :: (texture: *Texture, r: *float32, g: *float32, b: *float32) -> bool                                                                                                                                                      #foreign SDL3 "SDL_GetTextureColorModFloat";
set_texture_alpha_mod                :: (texture: *Texture, alpha: u8) -> bool                                                                                                                                                                                  #foreign SDL3 "SDL_SetTextureAlphaMod";
set_texture_alpha_mod_float          :: (texture: *Texture, alpha: float32) -> bool                                                                                                                                                                             #foreign SDL3 "SDL_SetTextureAlphaModFloat";
get_texture_alpha_mod                :: (texture: *Texture, alpha: *u8) -> bool                                                                                                                                                                                 #foreign SDL3 "SDL_GetTextureAlphaMod";
get_texture_alpha_mod_float          :: (texture: *Texture, alpha: *float32) -> bool                                                                                                                                                                            #foreign SDL3 "SDL_GetTextureAlphaModFloat";
set_texture_blend_mode               :: (texture: *Texture, blend_mode: Blend_Mode) -> bool                                                                                                                                                                     #foreign SDL3 "SDL_SetTextureBlendMode";
get_texture_blend_mode               :: (texture: *Texture, blend_mode: *Blend_Mode) -> bool                                                                                                                                                                    #foreign SDL3 "SDL_GetTextureBlendMode";
set_texture_scale_mode               :: (texture: *Texture, scale_mode: Scale_Mode) -> bool                                                                                                                                                                     #foreign SDL3 "SDL_SetTextureScaleMode";
get_texture_scale_mode               :: (texture: *Texture, scale_mode: *Scale_Mode) -> bool                                                                                                                                                                    #foreign SDL3 "SDL_GetTextureScaleMode";
update_texture                       :: (texture: *Texture, rect: *Rect, pixels: *void, pitch: s32) -> bool                                                                                                                                                     #foreign SDL3 "SDL_UpdateTexture";
update_yuv_texture                   :: (texture: *Texture, rect: *Rect, y_plane: *u8, y_pitch: s32, u_plane: *u8, u_pitch: s32, v_plane: *u8, v_pitch: s32) -> bool                                                                                            #foreign SDL3 "SDL_UpdateYUVTexture";
update_nv_texture                    :: (texture: *Texture, rect: *Rect, y_plane: *u8, y_pitch: s32, uv_plane: *u8, uv_pitch: s32) -> bool                                                                                                                      #foreign SDL3 "SDL_UpdateNVTexture";
lock_texture                         :: (texture: *Texture, rect: *Rect, pixels: **void, pitch: *s32) -> bool                                                                                                                                                   #foreign SDL3 "SDL_LockTexture";
lock_texture_to_surface              :: (texture: *Texture, rect: *Rect, surface: **Surface) -> bool                                                                                                                                                            #foreign SDL3 "SDL_LockTextureToSurface";
unlock_texture                       :: (texture: *Texture)                                                                                                                                                                                                     #foreign SDL3 "SDL_UnlockTexture";
destroy_texture                      :: (texture: *Texture)                                                                                                                                                                                                     #foreign SDL3 "SDL_DestroyTexture";
set_render_target                    :: (renderer: *Renderer, texture: *Texture) -> bool                                                                                                                                                                        #foreign SDL3 "SDL_SetRenderTarget";
get_render_target                    :: (renderer: *Renderer) -> *Texture                                                                                                                                                                                       #foreign SDL3 "SDL_GetRenderTarget";
set_render_logical_presentation      :: (renderer: *Renderer, w: s32, h: s32, mode: Renderer_Logical_Presentation) -> bool                                                                                                                                      #foreign SDL3 "SDL_SetRenderLogicalPresentation";
get_render_logical_presentation      :: (renderer: *Renderer, w: *s32, h: *s32, mode: *Renderer_Logical_Presentation) -> bool                                                                                                                                   #foreign SDL3 "SDL_GetRenderLogicalPresentation";
get_render_logical_presentation_rect :: (renderer: *Renderer, rect: *F_Rect) -> bool                                                                                                                                                                            #foreign SDL3 "SDL_GetRenderLogicalPresentationRect";
render_coordinates_from_window       :: (renderer: *Renderer, window_x: float32, window_y: float32, x: *float32, y: *float32) -> bool                                                                                                                           #foreign SDL3 "SDL_RenderCoordinatesFromWindow";
render_coordinates_to_window         :: (renderer: *Renderer, x: float32, y: float32, window_x: *float32, window_y: *float32) -> bool                                                                                                                           #foreign SDL3 "SDL_RenderCoordinatesToWindow";
convert_event_to_render_coordinates  :: (renderer: *Renderer, event: *Event) -> bool                                                                                                                                                                            #foreign SDL3 "SDL_ConvertEventToRenderCoordinates";
set_render_viewport                  :: (renderer: *Renderer, rect: *Rect) -> bool                                                                                                                                                                              #foreign SDL3 "SDL_SetRenderViewport";
get_render_viewport                  :: (renderer: *Renderer, rect: *Rect) -> bool                                                                                                                                                                              #foreign SDL3 "SDL_GetRenderViewport";
render_viewport_set                  :: (renderer: *Renderer) -> bool                                                                                                                                                                                           #foreign SDL3 "SDL_RenderViewportSet";
get_render_safe_area                 :: (renderer: *Renderer, rect: *Rect) -> bool                                                                                                                                                                              #foreign SDL3 "SDL_GetRenderSafeArea";
set_render_clip_rect                 :: (renderer: *Renderer, rect: *Rect) -> bool                                                                                                                                                                              #foreign SDL3 "SDL_SetRenderClipRect";
get_render_clip_rect                 :: (renderer: *Renderer, rect: *Rect) -> bool                                                                                                                                                                              #foreign SDL3 "SDL_GetRenderClipRect";
render_clip_enabled                  :: (renderer: *Renderer) -> bool                                                                                                                                                                                           #foreign SDL3 "SDL_RenderClipEnabled";
set_render_scale                     :: (renderer: *Renderer, scale_x: float32, scale_y: float32) -> bool                                                                                                                                                       #foreign SDL3 "SDL_SetRenderScale";
get_render_scale                     :: (renderer: *Renderer, scale_x: *float32, scale_y: *float32) -> bool                                                                                                                                                     #foreign SDL3 "SDL_GetRenderScale";
set_render_draw_color                :: (renderer: *Renderer, r: u8, g: u8, b: u8, a: u8) -> bool                                                                                                                                                               #foreign SDL3 "SDL_SetRenderDrawColor";
set_render_draw_color_float          :: (renderer: *Renderer, r: float32, g: float32, b: float32, a: float32) -> bool                                                                                                                                           #foreign SDL3 "SDL_SetRenderDrawColorFloat";
get_render_draw_color                :: (renderer: *Renderer, r: *u8, g: *u8, b: *u8, a: *u8) -> bool                                                                                                                                                           #foreign SDL3 "SDL_GetRenderDrawColor";
get_render_draw_color_float          :: (renderer: *Renderer, r: *float32, g: *float32, b: *float32, a: *float32) -> bool                                                                                                                                       #foreign SDL3 "SDL_GetRenderDrawColorFloat";
set_render_color_scale               :: (renderer: *Renderer, scale: float32) -> bool                                                                                                                                                                           #foreign SDL3 "SDL_SetRenderColorScale";
get_render_color_scale               :: (renderer: *Renderer, scale: *float32) -> bool                                                                                                                                                                          #foreign SDL3 "SDL_GetRenderColorScale";
set_render_draw_blend_mode           :: (renderer: *Renderer, blend_mode: Blend_Mode) -> bool                                                                                                                                                                   #foreign SDL3 "SDL_SetRenderDrawBlendMode";
get_render_draw_blend_mode           :: (renderer: *Renderer, blend_mode: *Blend_Mode) -> bool                                                                                                                                                                  #foreign SDL3 "SDL_GetRenderDrawBlendMode";
render_clear                         :: (renderer: *Renderer) -> bool                                                                                                                                                                                           #foreign SDL3 "SDL_RenderClear";
render_point                         :: (renderer: *Renderer, x: float32, y: float32) -> bool                                                                                                                                                                   #foreign SDL3 "SDL_RenderPoint";
render_points                        :: (renderer: *Renderer, points: *F_Point, count: s32) -> bool                                                                                                                                                             #foreign SDL3 "SDL_RenderPoints";
render_line                          :: (renderer: *Renderer, x1: float32, y1: float32, x2: float32, y2: float32) -> bool                                                                                                                                       #foreign SDL3 "SDL_RenderLine";
render_lines                         :: (renderer: *Renderer, points: *F_Point, count: s32) -> bool                                                                                                                                                             #foreign SDL3 "SDL_RenderLines";
render_rect                          :: (renderer: *Renderer, rect: *F_Rect) -> bool                                                                                                                                                                            #foreign SDL3 "SDL_RenderRect";
render_rects                         :: (renderer: *Renderer, rects: *F_Rect, count: s32) -> bool                                                                                                                                                               #foreign SDL3 "SDL_RenderRects";
render_fill_rect                     :: (renderer: *Renderer, rect: *F_Rect) -> bool                                                                                                                                                                            #foreign SDL3 "SDL_RenderFillRect";
render_fill_rects                    :: (renderer: *Renderer, rects: *F_Rect, count: s32) -> bool                                                                                                                                                               #foreign SDL3 "SDL_RenderFillRects";
render_texture                       :: (renderer: *Renderer, texture: *Texture, src_rect: *F_Rect, dst_rect: *F_Rect) -> bool                                                                                                                                  #foreign SDL3 "SDL_RenderTexture";
render_texture_rotated               :: (renderer: *Renderer, texture: *Texture, src_rect: *F_Rect, dst_rect: *F_Rect, angle: float64, center: *F_Point, flip: Flip_Mode) -> bool                                                                               #foreign SDL3 "SDL_RenderTextureRotated";
render_texture_tiled                 :: (renderer: *Renderer, texture: *Texture, src_rect: *F_Rect, scale: float32, dst_rect: *F_Rect) -> bool                                                                                                                  #foreign SDL3 "SDL_RenderTextureTiled";
render_texture9_grid                 :: (renderer: *Renderer, texture: *Texture, src_rect: *F_Rect, left_width: float32, right_width: float32, top_height: float32, bottom_height: float32, scale: float32, dst_rect: *F_Rect) -> bool                          #foreign SDL3 "SDL_RenderTexture9Grid";
render_geometry                      :: (renderer: *Renderer, texture: *Texture, vertices: *Vertex, num_vertices: s32, indices: *s32, num_indices: s32) -> bool                                                                                                  #foreign SDL3 "SDL_RenderGeometry";
render_geometry_raw                  :: (renderer: *Renderer, texture: *Texture, xy: *float32, xy_stride: s32, color: F_Color, color_stride: s32, uv: *float32, uv_stride: s32, num_vertices: s32, indices: *void, num_indices: s32, size_indices: s32) -> bool #foreign SDL3 "SDL_RenderGeometryRaw";
render_read_pixels                   :: (renderer: *Renderer, rect: *Rect) -> *Surface                                                                                                                                                                          #foreign SDL3 "SDL_RenderReadPixels";
render_present                       :: (renderer: *Renderer) -> bool                                                                                                                                                                                           #foreign SDL3 "SDL_RenderPresent";
destroy_renderer                     :: (renderer: *Renderer)                                                                                                                                                                                                   #foreign SDL3 "SDL_DestroyRenderer";
flush_renderer                       :: (renderer: *Renderer) -> bool                                                                                                                                                                                           #foreign SDL3 "SDL_FlushRenderer";
get_render_metal_layer               :: (renderer: *Renderer) -> *void                                                                                                                                                                                          #foreign SDL3 "SDL_GetRenderMetalLayer";
get_render_metal_command_encoder     :: (renderer: *Renderer) -> *void                                                                                                                                                                                          #foreign SDL3 "SDL_GetRenderMetalCommandEncoder";
add_vulkan_render_semaphores         :: (renderer: *Renderer, wait_stage_mask: u32, wait_semaphore: s64, signal_semaphore: s64) -> bool                                                                                                                         #foreign SDL3 "SDL_AddVulkanRenderSemaphores";
set_render_v_sync                    :: (renderer: *Renderer, vsync: s32) -> bool                                                                                                                                                                               #foreign SDL3 "SDL_SetRenderVSync";
get_render_v_sync                    :: (renderer: *Renderer, vsync: *s32) -> bool                                                                                                                                                                              #foreign SDL3 "SDL_GetRenderVSync";
render_debug_text                    :: (renderer: *Renderer, x: float32, y: float32, str: *u8) -> bool                                                                                                                                                         #foreign SDL3 "SDL_RenderDebugText";


RENDERER_VSYNC_DISABLED ::  0;
RENDERER_VSYNC_ADAPTIVE :: -1;

DEBUG_TEXT_FONT_CHARACTER_SIZE :: 8;


PROP_RENDERER_CREATE_NAME_STRING                                :: "SDL.renderer.create.name";
PROP_RENDERER_CREATE_WINDOW_POINTER                             :: "SDL.renderer.create.window";
PROP_RENDERER_CREATE_SURFACE_POINTER                            :: "SDL.renderer.create.surface";
PROP_RENDERER_CREATE_OUTPUT_COLORSPACE_NUMBER                   :: "SDL.renderer.create.output_colorspace";
PROP_RENDERER_CREATE_PRESENT_VSYNC_NUMBER                       :: "SDL.renderer.create.present_vsync";
PROP_RENDERER_CREATE_VULKAN_INSTANCE_POINTER                    :: "SDL.renderer.create.vulkan.instance";
PROP_RENDERER_CREATE_VULKAN_SURFACE_NUMBER                      :: "SDL.renderer.create.vulkan.surface";
PROP_RENDERER_CREATE_VULKAN_PHYSICAL_DEVICE_POINTER             :: "SDL.renderer.create.vulkan.physical_device";
PROP_RENDERER_CREATE_VULKAN_DEVICE_POINTER                      :: "SDL.renderer.create.vulkan.device";
PROP_RENDERER_CREATE_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER  :: "SDL.renderer.create.vulkan.graphics_queue_family_index";
PROP_RENDERER_CREATE_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER   :: "SDL.renderer.create.vulkan.present_queue_family_index";

PROP_RENDERER_NAME_STRING                               :: "SDL.renderer.name";
PROP_RENDERER_WINDOW_POINTER                            :: "SDL.renderer.window";
PROP_RENDERER_SURFACE_POINTER                           :: "SDL.renderer.surface";
PROP_RENDERER_VSYNC_NUMBER                              :: "SDL.renderer.vsync";
PROP_RENDERER_MAX_TEXTURE_SIZE_NUMBER                   :: "SDL.renderer.max_texture_size";
PROP_RENDERER_TEXTURE_FORMATS_POINTER                   :: "SDL.renderer.texture_formats";
PROP_RENDERER_OUTPUT_COLORSPACE_NUMBER                  :: "SDL.renderer.output_colorspace";
PROP_RENDERER_HDR_ENABLED_BOOLEAN                       :: "SDL.renderer.HDR_enabled";
PROP_RENDERER_SDR_WHITE_POINT_FLOAT                     :: "SDL.renderer.SDR_white_point";
PROP_RENDERER_HDR_HEADROOM_FLOAT                        :: "SDL.renderer.HDR_headroom";
PROP_RENDERER_D3D9_DEVICE_POINTER                       :: "SDL.renderer.d3d9.device";
PROP_RENDERER_D3D11_DEVICE_POINTER                      :: "SDL.renderer.d3d11.device";
PROP_RENDERER_D3D11_SWAPCHAIN_POINTER                   :: "SDL.renderer.d3d11.swap_chain";
PROP_RENDERER_D3D12_DEVICE_POINTER                      :: "SDL.renderer.d3d12.device";
PROP_RENDERER_D3D12_SWAPCHAIN_POINTER                   :: "SDL.renderer.d3d12.swap_chain";
PROP_RENDERER_D3D12_COMMAND_QUEUE_POINTER               :: "SDL.renderer.d3d12.command_queue";
PROP_RENDERER_VULKAN_INSTANCE_POINTER                   :: "SDL.renderer.vulkan.instance";
PROP_RENDERER_VULKAN_SURFACE_NUMBER                     :: "SDL.renderer.vulkan.surface";
PROP_RENDERER_VULKAN_PHYSICAL_DEVICE_POINTER            :: "SDL.renderer.vulkan.physical_device";
PROP_RENDERER_VULKAN_DEVICE_POINTER                     :: "SDL.renderer.vulkan.device";
PROP_RENDERER_VULKAN_GRAPHICS_QUEUE_FAMILY_INDEX_NUMBER :: "SDL.renderer.vulkan.graphics_queue_family_index";
PROP_RENDERER_VULKAN_PRESENT_QUEUE_FAMILY_INDEX_NUMBER  :: "SDL.renderer.vulkan.present_queue_family_index";
PROP_RENDERER_VULKAN_SWAPCHAIN_IMAGE_COUNT_NUMBER       :: "SDL.renderer.vulkan.swapchain_image_count";

PROP_TEXTURE_CREATE_COLORSPACE_NUMBER           :: "SDL.texture.create.colorspace";
PROP_TEXTURE_CREATE_FORMAT_NUMBER               :: "SDL.texture.create.format";
PROP_TEXTURE_CREATE_ACCESS_NUMBER               :: "SDL.texture.create.access";
PROP_TEXTURE_CREATE_WIDTH_NUMBER                :: "SDL.texture.create.width";
PROP_TEXTURE_CREATE_HEIGHT_NUMBER               :: "SDL.texture.create.height";
PROP_TEXTURE_CREATE_SDR_WHITE_POINT_FLOAT       :: "SDL.texture.create.SDR_white_point";
PROP_TEXTURE_CREATE_HDR_HEADROOM_FLOAT          :: "SDL.texture.create.HDR_headroom";
PROP_TEXTURE_CREATE_D3D11_TEXTURE_POINTER       :: "SDL.texture.create.d3d11.texture";
PROP_TEXTURE_CREATE_D3D11_TEXTURE_U_POINTER     :: "SDL.texture.create.d3d11.texture_u";
PROP_TEXTURE_CREATE_D3D11_TEXTURE_V_POINTER     :: "SDL.texture.create.d3d11.texture_v";
PROP_TEXTURE_CREATE_D3D12_TEXTURE_POINTER       :: "SDL.texture.create.d3d12.texture";
PROP_TEXTURE_CREATE_D3D12_TEXTURE_U_POINTER     :: "SDL.texture.create.d3d12.texture_u";
PROP_TEXTURE_CREATE_D3D12_TEXTURE_V_POINTER     :: "SDL.texture.create.d3d12.texture_v";
PROP_TEXTURE_CREATE_METAL_PIXELBUFFER_POINTER   :: "SDL.texture.create.metal.pixelbuffer";
PROP_TEXTURE_CREATE_OPENGL_TEXTURE_NUMBER       :: "SDL.texture.create.opengl.texture";
PROP_TEXTURE_CREATE_OPENGL_TEXTURE_UV_NUMBER    :: "SDL.texture.create.opengl.texture_uv";
PROP_TEXTURE_CREATE_OPENGL_TEXTURE_U_NUMBER     :: "SDL.texture.create.opengl.texture_u";
PROP_TEXTURE_CREATE_OPENGL_TEXTURE_V_NUMBER     :: "SDL.texture.create.opengl.texture_v";
PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_NUMBER    :: "SDL.texture.create.opengles2.texture";
PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_UV_NUMBER :: "SDL.texture.create.opengles2.texture_uv";
PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_U_NUMBER  :: "SDL.texture.create.opengles2.texture_u";
PROP_TEXTURE_CREATE_OPENGLES2_TEXTURE_V_NUMBER  :: "SDL.texture.create.opengles2.texture_v";
PROP_TEXTURE_CREATE_VULKAN_TEXTURE_NUMBER       :: "SDL.texture.create.vulkan.texture";

PROP_TEXTURE_COLORSPACE_NUMBER                  :: "SDL.texture.colorspace";
PROP_TEXTURE_FORMAT_NUMBER                      :: "SDL.texture.format";
PROP_TEXTURE_ACCESS_NUMBER                      :: "SDL.texture.access";
PROP_TEXTURE_WIDTH_NUMBER                       :: "SDL.texture.width";
PROP_TEXTURE_HEIGHT_NUMBER                      :: "SDL.texture.height";
PROP_TEXTURE_SDR_WHITE_POINT_FLOAT              :: "SDL.texture.SDR_white_point";
PROP_TEXTURE_HDR_HEADROOM_FLOAT                 :: "SDL.texture.HDR_headroom";
PROP_TEXTURE_D3D11_TEXTURE_POINTER              :: "SDL.texture.d3d11.texture";
PROP_TEXTURE_D3D11_TEXTURE_U_POINTER            :: "SDL.texture.d3d11.texture_u";
PROP_TEXTURE_D3D11_TEXTURE_V_POINTER            :: "SDL.texture.d3d11.texture_v";
PROP_TEXTURE_D3D12_TEXTURE_POINTER              :: "SDL.texture.d3d12.texture";
PROP_TEXTURE_D3D12_TEXTURE_U_POINTER            :: "SDL.texture.d3d12.texture_u";
PROP_TEXTURE_D3D12_TEXTURE_V_POINTER            :: "SDL.texture.d3d12.texture_v";
PROP_TEXTURE_OPENGL_TEXTURE_NUMBER              :: "SDL.texture.opengl.texture";
PROP_TEXTURE_OPENGL_TEXTURE_UV_NUMBER           :: "SDL.texture.opengl.texture_uv";
PROP_TEXTURE_OPENGL_TEXTURE_U_NUMBER            :: "SDL.texture.opengl.texture_u";
PROP_TEXTURE_OPENGL_TEXTURE_V_NUMBER            :: "SDL.texture.opengl.texture_v";
PROP_TEXTURE_OPENGL_TEXTURE_TARGET_NUMBER       :: "SDL.texture.opengl.target";
PROP_TEXTURE_OPENGL_TEX_W_FLOAT                 :: "SDL.texture.opengl.tex_w";
PROP_TEXTURE_OPENGL_TEX_H_FLOAT                 :: "SDL.texture.opengl.tex_h";
PROP_TEXTURE_OPENGLES2_TEXTURE_NUMBER           :: "SDL.texture.opengles2.texture";
PROP_TEXTURE_OPENGLES2_TEXTURE_UV_NUMBER        :: "SDL.texture.opengles2.texture_uv";
PROP_TEXTURE_OPENGLES2_TEXTURE_U_NUMBER         :: "SDL.texture.opengles2.texture_u";
PROP_TEXTURE_OPENGLES2_TEXTURE_V_NUMBER         :: "SDL.texture.opengles2.texture_v";
PROP_TEXTURE_OPENGLES2_TEXTURE_TARGET_NUMBER    :: "SDL.texture.opengles2.target";
PROP_TEXTURE_VULKAN_TEXTURE_NUMBER              :: "SDL.texture.vulkan.texture";
