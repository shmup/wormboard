const win32 = @import("win32.zig");

// colors (BGR format)
pub const COLOR_NORMAL: u32 = 0x00F0F0F0; // light gray (default button)
pub const COLOR_PRESSED: u32 = 0x00CFCFFF; // pale pink (RGB: 0xFFCFCF)
pub const COLOR_TEXT: u32 = 0x00000000; // black
pub const COLOR_TOOLBAR: u32 = COLOR_NORMAL;

pub fn drawButton(dis: *win32.DRAWITEMSTRUCT) void {
    const is_pressed = (dis.itemState & win32.ODS_SELECTED) != 0;

    // pick background color
    const bg_color = if (is_pressed) COLOR_PRESSED else COLOR_NORMAL;
    const brush = win32.CreateSolidBrush(bg_color);
    defer _ = win32.DeleteObject(@ptrCast(brush));

    // fill background
    if (brush) |b| {
        _ = win32.FillRect(dis.hDC, &dis.rcItem, b);
    }

    // draw 3d edge
    var edge_rect = dis.rcItem;
    const edge = if (is_pressed) win32.EDGE_SUNKEN else win32.EDGE_RAISED;
    _ = win32.DrawEdge(dis.hDC, &edge_rect, edge, win32.BF_RECT);

    // get button text
    var text_buf: [64:0]u8 = undefined;
    const hwnd_item: win32.HWND = @ptrCast(dis.hwndItem);
    const text_len = win32.GetWindowTextA(hwnd_item, &text_buf, 64);
    if (text_len > 0) {
        text_buf[@intCast(text_len)] = 0;

        // setup text drawing
        _ = win32.SetBkColor(dis.hDC, bg_color);
        _ = win32.SetTextColor(dis.hDC, COLOR_TEXT);

        // offset text when pressed
        var text_rect = dis.rcItem;
        if (is_pressed) {
            text_rect.left += 1;
            text_rect.top += 1;
        }

        _ = win32.DrawTextA(dis.hDC, &text_buf, text_len, &text_rect, win32.DT_CENTER | win32.DT_VCENTER | win32.DT_SINGLELINE);
    }
}
