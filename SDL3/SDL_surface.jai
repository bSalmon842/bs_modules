Surface_Flags :: enum_flags u32
{
    PREALLOCATED :: 0x00000001;
    LOCK_NEEDED  :: 0x00000002;
    LOCKED       :: 0x00000004;
    SIMD_ALIGNED :: 0x00000008;
}

// MUSTLOCK :: (s: *Surface) -> bool {return (s.flags & SURFACE_LOCK_NEEDED) == SURFACE_LOCK_NEEDED;}

Scale_Mode :: enum u32
{
    NEAREST;
    LINEAR;
}

Flip_Mode :: enum u32
{
    NONE;
    HORIZONTAL;
    VERTICAL;
}

Surface :: struct
{
    flags:    Surface_Flags;
    format:   Pixel_Format;
    w:        s32;
    h:        s32;
    pitch:    s32;
    pixels:   *void;

    refcount: s32;
    reserved: *void;
}

// Surface :: void;


create_surface                  :: (width: s32, height: s32, format: Pixel_Format) -> *Surface                                                                                                                              #foreign SDL3 "SDL_CreateSurface";
create_surface_from             :: (width: s32, height: s32, format: Pixel_Format, pixels: *void, pitch: s32) -> *Surface                                                                                                   #foreign SDL3 "SDL_CreateSurfaceFrom";
destroy_surface                 :: (surface: *Surface)                                                                                                                                                                      #foreign SDL3 "SDL_DestroySurface";
get_surface_properties          :: (surface: *Surface) -> Properties_ID                                                                                                                                                     #foreign SDL3 "SDL_GetSurfaceProperties";
set_surface_colorspace          :: (surface: *Surface, colorspace: Colorspace) -> bool                                                                                                                                      #foreign SDL3 "SDL_SetSurfaceColorspace";
get_surface_colorspace          :: (surface: *Surface) -> Colorspace                                                                                                                                                        #foreign SDL3 "SDL_GetSurfaceColorspace";
create_surface_palette          :: (surface: *Surface) -> *Palette                                                                                                                                                          #foreign SDL3 "SDL_CreateSurfacePalette";
set_surface_palette             :: (surface: *Surface, palette: *Palette) -> bool                                                                                                                                           #foreign SDL3 "SDL_SetSurfacePalette";
get_surface_palette             :: (surface: *Surface) -> *Palette                                                                                                                                                          #foreign SDL3 "SDL_GetSurfacePalette";
add_surface_alternate_image     :: (surface: *Surface, image: *Surface) -> bool                                                                                                                                             #foreign SDL3 "SDL_AddSurfaceAlternateImage";
surface_has_alternate_images    :: (surface: *Surface) -> bool                                                                                                                                                              #foreign SDL3 "SDL_SurfaceHasAlternateImages";
get_surface_images              :: (surface: *Surface, count: *s32) -> **Surface                                                                                                                                            #foreign SDL3 "SDL_GetSurfaceImages";
remove_surface_alternate_images :: (surface: *Surface)                                                                                                                                                                      #foreign SDL3 "SDL_RemoveSurfaceAlternateImages";
lock_surface                    :: (surface: *Surface) -> bool                                                                                                                                                              #foreign SDL3 "SDL_LockSurface";
unlock_surface                  :: (surface: *Surface)                                                                                                                                                                      #foreign SDL3 "SDL_UnlockSurface";
load_bmp_io                     :: (src: *IO_Stream, close_io: bool) -> *Surface                                                                                                                                            #foreign SDL3 "SDL_LoadBMP_IO";
load_bmp                        :: (file: *u8) -> *Surface                                                                                                                                                                  #foreign SDL3 "SDL_LoadBMP";
save_bmp_io                     :: (surface: *Surface, dst: *IO_Stream, close_io: bool) -> bool                                                                                                                             #foreign SDL3 "SDL_SaveBMP_IO";
save_bmp                        :: (surface: *Surface, file: *u8) -> bool                                                                                                                                                   #foreign SDL3 "SDL_SaveBMP";
set_surface_rle                 :: (surface: *Surface, enabled: bool) -> bool                                                                                                                                               #foreign SDL3 "SDL_SetSurfaceRLE";
surface_has_rle                 :: (surface: *Surface) -> bool                                                                                                                                                              #foreign SDL3 "SDL_SurfaceHasRLE";
set_surface_color_key           :: (surface: *Surface, enabled: bool, key: u32) -> bool                                                                                                                                     #foreign SDL3 "SDL_SetSurfaceColorKey";
surface_has_color_key           :: (surface: *Surface) -> bool                                                                                                                                                              #foreign SDL3 "SDL_SurfaceHasColorKey";
get_surface_color_key           :: (surface: *Surface, key: *u32) -> bool                                                                                                                                                   #foreign SDL3 "SDL_GetSurfaceColorKey";
set_surface_color_mod           :: (surface: *Surface, r: u8, g: u8, b: u8) -> bool                                                                                                                                         #foreign SDL3 "SDL_SetSurfaceColorMod";
get_surface_color_mod           :: (surface: *Surface, r: *u8, g: *u8, b: *u8) -> bool                                                                                                                                      #foreign SDL3 "SDL_GetSurfaceColorMod";
set_surface_alpha_mod           :: (surface: *Surface, alpha: u8) -> bool                                                                                                                                                   #foreign SDL3 "SDL_SetSurfaceAlphaMod";
get_surface_alpha_mod           :: (surface: *Surface, alpha: *u8) -> bool                                                                                                                                                  #foreign SDL3 "SDL_GetSurfaceAlphaMod";
set_surface_blend_mode          :: (surface: *Surface, blend_mode: Blend_Mode) -> bool                                                                                                                                      #foreign SDL3 "SDL_SetSurfaceBlendMode";
get_surface_blend_mode          :: (surface: *Surface, blend_mode: *Blend_Mode) -> bool                                                                                                                                     #foreign SDL3 "SDL_GetSurfaceBlendMode";
set_surface_clip_rect           :: (surface: *Surface, rect: *Rect) -> bool                                                                                                                                                 #foreign SDL3 "SDL_SetSurfaceClipRect";
get_surface_clip_rect           :: (surface: *Surface, rect: *Rect) -> bool                                                                                                                                                 #foreign SDL3 "SDL_GetSurfaceClipRect";
flip_surface                    :: (surface: *Surface, flip: Flip_Mode) -> bool                                                                                                                                             #foreign SDL3 "SDL_FlipSurface";
duplicate_surface               :: (surface: *Surface) -> *Surface                                                                                                                                                          #foreign SDL3 "SDL_DuplicateSurface";
scale_surface                   :: (surface: *Surface, width: s32, height: s32, scale_mode: Scale_Mode) -> *Surface                                                                                                         #foreign SDL3 "SDL_ScaleSurface";
convert_surface                 :: (surface: *Surface, format: Pixel_Format) -> *Surface                                                                                                                                    #foreign SDL3 "SDL_ConvertSurface";
convert_surface_and_colorspace  :: (surface: *Surface, format: Pixel_Format, palette: *Palette, colorspace: Colorspace, props: Properties_ID) -> *Surface                                                                   #foreign SDL3 "SDL_ConvertSurfaceAndColorspace";
convert_pixels                  :: (width: s32, height: s32, src_format: Pixel_Format, src: *void, src_pitch: s32, dst_format: Pixel_Format, dst: *void, dst_pitch: s32) -> bool                                            #foreign SDL3 "SDL_ConvertPixels";
premultiply_alpha               :: (width: s32, height: s32, src_format: Pixel_Format, src: *void, src_pitch: s32, dst_format: Pixel_Format, dst: *void, dst_pitch: s32, linear: bool) -> bool                              #foreign SDL3 "SDL_PremultiplyAlpha";
premultiply_surface_alpha       :: (surface: *Surface, linear: bool) -> bool                                                                                                                                                #foreign SDL3 "SDL_PremultiplySurfaceAlpha";
clear_surface                   :: (surface: *Surface, r: float32, g: float32, b: float32, a: float32) -> bool                                                                                                              #foreign SDL3 "SDL_ClearSurface";
fill_surface_rect               :: (dst: *Surface, rect: *Rect, color: u32) -> bool                                                                                                                                         #foreign SDL3 "SDL_FillSurfaceRect";
fill_surface_rects              :: (dst: *Surface, rects: *Rect, color: u32) -> bool                                                                                                                                        #foreign SDL3 "SDL_FillSurfaceRects";
blit_surface                    :: (src: *Surface, src_rect: *Rect, dst: *Surface, dst_rect: *Rect) -> bool                                                                                                                 #foreign SDL3 "SDL_BlitSurface";
blit_surface_unchecked          :: (src: *Surface, src_rect: *Rect, dst: *Surface, dst_rect: *Rect) -> bool                                                                                                                 #foreign SDL3 "SDL_BlitSurfaceUnchecked";
blit_surface_scaled             :: (src: *Surface, src_rect: *Rect, dst: *Surface, dst_rect: *Rect, scale_mode: Scale_Mode) -> bool                                                                                         #foreign SDL3 "SDL_BlitSurfaceScaled";
blit_surface_unchecked_scaled   :: (src: *Surface, src_rect: *Rect, dst: *Surface, dst_rect: *Rect, scale_mode: Scale_Mode) -> bool                                                                                         #foreign SDL3 "SDL_BlitSurfaceUncheckedScaled";
blit_surface_tiled              :: (src: *Surface, src_rect: *Rect, dst: *Surface, dst_rect: *Rect) -> bool                                                                                                                 #foreign SDL3 "SDL_BlitSurfaceTiled";
blit_surface_tiled_with_scale   :: (src: *Surface, src_rect: *Rect, scale: float32, scale_mode: Scale_Mode, dst: *Surface, dst_rect: *Rect) -> bool                                                                         #foreign SDL3 "SDL_BlitSurfaceTiledWithScale";
blit_surface9_grid              :: (src: *Surface, src_rect: *Rect, left_width: s32, right_width: s32, top_height: s32, bottom_height: s32, scale: float32, scale_mode: Scale_Mode, dst: *Surface, dst_rect: *Rect) -> bool #foreign SDL3 "SDL_BlitSurface9Grid";
map_surface_rgb                 :: (surface: *Surface, r: u8, g: u8, b: u8) -> u32                                                                                                                                          #foreign SDL3 "SDL_MapSurfaceRGB";
map_surface_rgba                :: (surface: *Surface, r: u8, g: u8, b: u8, a: u8) -> u32                                                                                                                                   #foreign SDL3 "SDL_MapSurfaceRGBA";
read_surface_pixel              :: (surface: *Surface, x: s32, y: s32, r: *u8, g: *u8, b: *u8, a: *u8) -> bool                                                                                                              #foreign SDL3 "SDL_ReadSurfacePixel";
read_surface_pixel_float        :: (surface: *Surface, x: s32, y: s32, r: *float32, g: *float32, b: *float32, a: *float32) -> bool                                                                                          #foreign SDL3 "SDL_ReadSurfacePixelFloat";
write_surface_pixel             :: (surface: *Surface, x: s32, y: s32, r: u8, g: u8, b: u8, a: u8) -> bool                                                                                                                  #foreign SDL3 "SDL_WriteSurfacePixel";
write_surface_pixel_float       :: (surface: *Surface, x: s32, y: s32, r: float32, g: float32, b: float32, a: float32) -> bool                                                                                              #foreign SDL3 "SDL_WriteSurfacePixelFloat";

convert_pixels_and_colorspace   :: (width: s32, height: s32, src_format: Pixel_Format, src_colorspace: Colorspace, src_properties: Properties_ID, src: *void, src_pitch: s32, dst_format: Pixel_Format, dst_colorspace: Colorspace, dst_properties: Properties_ID, dst: *void, dst_pitch: s32) -> bool #foreign SDL3 "SDL_ConvertPixelsAndColorspace";



PROP_SURFACE_SDR_WHITE_POINT_FLOAT              :: "SDL.surface.SDR_white_point";
PROP_SURFACE_HDR_HEADROOM_FLOAT                 :: "SDL.surface.HDR_headroom";
PROP_SURFACE_TONEMAP_OPERATOR_STRING            :: "SDL.surface.tonemap";
