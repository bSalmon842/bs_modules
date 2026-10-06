//
// A "backend" using jai module code.
//

USE_RAYLIB :: true;

#if !USE_RAYLIB {
    ImplJai_Init :: (window: Window_Type) -> bool {
	io := GetIO();
	assert(io.BackendPlatformUserData == null, "Already initialized a platform backend!");

	// Setup backend capabilities flags
	io.BackendPlatformUserData = cast(*void)*bd;
	io.BackendPlatformName = "imgui_impl_jai";

	bd.window = window;
	bd.time = seconds_since_init();

	// Set platform dependent data in viewport
	GetMainViewport().PlatformHandleRaw = xx window;

	return true;
    }

    ImplJai_NewFrame :: () {
	io := GetIO();
	assert(*bd == io.BackendPlatformUserData, "Did you call ImGui_ImplJai_Init()?");
	
	right_handed := false;
	
	// Setup display size (every frame to accommodate for window resizing)
	_, _, width, height := get_dimensions(bd.window, right_handed);
	io.DisplaySize = ImVec2.{cast(float) width, cast(float) height};

	// Update time step
	current_time := seconds_since_init();
	io.DeltaTime = cast(float)(current_time - bd.time);
	bd.time = current_time;
	
	// Provide mouse position. modules/Input only gives us delta so this isn't done with other input code.
	{
            x, y, success := get_mouse_pointer_position(bd.window, right_handed);
            if success {
		io.AddMousePosEvent(io, cast(float) x, cast(float) y);
            }
	}
    }
} else {
    //
// imgui_impl_raylib — Dear ImGui platform + renderer backend for raylib, written in Jai.
//
// Platform side:  mouse (position, buttons, wheel, cursor shapes), keyboard + unicode text input,
//                 gamepad navigation, clipboard, window focus, HighDPI.
// Renderer side:  draws ImDrawData through rlgl's internal batch (no GL calls or shaders of our own),
//                 supports user textures, ImDrawCmd.VtxOffset (large meshes), user draw callbacks and
//                 the 1.92+ dynamic font atlas (ImGuiBackendFlags_RendererHasTextures).
//
// Written against:
//     Dear ImGui 1.92.x (docking)  — github.com/overlord-systems/jai-imgui
//     raylib 6.x incl. rlgl        — github.com/ahmedqarmout2/raylib-jai
// If those live under other folder names in your modules directory, change the two #imports below.
//
// Usage:
//
//     #import "raylib";
//     ImGui :: #import "imgui";
//     #import "imgui_impl_raylib";
//
//     InitWindow(1280, 720, "app");
//     ImGui.CreateContext();
//     ImGui_ImplRaylib_Init();
//
//     while !WindowShouldClose() {
//         ImGui_ImplRaylib_NewFrame();
//         ImGui.NewFrame();
//         // ... ImGui calls ...
//         ImGui.Render();
//
//         BeginDrawing();
//         // ... raylib drawing ...
//         ImGui_ImplRaylib_RenderDrawData(ImGui.GetDrawData());   // outside BeginMode2D/3D/TextureMode
//         EndDrawing();
//     }
//
//     ImGui_ImplRaylib_Shutdown();     // before CloseWindow(): it frees GPU textures
//     ImGui.DestroyContext();
//     CloseWindow();
//
// Notes:
//   - Gate your game input with io.WantCaptureMouse / io.WantCaptureKeyboard.
//   - This backend drains raylib's char queue (GetCharPressed) every frame for text input.
//   - Multi-viewports (ConfigFlags.ViewportsEnable) are not supported; docking inside the main window is.
//   - User textures: ImGui_ImplRaylib_Image(texture) or ImGui.Image(ImGui_ImplRaylib_TextureRef(texture), size).
//     For a RenderTexture's .texture, flip it with uv0 = .{0, 1}, uv1 = .{1, 0}.
//

#scope_export

//
// Public API
//

ImplRaylib_Init :: () -> bool {
    io := GetIO();
    assert(io.BackendPlatformUserData == null, "A platform backend is already initialized for this ImGui context.");
    assert(io.BackendRendererUserData == null, "A renderer backend is already initialized for this ImGui context.");

    bd := New(Backend_Data);
    io.BackendPlatformUserData = bd;
    io.BackendRendererUserData = bd;
    io.BackendPlatformName = "imgui_impl_raylib";
    io.BackendRendererName = "imgui_impl_raylib";

    io.BackendFlags_ |= .HasMouseCursors      // We honor GetMouseCursor() via SetMouseCursor().
                      | .HasSetMousePos       // We honor io.WantSetMousePos.
                      | .RendererHasVtxOffset // We read vertices by index ourselves, so any VtxOffset is fine.
                      | .RendererHasTextures; // We service ImDrawData.Textures (dynamic font atlas).

    platform_io := GetPlatformIO();
    platform_io.Platform_GetClipboardTextFn = clipboard_get;
    platform_io.Platform_SetClipboardTextFn = clipboard_set;
    platform_io.Platform_ClipboardUserData  = null;

    return true;
}

ImplRaylib_Shutdown :: () {
    bd := get_backend_data();
    assert(bd != null, "No raylib backend to shut down (never initialized, or already shut down?).");

    io          := GetIO();
    platform_io := GetPlatformIO();

    // Free the GPU textures we created. RefCount > 1 means another context still shares the atlas.
    textures := *platform_io.Textures;
    for i: 0..textures.Size-1 {
        tex := textures.Data[i];
        if tex.RefCount == 1  destroy_texture(tex);
    }

    if bd.cursor_hidden_by_us  ShowCursor();

    platform_io.Platform_GetClipboardTextFn = null;
    platform_io.Platform_SetClipboardTextFn = null;

    io.BackendPlatformName     = null;
    io.BackendRendererName     = null;
    io.BackendPlatformUserData = null;
    io.BackendRendererUserData = null;
    io.BackendFlags_ &= ~(ImGui.BackendFlags.HasMouseCursors
                        | ImGui.BackendFlags.HasSetMousePos
                        | ImGui.BackendFlags.HasGamepad
                        | ImGui.BackendFlags.RendererHasVtxOffset
                        | ImGui.BackendFlags.RendererHasTextures);

    array_free(bd.upload_buffer);
    free(bd);
}

// Call once per frame, before ImGui.NewFrame().
ImplRaylib_NewFrame :: () {
    bd := get_backend_data();
    assert(bd != null, "Call ImGui_ImplRaylib_Init() first.");
    io := GetIO();

    // DisplaySize is in logical units (the same space GetMousePosition() reports in).
    // With FLAG_WINDOW_HIGHDPI, raylib 6 renders to a larger framebuffer: GetRenderWidth() is the
    // framebuffer size, GetScreenWidth() the logical size. Their ratio is what scissor rects need.
    screen_w := rl.GetScreenWidth();
    screen_h := rl.GetScreenHeight();
    io.DisplaySize = .{cast(float) screen_w, cast(float) screen_h};
    if screen_w > 0 && screen_h > 0 {
        io.DisplayFramebufferScale = .{
            cast(float) rl.GetRenderWidth()  / cast(float) screen_w,
            cast(float) rl.GetRenderHeight() / cast(float) screen_h
        };
    }

    dt := rl.GetFrameTime();
    io.DeltaTime = ifx dt > 0 then dt else 1.0 / 60.0;   // ImGui asserts on a zero delta (first frame).

    focused := rl.IsWindowFocused();
    if focused != bd.window_focused {
        io.AddFocusEvent(io, focused);
        bd.window_focused = focused;
    }

    update_mouse(io, bd);
    update_keyboard(io, bd);
    update_mouse_cursor(io, bd);
}

// Call between BeginDrawing() and EndDrawing(), after your own raylib drawing,
// and outside BeginMode2D/BeginMode3D/BeginTextureMode/BeginScissorMode.
ImplRaylib_RenderDrawData :: (draw_data: *ImDrawData) {
    if draw_data == null  return;

    fb_width  := cast(s32) (draw_data.DisplaySize.x * draw_data.FramebufferScale.x);
    fb_height := cast(s32) (draw_data.DisplaySize.y * draw_data.FramebufferScale.y);
    if fb_width <= 0 || fb_height <= 0  return;   // Minimized.

    bd := get_backend_data();
    assert(bd != null, "Call ImGui_ImplRaylib_Init() first.");

    // Create / update / destroy the textures ImGui asked for. Most frames this is one texture with status OK.
    if draw_data.Textures != null {
        textures := draw_data.Textures;
        for i: 0..textures.Size-1 {
            tex := textures.Data[i];
            if tex.Status != .OK  update_texture(bd, tex);
        }
    }

    // Flush whatever raylib batched before us, so it isn't clipped by our scissor rects.
    rl.rlDrawRenderBatchActive();
    setup_render_state();

    clip_off   := draw_data.DisplayPos;        // (0,0) unless using multi-viewports.
    clip_scale := draw_data.FramebufferScale;  // Logical units -> framebuffer pixels.

    for n: 0..draw_data.CmdListsCount-1 {
        list := draw_data.CmdLists.Data[n];

        for c: 0..list.CmdBuffer.Size-1 {
            cmd := *list.CmdBuffer.Data[c];

            if cmd.UserCallback != null {
                rl.rlDrawRenderBatchActive();
                if !is_reset_render_state(cmd) {
                    cmd.UserCallback(list, cmd);
                    rl.rlDrawRenderBatchActive();   // Flush anything the callback drew with raylib.
                }
                setup_render_state();            // Callbacks may have changed culling/scissor state.
                continue;
            }

            // Clip rect in framebuffer pixels, clamped to the framebuffer.
            min_x := (cmd.ClipRect.x - clip_off.x) * clip_scale.x;
            min_y := (cmd.ClipRect.y - clip_off.y) * clip_scale.y;
            max_x := (cmd.ClipRect.z - clip_off.x) * clip_scale.x;
            max_y := (cmd.ClipRect.w - clip_off.y) * clip_scale.y;
            if min_x < 0  min_x = 0;
            if min_y < 0  min_y = 0;
            if max_x > cast(float) fb_width   max_x = cast(float) fb_width;
            if max_y > cast(float) fb_height  max_y = cast(float) fb_height;
            if max_x <= min_x || max_y <= min_y  continue;

            // GL scissor origin is bottom-left.
            rl.rlScissor(cast(s32) min_x,
                      cast(s32) (cast(float) fb_height - max_y),
                      cast(s32) (max_x - min_x),
                      cast(s32) (max_y - min_y));

            render_triangles(list, cmd, clip_off);

            // The scissor rect is GL state, not batch state: flush before the next command changes it.
            rl.rlDrawRenderBatchActive();
        }
    }

    rl.rlSetTexture(0);
    rl.rlDisableScissorTest();
    rl.rlEnableBackfaceCulling();   // raylib's default.
}

// Wrap a raylib texture so it can be passed to ImGui.Image(), ImageButton(), ImDrawList.AddImage(), etc.
ImplRaylib_TextureRef :: (texture: rl.Texture2D) -> ImTextureRef {
    ref: ImTextureRef;
    ref._TexID = cast(ImTextureID) texture.id;
    return ref;
}

// Convenience: draw a raylib texture as an ImGui image. Negative size components mean "texture size".
ImplRaylib_Image :: (texture: rl.Texture2D, size := Vector2.{-1, -1}, uv0 := Vector2.{0, 0}, uv1 := Vector2.{1, 1}) {
    s := size;
    if s.x < 0  s.x = cast(float) texture.width;
    if s.y < 0  s.y = cast(float) texture.height;
    Image(ImplRaylib_TextureRef(texture), s, uv0, uv1);
}


#scope_file

Backend_Data :: struct {
    window_focused      := true;    // ImGui starts out assuming the app is focused.
    mouse_down:          [5] bool;
    key_down:            [512] bool; // Indexed by raylib KeyboardKey value (max is 348).
    last_cursor         := cast(rl.MouseCursor) -1;
    cursor_hidden_by_us := false;
    upload_buffer:       [..] u8;    // Scratch space for texture sub-rect uploads.
}

get_backend_data :: () -> *Backend_Data {
    if GetCurrentContext() == null  return null;
    return cast(*Backend_Data) GetIO().BackendPlatformUserData;
}

//
// Clipboard (called from inside ImGui, hence #c_call; they only call raylib's C functions).
//

clipboard_get :: (ctx: *ImGuiContext) -> *u8 #c_call {
    return GetClipboardText();
}

clipboard_set :: (ctx: *ImGuiContext, text: *u8) -> void #c_call {
    SetClipboardText(text);
}

//
// Input
//

update_mouse :: (io: *IO, bd: *Backend_Data) {
    // Only happens with io.ConfigNavMoveSetMousePos enabled.
    if io.WantSetMousePos  rl.SetMousePosition(cast(s32) io.MousePos.x, cast(s32) io.MousePos.y);

    // ImGui maps 0..4 to Left, Right, Middle, X1, X2, which matches raylib's
    // LEFT, RIGHT, MIDDLE, SIDE, EXTRA (GLFW buttons 1..5).
    down: [5] bool;
    any_down := false;
    for b: 0..4 {
        down[b] = rl.IsMouseButtonDown(cast(rl.MouseButton) b);
        if down[b]  any_down = true;
    }

    // Position before buttons so a click registers where it happened. Keep sending the
    // position while a button is held so dragging outside the window still works.
    if rl.IsCursorOnScreen() || any_down {
        pos := rl.GetMousePosition();
        io.AddMousePosEvent(io, pos.x, pos.y);
    } else {
        io.AddMousePosEvent(io, -FLOAT32_MAX, -FLOAT32_MAX);
    }

    for b: 0..4 {
        if down[b] != bd.mouse_down[b] {
            io.AddMouseButtonEvent(io, cast(s32) b, down[b]);
            bd.mouse_down[b] = down[b];
        }
    }

    wheel := rl.GetMouseWheelMoveV();
    if wheel.x != 0 || wheel.y != 0  io.AddMouseWheelEvent(io, wheel.x, wheel.y);
}

update_keyboard :: (io: *IO, bd: *Backend_Data) {
    // Modifiers first so key events see the right modifier state. ImGui drops duplicate events.
    io.AddKeyEvent(io, .Mod_Ctrl,  rl.IsKeyDown(.KEY_LEFT_CONTROL) || rl.IsKeyDown(.KEY_RIGHT_CONTROL));
    io.AddKeyEvent(io, .Mod_Shift, rl.IsKeyDown(.KEY_LEFT_SHIFT)   || rl.IsKeyDown(.KEY_RIGHT_SHIFT));
    io.AddKeyEvent(io, .Mod_Alt,   rl.IsKeyDown(.KEY_LEFT_ALT)     || rl.IsKeyDown(.KEY_RIGHT_ALT));
    io.AddKeyEvent(io, .Mod_Super, rl.IsKeyDown(.KEY_LEFT_SUPER)   || rl.IsKeyDown(.KEY_RIGHT_SUPER));

    for KEY_MAP {
        code := cast(s32) it.rlk;
        down := rl.IsKeyDown(it.rlk);
        if down != bd.key_down[code] {
            io.AddKeyEvent(io, it.im, down);
            bd.key_down[code] = down;
        }
    }

    // Text input: raylib queues unicode codepoints; drain them all.
    while true {
        c := rl.GetCharPressed();
        if c <= 0  break;
        io.AddInputCharacter(io, cast(u32) c);
    }
}

update_mouse_cursor :: (io: *IO, bd: *Backend_Data) {
    if io.ConfigFlags_ & .NoMouseCursorChange  return;

    // The app hid or disabled the cursor itself (e.g. DisableCursor() for a camera): leave it alone.
    if rl.IsCursorHidden() && !bd.cursor_hidden_by_us  return;

    imgui_cursor := GetMouseCursor();
    if io.MouseDrawCursor || imgui_cursor == .None {
        if !bd.cursor_hidden_by_us {
            rl.HideCursor();
            bd.cursor_hidden_by_us = true;
        }
        return;
    }

    if bd.cursor_hidden_by_us {
        rl.ShowCursor();
        bd.cursor_hidden_by_us = false;
    }

    // raylib creates a new GLFW cursor on every SetMouseCursor() call, so only call it on change.
    rl_cursor := to_raylib_cursor(imgui_cursor);
    if rl_cursor != bd.last_cursor {
        rl.SetMouseCursor(rl_cursor);
        bd.last_cursor = rl_cursor;
    }
}

to_raylib_cursor :: (cursor: MouseCursor) -> rl.MouseCursor {
    if cursor == {
        case .TextInput;  return .MOUSE_CURSOR_IBEAM;
        case .ResizeAll;  return .MOUSE_CURSOR_RESIZE_ALL;
        case .ResizeNS;   return .MOUSE_CURSOR_RESIZE_NS;
        case .ResizeEW;   return .MOUSE_CURSOR_RESIZE_EW;
        case .ResizeNESW; return .MOUSE_CURSOR_RESIZE_NESW;
        case .ResizeNWSE; return .MOUSE_CURSOR_RESIZE_NWSE;
        case .Hand;       return .MOUSE_CURSOR_POINTING_HAND;
        case .NotAllowed; return .MOUSE_CURSOR_NOT_ALLOWED;
    }
    return .MOUSE_CURSOR_DEFAULT;   // Arrow, Wait and Progress have no raylib equivalent beyond the default.
}

//
// Rendering
//

// Vertices submitted per rlCheckRenderBatchLimit() call. Must be a multiple of 3 and well below
// rlgl's batch capacity (32768 vertices on desktop GL, 8192 on GLES2/web).
VERTS_PER_CHUNK :: 3 * 512;

setup_render_state :: () {
    rl.rlDisableBackfaceCulling();   // ImGui doesn't keep a consistent winding.
    rl.rlEnableScissorTest();
}

render_triangles :: (list: *ImDrawList, cmd: *ImDrawCmd, offset: Vector2) {
    count := cast(s64) cmd.ElemCount;
    count -= count % 3;
    if count < 3  return;

    tex_id := cast(u32) get_tex_id(cmd);
    if tex_id == 0  tex_id = rl.rlGetTextureIdDefault();   // rlSetTexture(0) doesn't reliably reset the active draw.

    vtx := list.VtxBuffer.Data;
    idx := list.IdxBuffer.Data;
    vtx_offset := cast(s64) cmd.VtxOffset;
    idx_offset := cast(s64) cmd.IdxOffset;

    rl.rlBegin(rl.RL_TRIANGLES);
    rl.rlSetTexture(tex_id);

    i := 0;
    while i < count {
        chunk := count - i;
        if chunk > VERTS_PER_CHUNK  chunk = VERTS_PER_CHUNK;

        // Reserve room for the whole chunk so no triangle gets split across a batch flush.
        // rlgl restores mode and texture after flushing; re-issuing them is for older raylib versions.
        if rl.rlCheckRenderBatchLimit(cast(s32) chunk) {
            rl.rlBegin(rl.RL_TRIANGLES);
            rl.rlSetTexture(tex_id);
        }

        end := i + chunk;
        while i < end {
            v   := *vtx[vtx_offset + cast(s64) idx[idx_offset + i]];
            col := v.col;   // IM_COL32 layout: R in the low byte, A in the high byte.
            rl.rlColor4ub(cast(u8) (col         & 0xFF),
                       cast(u8) ((col >> 8)  & 0xFF),
                       cast(u8) ((col >> 16) & 0xFF),
                       cast(u8) ((col >> 24) & 0xFF));
            rl.rlTexCoord2f(v.uv.x, v.uv.y);
            rl.rlVertex2f(v.pos.x - offset.x, v.pos.y - offset.y);
            i += 1;
        }
    }

    rl.rlEnd();
}

// ImDrawCallback_ResetRenderState is the sentinel (ImDrawCallback)(-8) in imgui.h.
is_reset_render_state :: (cmd: *ImDrawCmd) -> bool {
    return (cast(*s64) *cmd.UserCallback).* == -8;
}

// ImDrawCmd::GetTexID() is inline in imgui.h, so it isn't in the library; same logic here.
get_tex_id :: (cmd: *ImDrawCmd) -> ImTextureID {
    if cmd.TexRef._TexData != null {
        tex_id := cmd.TexRef._TexData.TexID;
        assert(tex_id != ImTextureID_Invalid, "ImDrawCmd refers to an ImTextureData that was never uploaded.");
        return tex_id;
    }
    return cmd.TexRef._TexID;
}

//
// Textures (ImGuiBackendFlags_RendererHasTextures)
//

update_texture :: (bd: *Backend_Data, tex: *ImTextureData) {
    if tex.Status == {
        case .WantCreate;
            assert(tex.TexID == ImTextureID_Invalid && tex.BackendUserData == null);
            assert(tex.Format == .RGBA32, "imgui_impl_raylib only supports RGBA32 textures (leave io.Fonts.TexDesiredFormat at its default).");

            new_id := rl.rlLoadTexture(tex.Pixels, tex.Width, tex.Height, .RL_PIXELFORMAT_UNCOMPRESSED_R8G8B8A8, 1);
            if new_id == 0 {
                log_error("imgui_impl_raylib: failed to create a %x% texture.", tex.Width, tex.Height);
                return;
            }

            // rlLoadTexture defaults to NEAREST + REPEAT. ImGui needs bilinear filtering for its
            // anti-aliased baked lines, and clamping avoids bleeding at atlas edges.
            rl.rlTextureParameters(new_id, rl.RL_TEXTURE_MIN_FILTER, rl.RL_TEXTURE_FILTER_LINEAR);
            rl.rlTextureParameters(new_id, rl.RL_TEXTURE_MAG_FILTER, rl.RL_TEXTURE_FILTER_LINEAR);
            rl.rlTextureParameters(new_id, rl.RL_TEXTURE_WRAP_S,     rl.RL_TEXTURE_WRAP_CLAMP);
            rl.rlTextureParameters(new_id, rl.RL_TEXTURE_WRAP_T,     rl.RL_TEXTURE_WRAP_CLAMP);

            tex.TexID = cast(ImTextureID) new_id;
            set_status(tex, .OK);

        case .WantUpdates;
            // Upload each dirty rect. rlUpdateTexture() has no row-pitch parameter, so pack every
            // rect into a contiguous scratch buffer first.
            id     := cast(u32) tex.TexID;
            bpp    := cast(s64) tex.BytesPerPixel;
            pitch  := cast(s64) tex.Width * bpp;
            format := cast(s32) rl.rlPixelFormat.RL_PIXELFORMAT_UNCOMPRESSED_R8G8B8A8;

            for u: 0..tex.Updates.Size-1 {
                r  := tex.Updates.Data[u];
                rx := cast(s64) r.x;
                ry := cast(s64) r.y;
                rw := cast(s64) r.w;
                rh := cast(s64) r.h;
                if rw == 0 || rh == 0  continue;

                row_bytes := rw * bpp;
                array_reserve(*bd.upload_buffer, row_bytes * rh);
                for y: 0..rh-1 {
                    src := tex.Pixels + (ry + y) * pitch + rx * bpp;
                    memcpy(bd.upload_buffer.data + y * row_bytes, src, row_bytes);
                }
                rl.rlUpdateTexture(id, cast(s32) rx, cast(s32) ry, cast(s32) rw, cast(s32) rh, format, bd.upload_buffer.data);
            }
            set_status(tex, .OK);

        case .WantDestroy;
            if tex.UnusedFrames > 0  destroy_texture(tex);
    }
}

destroy_texture :: (tex: *ImTextureData) {
    id := cast(u32) tex.TexID;
    if id != 0  rl.rlUnloadTexture(id);
    tex.TexID = ImTextureID_Invalid;
    set_status(tex, .Destroyed);
}

// ImTextureData::SetStatus() is inline in imgui.h; same logic here.
set_status :: (tex: *ImTextureData, status: ImTextureStatus) {
    tex.Status = status;
    if status == .Destroyed && !tex.WantDestroyNextFrame && tex.Pixels != null {
        tex.Status = .WantCreate;
    }
}

//
// Key tables
//

Key_Pair     :: struct { rlk: rl.KeyboardKey;   im: Key; }

KEY_MAP :: Key_Pair.[
    .{.KEY_APOSTROPHE,    .Apostrophe},
    .{.KEY_COMMA,         .Comma},
    .{.KEY_MINUS,         .Minus},
    .{.KEY_PERIOD,        .Period},
    .{.KEY_SLASH,         .Slash},
    .{.KEY_ZERO,          ._0},
    .{.KEY_ONE,           ._1},
    .{.KEY_TWO,           ._2},
    .{.KEY_THREE,         ._3},
    .{.KEY_FOUR,          ._4},
    .{.KEY_FIVE,          ._5},
    .{.KEY_SIX,           ._6},
    .{.KEY_SEVEN,         ._7},
    .{.KEY_EIGHT,         ._8},
    .{.KEY_NINE,          ._9},
    .{.KEY_SEMICOLON,     .Semicolon},
    .{.KEY_EQUAL,         .Equal},
    .{.KEY_A, .A}, .{.KEY_B, .B}, .{.KEY_C, .C}, .{.KEY_D, .D}, .{.KEY_E, .E}, .{.KEY_F, .F},
    .{.KEY_G, .G}, .{.KEY_H, .H}, .{.KEY_I, .I}, .{.KEY_J, .J}, .{.KEY_K, .K}, .{.KEY_L, .L},
    .{.KEY_M, .M}, .{.KEY_N, .N}, .{.KEY_O, .O}, .{.KEY_P, .P}, .{.KEY_Q, .Q}, .{.KEY_R, .R},
    .{.KEY_S, .S}, .{.KEY_T, .T}, .{.KEY_U, .U}, .{.KEY_V, .V}, .{.KEY_W, .W}, .{.KEY_X, .X},
    .{.KEY_Y, .Y}, .{.KEY_Z, .Z},
    .{.KEY_LEFT_BRACKET,  .LeftBracket},
    .{.KEY_BACKSLASH,     .Backslash},
    .{.KEY_RIGHT_BRACKET, .RightBracket},
    .{.KEY_GRAVE,         .GraveAccent},
    .{.KEY_SPACE,         .Space},
    .{.KEY_ESCAPE,        .Escape},
    .{.KEY_ENTER,         .Enter},
    .{.KEY_TAB,           .Tab},
    .{.KEY_BACKSPACE,     .Backspace},
    .{.KEY_INSERT,        .Insert},
    .{.KEY_DELETE,        .Delete},
    .{.KEY_RIGHT,         .RightArrow},
    .{.KEY_LEFT,          .LeftArrow},
    .{.KEY_DOWN,          .DownArrow},
    .{.KEY_UP,            .UpArrow},
    .{.KEY_PAGE_UP,       .PageUp},
    .{.KEY_PAGE_DOWN,     .PageDown},
    .{.KEY_HOME,          .Home},
    .{.KEY_END,           .End},
    .{.KEY_CAPS_LOCK,     .CapsLock},
    .{.KEY_SCROLL_LOCK,   .ScrollLock},
    .{.KEY_NUM_LOCK,      .NumLock},
    .{.KEY_PRINT_SCREEN,  .PrintScreen},
    .{.KEY_PAUSE,         .Pause},
    .{.KEY_F1,  .F1},  .{.KEY_F2,  .F2},  .{.KEY_F3,  .F3},  .{.KEY_F4,  .F4},
    .{.KEY_F5,  .F5},  .{.KEY_F6,  .F6},  .{.KEY_F7,  .F7},  .{.KEY_F8,  .F8},
    .{.KEY_F9,  .F9},  .{.KEY_F10, .F10}, .{.KEY_F11, .F11}, .{.KEY_F12, .F12},
    .{.KEY_LEFT_SHIFT,    .LeftShift},
    .{.KEY_LEFT_CONTROL,  .LeftCtrl},
    .{.KEY_LEFT_ALT,      .LeftAlt},
    .{.KEY_LEFT_SUPER,    .LeftSuper},
    .{.KEY_RIGHT_SHIFT,   .RightShift},
    .{.KEY_RIGHT_CONTROL, .RightCtrl},
    .{.KEY_RIGHT_ALT,     .RightAlt},
    .{.KEY_RIGHT_SUPER,   .RightSuper},
    .{.KEY_KB_MENU,       .Menu},
    .{.KEY_KP_0, .Keypad0}, .{.KEY_KP_1, .Keypad1}, .{.KEY_KP_2, .Keypad2}, .{.KEY_KP_3, .Keypad3},
    .{.KEY_KP_4, .Keypad4}, .{.KEY_KP_5, .Keypad5}, .{.KEY_KP_6, .Keypad6}, .{.KEY_KP_7, .Keypad7},
    .{.KEY_KP_8, .Keypad8}, .{.KEY_KP_9, .Keypad9},
    .{.KEY_KP_DECIMAL,    .KeypadDecimal},
    .{.KEY_KP_DIVIDE,     .KeypadDivide},
    .{.KEY_KP_MULTIPLY,   .KeypadMultiply},
    .{.KEY_KP_SUBTRACT,   .KeypadSubtract},
    .{.KEY_KP_ADD,        .KeypadAdd},
    .{.KEY_KP_ENTER,      .KeypadEnter},
    .{.KEY_KP_EQUAL,      .KeypadEqual},
];

}

#scope_module
#if !USE_RAYLIB {
    ImplJai_Data :: struct {
	window: Window_Type;
	time: float64;
    };
    bd: ImplJai_Data;
}
#import "Basic";
//#import "Window_Creation";
// #import "Window_Type";
rl :: #import "raylib";

