Point :: struct
{
    x, y : s32;
}

F_Point :: struct
{
    x, y : float32;
}

Rect :: struct
{
    x, y, w, h : s32;
}

F_Rect :: struct
{
    x, y, w, h : float32;
}

Rect_To_F_Rect :: inline (rect: *Rect, frect: *F_Rect)
{
    frect.x = cast(float32) rect.x;
    frect.y = cast(float32) rect.y;
    frect.w = cast(float32) rect.w;
    frect.h = cast(float32) rect.h;
}

Point_In_Rect :: inline (p: *Point, r: *Rect) -> bool
{
    return (p && r && (p.x >= r.x) && (p.x < (r.x + r.w)) && (p.y >= r.y) && (p.y < (r.y + r.h)));
}

Rect_Empty :: inline (r: *Rect) -> bool
{
    return (!r || (r.w <= 0) || (r.h <= 0));
}

Rects_Equal :: inline (a: *Rect, b: *Rect) -> bool
{
    return (a && b && (a.x == b.x) && (a.y == b.y) && (a.w == b.w) && (a.h == b.h));
}

Point_In_Rect_Float :: inline (p: *F_Point, r: *F_Rect) -> bool
{
    return ( p && r && (p.x >= r.x) && (p.x <= (r.x + r.w)) && (p.y >= r.y) && (p.y <= (r.y + r.h)) );
}

Rect_Empty_Float :: inline (r: *F_Rect) -> bool
{
    return (!r || (r.w < 0.0) || (r.h < 0.0));
}

Rects_Equal_Epsilon :: inline (a: *F_Rect, b: *F_Rect, epsilon: float32) -> bool
{
    return (a && b && ((a == b) ||
            ((fabsf(a.x - b.x) <= epsilon) &&
            (fabsf(a.y - b.y) <= epsilon) &&
            (fabsf(a.w - b.w) <= epsilon) &&
            (fabsf(a.h - b.h) <= epsilon))));
}

Rects_Equal_Float :: inline (a: *F_Rect, b: *F_Rect) -> bool
{
    return Rects_Equal_Epsilon(a, b, FLT_EPSILON);
}

has_rect_intersection                :: (a: *Rect, b: *Rect) -> bool                                                    #foreign SDL3 "SDL_HasRectIntersection";
get_rect_intersection                :: (a: *Rect, b: *Rect, result: *Rect) -> bool                                     #foreign SDL3 "SDL_GetRectIntersection";
get_rect_union                       :: (a: *Rect, b: *Rect, result: *Rect) -> bool                                     #foreign SDL3 "SDL_GetRectUnion";
get_rect_enclosing_points            :: (points: *Point, count: s32, clip: *Rect, result: *Rect) -> bool                #foreign SDL3 "SDL_GetRectEnclosingPoints";
get_rect_and_line_intersection       :: (rect: *Rect, x1: *s32, y1: *s32, x2: *s32, y2: *s32) -> bool                   #foreign SDL3 "SDL_GetRectAndLineIntersection";
has_rect_intersection_float          :: (a: *F_Rect, b: *F_Rect) -> bool                                                #foreign SDL3 "SDL_HasRectIntersectionFloat";
get_rect_intersection_float          :: (a: *F_Rect, b: *F_Rect, result: *F_Rect) -> bool                               #foreign SDL3 "SDL_GetRectIntersectionFloat";
get_rect_union_float                 :: (a: *F_Rect, b: *F_Rect, result: *F_Rect) -> bool                               #foreign SDL3 "SDL_GetRectUnionFloat";
get_rect_enclosing_points_float      :: (points: *F_Point, count: s32, clip: *F_Rect, result: *F_Rect) -> bool          #foreign SDL3 "SDL_GetRectEnclosingPointsFloat";
get_rect_and_line_intersection_float :: (rect: *F_Rect, x1: *float32, y1: *float32, x2: *float32, y2: *float32) -> bool #foreign SDL3 "SDL_GetRectAndLineIntersectionFloat";
