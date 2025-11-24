const std = @import("std");
const windows = std.os.windows;

// win32 types
const HWND = windows.HWND;
const HINSTANCE = windows.HINSTANCE;
const LPARAM = windows.LPARAM;
const WPARAM = windows.WPARAM;
const LRESULT = windows.LRESULT;
const HBRUSH = *opaque {};
const HICON = *opaque {};
const HCURSOR = *opaque {};
const HDC = *opaque {};
const HMENU = *opaque {};
const RECT = extern struct {
    left: i32,
    top: i32,
    right: i32,
    bottom: i32,
};
const PAINTSTRUCT = extern struct {
    hdc: HDC,
    fErase: windows.BOOL,
    rcPaint: RECT,
    fRestore: windows.BOOL,
    fIncUpdate: windows.BOOL,
    rgbReserved: [32]u8,
};
const POINT = extern struct {
    x: i32,
    y: i32,
};
const MSG = extern struct {
    hwnd: ?HWND,
    message: u32,
    wParam: WPARAM,
    lParam: LPARAM,
    time: u32,
    pt: POINT,
};
const WNDCLASSEXA = extern struct {
    cbSize: u32 = @sizeOf(WNDCLASSEXA),
    style: u32 = 0,
    lpfnWndProc: *const fn (HWND, u32, WPARAM, LPARAM) callconv(.c) LRESULT,
    cbClsExtra: i32 = 0,
    cbWndExtra: i32 = 0,
    hInstance: ?HINSTANCE = null,
    hIcon: ?HICON = null,
    hCursor: ?HCURSOR = null,
    hbrBackground: ?HBRUSH = null,
    lpszMenuName: ?[*:0]const u8 = null,
    lpszClassName: [*:0]const u8,
    hIconSm: ?HICON = null,
};
const CREATESTRUCTA = extern struct {
    lpCreateParams: ?*anyopaque,
    hInstance: ?HINSTANCE,
    hMenu: ?HMENU,
    hwndParent: ?HWND,
    cy: i32,
    cx: i32,
    y: i32,
    x: i32,
    style: i32,
    lpszName: ?[*:0]const u8,
    lpszClass: ?[*:0]const u8,
    dwExStyle: u32,
};
const SCROLLINFO = extern struct {
    cbSize: u32 = @sizeOf(SCROLLINFO),
    fMask: u32 = 0,
    nMin: i32 = 0,
    nMax: i32 = 0,
    nPage: u32 = 0,
    nPos: i32 = 0,
    nTrackPos: i32 = 0,
};

// window styles
const WS_OVERLAPPEDWINDOW: u32 = 0x00CF0000;
const WS_VISIBLE: u32 = 0x10000000;
const WS_CHILD: u32 = 0x40000000;
const WS_VSCROLL: u32 = 0x00200000;
const WS_CLIPCHILDREN: u32 = 0x02000000;
const BS_PUSHBUTTON: u32 = 0x00000000;
const CW_USEDEFAULT: i32 = @bitCast(@as(u32, 0x80000000));

// window messages
const WM_DESTROY: u32 = 0x0002;
const WM_SIZE: u32 = 0x0005;
const WM_PAINT: u32 = 0x000F;
const WM_COMMAND: u32 = 0x0111;
const WM_VSCROLL: u32 = 0x0115;
const WM_MOUSEWHEEL: u32 = 0x020A;
const WM_CREATE: u32 = 0x0001;
const WM_GETMINMAXINFO: u32 = 0x0024;

// scroll bar
const SB_VERT: i32 = 1;
const SIF_RANGE: u32 = 0x0001;
const SIF_PAGE: u32 = 0x0002;
const SIF_POS: u32 = 0x0004;
const SIF_ALL: u32 = SIF_RANGE | SIF_PAGE | SIF_POS;
const SB_LINEUP: u32 = 0;
const SB_LINEDOWN: u32 = 1;
const SB_PAGEUP: u32 = 2;
const SB_PAGEDOWN: u32 = 3;
const SB_THUMBTRACK: u32 = 5;

// combobox
const CBS_DROPDOWNLIST: u32 = 0x0003;
const CBS_HASSTRINGS: u32 = 0x0200;
const CB_ADDSTRING: u32 = 0x0143;
const CB_SETCURSEL: u32 = 0x014E;
const CB_GETCURSEL: u32 = 0x0147;
const CBN_SELCHANGE: u16 = 1;

// button notifications
const BN_CLICKED: u16 = 0;

// sound flags
const SND_MEMORY: u32 = 0x0004;
const SND_ASYNC: u32 = 0x0001;
const SND_NOSTOP: u32 = 0x0010;

// color
const COLOR_BTNFACE: usize = 15;

// minmaxinfo for minimum window size
const MINMAXINFO = extern struct {
    ptReserved: POINT,
    ptMaxSize: POINT,
    ptMaxPosition: POINT,
    ptMinTrackSize: POINT,
    ptMaxTrackSize: POINT,
};

// win32 functions (stdcall on 32-bit, but on x86_64 it's the same as C)
extern "user32" fn RegisterClassExA(*const WNDCLASSEXA) callconv(.c) u16;
extern "user32" fn CreateWindowExA(
    dwExStyle: u32,
    lpClassName: [*:0]const u8,
    lpWindowName: [*:0]const u8,
    dwStyle: u32,
    x: i32,
    y: i32,
    nWidth: i32,
    nHeight: i32,
    hWndParent: ?HWND,
    hMenu: ?HMENU,
    hInstance: ?HINSTANCE,
    lpParam: ?*anyopaque,
) callconv(.c) ?HWND;
extern "user32" fn DefWindowProcA(HWND, u32, WPARAM, LPARAM) callconv(.c) LRESULT;
extern "user32" fn GetMessageA(*MSG, ?HWND, u32, u32) callconv(.c) windows.BOOL;
extern "user32" fn TranslateMessage(*const MSG) callconv(.c) windows.BOOL;
extern "user32" fn DispatchMessageA(*const MSG) callconv(.c) LRESULT;
extern "user32" fn PostQuitMessage(i32) callconv(.c) void;
extern "user32" fn BeginPaint(HWND, *PAINTSTRUCT) callconv(.c) ?HDC;
extern "user32" fn EndPaint(HWND, *const PAINTSTRUCT) callconv(.c) windows.BOOL;
extern "user32" fn GetClientRect(HWND, *RECT) callconv(.c) windows.BOOL;
extern "user32" fn MoveWindow(HWND, i32, i32, i32, i32, windows.BOOL) callconv(.c) windows.BOOL;
extern "user32" fn SetScrollInfo(HWND, i32, *const SCROLLINFO, windows.BOOL) callconv(.c) i32;
extern "user32" fn GetScrollInfo(HWND, i32, *SCROLLINFO) callconv(.c) windows.BOOL;
extern "user32" fn ScrollWindow(HWND, i32, i32, ?*const RECT, ?*const RECT) callconv(.c) windows.BOOL;
extern "user32" fn LoadCursorA(?HINSTANCE, usize) callconv(.c) ?HCURSOR;
extern "user32" fn ShowWindow(HWND, i32) callconv(.c) windows.BOOL;
extern "user32" fn UpdateWindow(HWND) callconv(.c) windows.BOOL;
extern "user32" fn DestroyWindow(HWND) callconv(.c) windows.BOOL;
extern "user32" fn SendMessageA(HWND, u32, WPARAM, LPARAM) callconv(.c) LRESULT;
extern "kernel32" fn GetModuleHandleA(?[*:0]const u8) callconv(.c) ?HINSTANCE;
extern "gdi32" fn GetStockObject(i32) callconv(.c) ?HBRUSH;
extern "winmm" fn PlaySoundA(?[*]const u8, ?HINSTANCE, u32) callconv(.c) windows.BOOL;

// embedded wav data
const WavFile = struct {
    name: []const u8,
    data: []const u8,
};

const SoundBank = struct {
    name: [:0]const u8,
    wavs: []const WavFile,
};

// button names (shared across all banks with same files)
const button_names = [_][]const u8{
    "amazing",
    "boring",
    "brilliant",
    "bummer",
    "bungee",
    "byebye",
    "collect",
    "comeonthen",
    "coward",
    "dragonpunch",
    "drop",
    "excellent",
    "fatality",
    "fireball",
    "fire",
    "firstblood",
    "flawless",
    "goaway",
    "grenade",
    "hello",
    "hmm",
    "hurry",
    "illgetyou",
    "incoming",
    "jump1",
    "jump2",
    "justyouwait",
    "kamikaze",
    "laugh",
    "leavemealone",
    "missed",
    "nooo",
    "ohdear",
    "oinutter",
    "ooff1",
    "ooff2",
    "ooff3",
    "oops",
    "orders",
    "ouch",
    "ow1",
    "ow2",
    "ow3",
    "perfect",
    "revenge",
    "runaway",
    "stupid",
    "surf",
    "takecover",
    "traitor",
    "uh-oh",
    "victory",
    "watchthis",
    "whatthe",
    "wobble",
    "yessir",
    "youllregretthat",
};

const american_wavs = [_]WavFile{
    .{ .name = "amazing", .data = @embedFile("wavs/Speech-Banks/American/AMAZING.WAV") },
    .{ .name = "boring", .data = @embedFile("wavs/Speech-Banks/American/BORING.WAV") },
    .{ .name = "brilliant", .data = @embedFile("wavs/Speech-Banks/American/BRILLIANT.WAV") },
    .{ .name = "bummer", .data = @embedFile("wavs/Speech-Banks/American/BUMMER.WAV") },
    .{ .name = "bungee", .data = @embedFile("wavs/Speech-Banks/American/BUNGEE.WAV") },
    .{ .name = "byebye", .data = @embedFile("wavs/Speech-Banks/American/BYEBYE.WAV") },
    .{ .name = "collect", .data = @embedFile("wavs/Speech-Banks/American/COLLECT.WAV") },
    .{ .name = "comeonthen", .data = @embedFile("wavs/Speech-Banks/American/COMEONTHEN.WAV") },
    .{ .name = "coward", .data = @embedFile("wavs/Speech-Banks/American/COWARD.WAV") },
    .{ .name = "dragonpunch", .data = @embedFile("wavs/Speech-Banks/American/DRAGONPUNCH.WAV") },
    .{ .name = "drop", .data = @embedFile("wavs/Speech-Banks/American/DROP.WAV") },
    .{ .name = "excellent", .data = @embedFile("wavs/Speech-Banks/American/EXCELLENT.WAV") },
    .{ .name = "fatality", .data = @embedFile("wavs/Speech-Banks/American/FATALITY.WAV") },
    .{ .name = "fireball", .data = @embedFile("wavs/Speech-Banks/American/FIREBALL.WAV") },
    .{ .name = "fire", .data = @embedFile("wavs/Speech-Banks/American/FIRE.WAV") },
    .{ .name = "firstblood", .data = @embedFile("wavs/Speech-Banks/American/FIRSTBLOOD.WAV") },
    .{ .name = "flawless", .data = @embedFile("wavs/Speech-Banks/American/FLAWLESS.WAV") },
    .{ .name = "goaway", .data = @embedFile("wavs/Speech-Banks/American/GOAWAY.WAV") },
    .{ .name = "grenade", .data = @embedFile("wavs/Speech-Banks/American/GRENADE.WAV") },
    .{ .name = "hello", .data = @embedFile("wavs/Speech-Banks/American/HELLO.WAV") },
    .{ .name = "hmm", .data = @embedFile("wavs/Speech-Banks/American/HMM.WAV") },
    .{ .name = "hurry", .data = @embedFile("wavs/Speech-Banks/American/HURRY.WAV") },
    .{ .name = "illgetyou", .data = @embedFile("wavs/Speech-Banks/American/ILLGETYOU.WAV") },
    .{ .name = "incoming", .data = @embedFile("wavs/Speech-Banks/American/INCOMING.WAV") },
    .{ .name = "jump1", .data = @embedFile("wavs/Speech-Banks/American/JUMP1.WAV") },
    .{ .name = "jump2", .data = @embedFile("wavs/Speech-Banks/American/JUMP2.WAV") },
    .{ .name = "justyouwait", .data = @embedFile("wavs/Speech-Banks/American/JUSTYOUWAIT.WAV") },
    .{ .name = "kamikaze", .data = @embedFile("wavs/Speech-Banks/American/KAMIKAZE.WAV") },
    .{ .name = "laugh", .data = @embedFile("wavs/Speech-Banks/American/LAUGH.WAV") },
    .{ .name = "leavemealone", .data = @embedFile("wavs/Speech-Banks/American/LEAVEMEALONE.WAV") },
    .{ .name = "missed", .data = @embedFile("wavs/Speech-Banks/American/MISSED.WAV") },
    .{ .name = "nooo", .data = @embedFile("wavs/Speech-Banks/American/NOOO.WAV") },
    .{ .name = "ohdear", .data = @embedFile("wavs/Speech-Banks/American/OHDEAR.WAV") },
    .{ .name = "oinutter", .data = @embedFile("wavs/Speech-Banks/American/OINUTTER.WAV") },
    .{ .name = "ooff1", .data = @embedFile("wavs/Speech-Banks/American/OOFF1.WAV") },
    .{ .name = "ooff2", .data = @embedFile("wavs/Speech-Banks/American/OOFF2.WAV") },
    .{ .name = "ooff3", .data = @embedFile("wavs/Speech-Banks/American/OOFF3.WAV") },
    .{ .name = "oops", .data = @embedFile("wavs/Speech-Banks/American/OOPS.WAV") },
    .{ .name = "orders", .data = @embedFile("wavs/Speech-Banks/American/ORDERS.WAV") },
    .{ .name = "ouch", .data = @embedFile("wavs/Speech-Banks/American/OUCH.WAV") },
    .{ .name = "ow1", .data = @embedFile("wavs/Speech-Banks/American/OW1.WAV") },
    .{ .name = "ow2", .data = @embedFile("wavs/Speech-Banks/American/OW2.WAV") },
    .{ .name = "ow3", .data = @embedFile("wavs/Speech-Banks/American/OW3.WAV") },
    .{ .name = "perfect", .data = @embedFile("wavs/Speech-Banks/American/PERFECT.WAV") },
    .{ .name = "revenge", .data = @embedFile("wavs/Speech-Banks/American/REVENGE.WAV") },
    .{ .name = "runaway", .data = @embedFile("wavs/Speech-Banks/American/RUNAWAY.WAV") },
    .{ .name = "stupid", .data = @embedFile("wavs/Speech-Banks/American/STUPID.WAV") },
    .{ .name = "surf", .data = @embedFile("wavs/Speech-Banks/American/SURF.WAV") },
    .{ .name = "takecover", .data = @embedFile("wavs/Speech-Banks/American/TAKECOVER.WAV") },
    .{ .name = "traitor", .data = @embedFile("wavs/Speech-Banks/American/TRAITOR.WAV") },
    .{ .name = "uh-oh", .data = @embedFile("wavs/Speech-Banks/American/UH-OH.WAV") },
    .{ .name = "victory", .data = @embedFile("wavs/Speech-Banks/American/VICTORY.WAV") },
    .{ .name = "watchthis", .data = @embedFile("wavs/Speech-Banks/American/WATCHTHIS.WAV") },
    .{ .name = "whatthe", .data = @embedFile("wavs/Speech-Banks/American/WHATTHE.WAV") },
    .{ .name = "wobble", .data = @embedFile("wavs/Speech-Banks/American/WOBBLE.WAV") },
    .{ .name = "yessir", .data = @embedFile("wavs/Speech-Banks/American/YESSIR.WAV") },
    .{ .name = "youllregretthat", .data = @embedFile("wavs/Speech-Banks/American/YOULLREGRETTHAT.WAV") },
};

const english_wavs = [_]WavFile{
    .{ .name = "amazing", .data = @embedFile("wavs/Speech-Banks/English/AMAZING.WAV") },
    .{ .name = "boring", .data = @embedFile("wavs/Speech-Banks/English/BORING.WAV") },
    .{ .name = "brilliant", .data = @embedFile("wavs/Speech-Banks/English/BRILLIANT.WAV") },
    .{ .name = "bummer", .data = @embedFile("wavs/Speech-Banks/English/BUMMER.WAV") },
    .{ .name = "bungee", .data = @embedFile("wavs/Speech-Banks/English/BUNGEE.WAV") },
    .{ .name = "byebye", .data = @embedFile("wavs/Speech-Banks/English/BYEBYE.WAV") },
    .{ .name = "collect", .data = @embedFile("wavs/Speech-Banks/English/COLLECT.WAV") },
    .{ .name = "comeonthen", .data = @embedFile("wavs/Speech-Banks/English/COMEONTHEN.WAV") },
    .{ .name = "coward", .data = @embedFile("wavs/Speech-Banks/English/COWARD.WAV") },
    .{ .name = "dragonpunch", .data = @embedFile("wavs/Speech-Banks/English/DRAGONPUNCH.WAV") },
    .{ .name = "drop", .data = @embedFile("wavs/Speech-Banks/English/DROP.WAV") },
    .{ .name = "excellent", .data = @embedFile("wavs/Speech-Banks/English/EXCELLENT.WAV") },
    .{ .name = "fatality", .data = @embedFile("wavs/Speech-Banks/English/FATALITY.WAV") },
    .{ .name = "fireball", .data = @embedFile("wavs/Speech-Banks/English/FIREBALL.WAV") },
    .{ .name = "fire", .data = @embedFile("wavs/Speech-Banks/English/FIRE.WAV") },
    .{ .name = "firstblood", .data = @embedFile("wavs/Speech-Banks/English/FIRSTBLOOD.WAV") },
    .{ .name = "flawless", .data = @embedFile("wavs/Speech-Banks/English/FLAWLESS.WAV") },
    .{ .name = "goaway", .data = @embedFile("wavs/Speech-Banks/English/GOAWAY.WAV") },
    .{ .name = "grenade", .data = @embedFile("wavs/Speech-Banks/English/GRENADE.WAV") },
    .{ .name = "hello", .data = @embedFile("wavs/Speech-Banks/English/HELLO.WAV") },
    .{ .name = "hmm", .data = @embedFile("wavs/Speech-Banks/English/HMM.WAV") },
    .{ .name = "hurry", .data = @embedFile("wavs/Speech-Banks/English/HURRY.WAV") },
    .{ .name = "illgetyou", .data = @embedFile("wavs/Speech-Banks/English/ILLGETYOU.WAV") },
    .{ .name = "incoming", .data = @embedFile("wavs/Speech-Banks/English/INCOMING.WAV") },
    .{ .name = "jump1", .data = @embedFile("wavs/Speech-Banks/English/JUMP1.WAV") },
    .{ .name = "jump2", .data = @embedFile("wavs/Speech-Banks/English/JUMP2.WAV") },
    .{ .name = "justyouwait", .data = @embedFile("wavs/Speech-Banks/English/JUSTYOUWAIT.WAV") },
    .{ .name = "kamikaze", .data = @embedFile("wavs/Speech-Banks/English/KAMIKAZE.WAV") },
    .{ .name = "laugh", .data = @embedFile("wavs/Speech-Banks/English/LAUGH.WAV") },
    .{ .name = "leavemealone", .data = @embedFile("wavs/Speech-Banks/English/LEAVEMEALONE.WAV") },
    .{ .name = "missed", .data = @embedFile("wavs/Speech-Banks/English/MISSED.WAV") },
    .{ .name = "nooo", .data = @embedFile("wavs/Speech-Banks/English/NOOO.WAV") },
    .{ .name = "ohdear", .data = @embedFile("wavs/Speech-Banks/English/OHDEAR.WAV") },
    .{ .name = "oinutter", .data = @embedFile("wavs/Speech-Banks/English/OINUTTER.WAV") },
    .{ .name = "ooff1", .data = @embedFile("wavs/Speech-Banks/English/OOFF1.WAV") },
    .{ .name = "ooff2", .data = @embedFile("wavs/Speech-Banks/English/OOFF2.WAV") },
    .{ .name = "ooff3", .data = @embedFile("wavs/Speech-Banks/English/OOFF3.WAV") },
    .{ .name = "oops", .data = @embedFile("wavs/Speech-Banks/English/OOPS.WAV") },
    .{ .name = "orders", .data = @embedFile("wavs/Speech-Banks/English/ORDERS.WAV") },
    .{ .name = "ouch", .data = @embedFile("wavs/Speech-Banks/English/OUCH.WAV") },
    .{ .name = "ow1", .data = @embedFile("wavs/Speech-Banks/English/OW1.WAV") },
    .{ .name = "ow2", .data = @embedFile("wavs/Speech-Banks/English/OW2.WAV") },
    .{ .name = "ow3", .data = @embedFile("wavs/Speech-Banks/English/OW3.WAV") },
    .{ .name = "perfect", .data = @embedFile("wavs/Speech-Banks/English/PERFECT.WAV") },
    .{ .name = "revenge", .data = @embedFile("wavs/Speech-Banks/English/REVENGE.WAV") },
    .{ .name = "runaway", .data = @embedFile("wavs/Speech-Banks/English/RUNAWAY.WAV") },
    .{ .name = "stupid", .data = @embedFile("wavs/Speech-Banks/English/STUPID.WAV") },
    .{ .name = "surf", .data = @embedFile("wavs/Speech-Banks/English/SURF.WAV") },
    .{ .name = "takecover", .data = @embedFile("wavs/Speech-Banks/English/TAKECOVER.WAV") },
    .{ .name = "traitor", .data = @embedFile("wavs/Speech-Banks/English/TRAITOR.WAV") },
    .{ .name = "uh-oh", .data = @embedFile("wavs/Speech-Banks/English/UH-OH.WAV") },
    .{ .name = "victory", .data = @embedFile("wavs/Speech-Banks/English/VICTORY.WAV") },
    .{ .name = "watchthis", .data = @embedFile("wavs/Speech-Banks/English/WATCHTHIS.WAV") },
    .{ .name = "whatthe", .data = @embedFile("wavs/Speech-Banks/English/WHATTHE.WAV") },
    .{ .name = "wobble", .data = @embedFile("wavs/Speech-Banks/English/WOBBLE.WAV") },
    .{ .name = "yessir", .data = @embedFile("wavs/Speech-Banks/English/YESSIR.WAV") },
    .{ .name = "youllregretthat", .data = @embedFile("wavs/Speech-Banks/English/YOULLREGRETTHAT.WAV") },
};

const australian_wavs = [_]WavFile{
    .{ .name = "amazing", .data = @embedFile("wavs/Speech-Banks/Australian/AMAZING.WAV") },
    .{ .name = "boring", .data = @embedFile("wavs/Speech-Banks/Australian/BORING.WAV") },
    .{ .name = "brilliant", .data = @embedFile("wavs/Speech-Banks/Australian/BRILLIANT.WAV") },
    .{ .name = "bummer", .data = @embedFile("wavs/Speech-Banks/Australian/BUMMER.WAV") },
    .{ .name = "bungee", .data = @embedFile("wavs/Speech-Banks/Australian/BUNGEE.WAV") },
    .{ .name = "byebye", .data = @embedFile("wavs/Speech-Banks/Australian/BYEBYE.WAV") },
    .{ .name = "collect", .data = @embedFile("wavs/Speech-Banks/Australian/COLLECT.WAV") },
    .{ .name = "comeonthen", .data = @embedFile("wavs/Speech-Banks/Australian/COMEONTHEN.WAV") },
    .{ .name = "coward", .data = @embedFile("wavs/Speech-Banks/Australian/COWARD.WAV") },
    .{ .name = "dragonpunch", .data = @embedFile("wavs/Speech-Banks/Australian/DRAGONPUNCH.WAV") },
    .{ .name = "drop", .data = @embedFile("wavs/Speech-Banks/Australian/DROP.WAV") },
    .{ .name = "excellent", .data = @embedFile("wavs/Speech-Banks/Australian/EXCELLENT.WAV") },
    .{ .name = "fatality", .data = @embedFile("wavs/Speech-Banks/Australian/FATALITY.WAV") },
    .{ .name = "fireball", .data = @embedFile("wavs/Speech-Banks/Australian/FIREBALL.WAV") },
    .{ .name = "fire", .data = @embedFile("wavs/Speech-Banks/Australian/FIRE.WAV") },
    .{ .name = "firstblood", .data = @embedFile("wavs/Speech-Banks/Australian/FIRSTBLOOD.WAV") },
    .{ .name = "flawless", .data = @embedFile("wavs/Speech-Banks/Australian/FLAWLESS.WAV") },
    .{ .name = "goaway", .data = @embedFile("wavs/Speech-Banks/Australian/GOAWAY.WAV") },
    .{ .name = "grenade", .data = @embedFile("wavs/Speech-Banks/Australian/GRENADE.WAV") },
    .{ .name = "hello", .data = @embedFile("wavs/Speech-Banks/Australian/HELLO.WAV") },
    .{ .name = "hmm", .data = @embedFile("wavs/Speech-Banks/Australian/HMM.WAV") },
    .{ .name = "hurry", .data = @embedFile("wavs/Speech-Banks/Australian/HURRY.WAV") },
    .{ .name = "illgetyou", .data = @embedFile("wavs/Speech-Banks/Australian/ILLGETYOU.WAV") },
    .{ .name = "incoming", .data = @embedFile("wavs/Speech-Banks/Australian/INCOMING.WAV") },
    .{ .name = "jump1", .data = @embedFile("wavs/Speech-Banks/Australian/JUMP1.WAV") },
    .{ .name = "jump2", .data = @embedFile("wavs/Speech-Banks/Australian/JUMP2.WAV") },
    .{ .name = "justyouwait", .data = @embedFile("wavs/Speech-Banks/Australian/JUSTYOUWAIT.WAV") },
    .{ .name = "kamikaze", .data = @embedFile("wavs/Speech-Banks/Australian/KAMIKAZE.WAV") },
    .{ .name = "laugh", .data = @embedFile("wavs/Speech-Banks/Australian/LAUGH.WAV") },
    .{ .name = "leavemealone", .data = @embedFile("wavs/Speech-Banks/Australian/LEAVEMEALONE.WAV") },
    .{ .name = "missed", .data = @embedFile("wavs/Speech-Banks/Australian/MISSED.WAV") },
    .{ .name = "nooo", .data = @embedFile("wavs/Speech-Banks/Australian/NOOO.WAV") },
    .{ .name = "ohdear", .data = @embedFile("wavs/Speech-Banks/Australian/OHDEAR.WAV") },
    .{ .name = "oinutter", .data = @embedFile("wavs/Speech-Banks/Australian/OINUTTER.WAV") },
    .{ .name = "ooff1", .data = @embedFile("wavs/Speech-Banks/Australian/OOFF1.WAV") },
    .{ .name = "ooff2", .data = @embedFile("wavs/Speech-Banks/Australian/OOFF2.WAV") },
    .{ .name = "ooff3", .data = @embedFile("wavs/Speech-Banks/Australian/OOFF3.WAV") },
    .{ .name = "oops", .data = @embedFile("wavs/Speech-Banks/Australian/OOPS.WAV") },
    .{ .name = "orders", .data = @embedFile("wavs/Speech-Banks/Australian/ORDERS.WAV") },
    .{ .name = "ouch", .data = @embedFile("wavs/Speech-Banks/Australian/OUCH.WAV") },
    .{ .name = "ow1", .data = @embedFile("wavs/Speech-Banks/Australian/OW1.WAV") },
    .{ .name = "ow2", .data = @embedFile("wavs/Speech-Banks/Australian/OW2.WAV") },
    .{ .name = "ow3", .data = @embedFile("wavs/Speech-Banks/Australian/OW3.WAV") },
    .{ .name = "perfect", .data = @embedFile("wavs/Speech-Banks/Australian/PERFECT.WAV") },
    .{ .name = "revenge", .data = @embedFile("wavs/Speech-Banks/Australian/REVENGE.WAV") },
    .{ .name = "runaway", .data = @embedFile("wavs/Speech-Banks/Australian/RUNAWAY.WAV") },
    .{ .name = "stupid", .data = @embedFile("wavs/Speech-Banks/Australian/STUPID.WAV") },
    .{ .name = "surf", .data = @embedFile("wavs/Speech-Banks/Australian/SURF.WAV") },
    .{ .name = "takecover", .data = @embedFile("wavs/Speech-Banks/Australian/TAKECOVER.WAV") },
    .{ .name = "traitor", .data = @embedFile("wavs/Speech-Banks/Australian/TRAITOR.WAV") },
    .{ .name = "uh-oh", .data = @embedFile("wavs/Speech-Banks/Australian/UH-OH.WAV") },
    .{ .name = "victory", .data = @embedFile("wavs/Speech-Banks/Australian/VICTORY.WAV") },
    .{ .name = "watchthis", .data = @embedFile("wavs/Speech-Banks/Australian/WATCHTHIS.WAV") },
    .{ .name = "whatthe", .data = @embedFile("wavs/Speech-Banks/Australian/WHATTHE.WAV") },
    .{ .name = "wobble", .data = @embedFile("wavs/Speech-Banks/Australian/WOBBLE.WAV") },
    .{ .name = "yessir", .data = @embedFile("wavs/Speech-Banks/Australian/YESSIR.WAV") },
    .{ .name = "youllregretthat", .data = @embedFile("wavs/Speech-Banks/Australian/YOULLREGRETTHAT.WAV") },
};

const sound_banks = [_]SoundBank{
    .{ .name = "American", .wavs = &american_wavs },
    .{ .name = "English", .wavs = &english_wavs },
    .{ .name = "Australian", .wavs = &australian_wavs },
};

// layout constants
const BUTTON_HEIGHT: i32 = 25;
const BUTTON_PADDING: i32 = 4;
const BUTTON_CHAR_WIDTH: i32 = 8; // approximate char width for button sizing
const MIN_BUTTON_WIDTH: i32 = 60;
const MIN_WINDOW_WIDTH: i32 = 400;
const MIN_WINDOW_HEIGHT: i32 = 300;
const TOOLBAR_HEIGHT: i32 = 30; // space for dropdown at top
const COMBOBOX_WIDTH: i32 = 150;
const COMBOBOX_HEIGHT: i32 = 200; // dropdown list height

// control IDs - buttons use 0..N-1, combobox uses a high ID
const ID_COMBOBOX: usize = 1000;

// globals for window state
const NUM_BUTTONS = button_names.len;
var g_buttons: [NUM_BUTTONS]?HWND = [_]?HWND{null} ** NUM_BUTTONS;
var g_combobox: ?HWND = null;
var g_current_bank: usize = 0;
var g_scroll_pos: i32 = 0;
var g_content_height: i32 = 0;
var g_main_hwnd: ?HWND = null;

const IDC_ARROW: usize = 32512;

fn wndProc(hwnd: HWND, msg: u32, wParam: WPARAM, lParam: LPARAM) callconv(.c) LRESULT {
    switch (msg) {
        WM_CREATE => {
            g_main_hwnd = hwnd;
            createCombobox(hwnd);
            createButtons(hwnd);
            return 0;
        },
        WM_SIZE => {
            layoutControls(hwnd);
            return 0;
        },
        WM_GETMINMAXINFO => {
            const mmi: *MINMAXINFO = @ptrFromInt(@as(usize, @bitCast(lParam)));
            mmi.ptMinTrackSize.x = MIN_WINDOW_WIDTH;
            mmi.ptMinTrackSize.y = MIN_WINDOW_HEIGHT;
            return 0;
        },
        WM_COMMAND => {
            const notification = @as(u16, @truncate(wParam >> 16));
            const control_id = @as(u16, @truncate(wParam));
            if (control_id == ID_COMBOBOX and notification == CBN_SELCHANGE) {
                handleBankChange(hwnd);
            } else if (notification == BN_CLICKED and control_id < NUM_BUTTONS) {
                playSound(control_id);
            }
            return 0;
        },
        WM_VSCROLL => {
            handleScroll(hwnd, wParam);
            return 0;
        },
        WM_MOUSEWHEEL => {
            const hi_word: u16 = @truncate(@as(u64, @bitCast(wParam)) >> 16);
            const delta: i16 = @bitCast(hi_word);
            const scroll_amount: i32 = if (delta > 0) -30 else 30;
            scrollContent(hwnd, scroll_amount);
            return 0;
        },
        WM_DESTROY => {
            PostQuitMessage(0);
            return 0;
        },
        else => return DefWindowProcA(hwnd, msg, wParam, lParam),
    }
}

fn createCombobox(hwnd: HWND) void {
    const hinstance = GetModuleHandleA(null);
    g_combobox = CreateWindowExA(
        0,
        "COMBOBOX",
        null,
        WS_CHILD | WS_VISIBLE | CBS_DROPDOWNLIST | CBS_HASSTRINGS,
        BUTTON_PADDING,
        BUTTON_PADDING,
        COMBOBOX_WIDTH,
        COMBOBOX_HEIGHT,
        hwnd,
        @ptrFromInt(ID_COMBOBOX),
        hinstance,
        null,
    );

    // add bank names to combobox
    if (g_combobox) |combo| {
        for (sound_banks) |bank| {
            _ = SendMessageA(combo, CB_ADDSTRING, 0, @intFromPtr(bank.name.ptr));
        }
        // select first bank
        _ = SendMessageA(combo, CB_SETCURSEL, 0, 0);
    }
}

fn createButtons(hwnd: HWND) void {
    const hinstance = GetModuleHandleA(null);
    for (button_names, 0..) |name, i| {
        // create null-terminated name
        var name_buf: [64:0]u8 = undefined;
        const name_len = @min(name.len, 63);
        @memcpy(name_buf[0..name_len], name[0..name_len]);
        name_buf[name_len] = 0;

        g_buttons[i] = CreateWindowExA(
            0,
            "BUTTON",
            &name_buf,
            WS_CHILD | WS_VISIBLE | BS_PUSHBUTTON,
            0,
            0,
            100,
            BUTTON_HEIGHT,
            hwnd,
            @ptrFromInt(i), // use index as menu/id
            hinstance,
            null,
        );
    }
}

fn layoutControls(hwnd: HWND) void {
    var rect: RECT = undefined;
    _ = GetClientRect(hwnd, &rect);
    const client_width = rect.right - rect.left;
    const client_height = rect.bottom - rect.top;
    const button_area_height = client_height - TOOLBAR_HEIGHT;

    // calculate button widths based on text length
    var button_widths: [NUM_BUTTONS]i32 = undefined;
    for (button_names, 0..) |name, i| {
        const text_width = @as(i32, @intCast(name.len)) * BUTTON_CHAR_WIDTH + 16; // padding
        button_widths[i] = @max(text_width, MIN_BUTTON_WIDTH);
    }

    // layout buttons in rows, starting below toolbar
    var x: i32 = BUTTON_PADDING;
    var y: i32 = TOOLBAR_HEIGHT + BUTTON_PADDING - g_scroll_pos;
    const row_height: i32 = BUTTON_HEIGHT + BUTTON_PADDING;

    for (0..NUM_BUTTONS) |i| {
        const btn_width = button_widths[i];

        // wrap to next row if needed
        if (x + btn_width + BUTTON_PADDING > client_width and x > BUTTON_PADDING) {
            x = BUTTON_PADDING;
            y += row_height;
        }

        if (g_buttons[i]) |btn| {
            _ = MoveWindow(btn, x, y, btn_width, BUTTON_HEIGHT, 1);
        }

        x += btn_width + BUTTON_PADDING;
    }

    // calculate total content height (relative to button area)
    g_content_height = (y - TOOLBAR_HEIGHT) + row_height + g_scroll_pos;

    // update scrollbar based on button area height
    var si = SCROLLINFO{
        .fMask = SIF_ALL,
        .nMin = 0,
        .nMax = g_content_height,
        .nPage = @intCast(button_area_height),
        .nPos = g_scroll_pos,
    };
    _ = SetScrollInfo(hwnd, SB_VERT, &si, 1);
}

fn handleScroll(hwnd: HWND, wParam: WPARAM) void {
    var si = SCROLLINFO{ .fMask = SIF_ALL };
    _ = GetScrollInfo(hwnd, SB_VERT, &si);

    const action = @as(u32, @truncate(wParam));
    var new_pos = si.nPos;

    switch (action) {
        SB_LINEUP => new_pos -= 20,
        SB_LINEDOWN => new_pos += 20,
        SB_PAGEUP => new_pos -= @as(i32, @intCast(si.nPage)),
        SB_PAGEDOWN => new_pos += @as(i32, @intCast(si.nPage)),
        SB_THUMBTRACK => new_pos = si.nTrackPos,
        else => {},
    }

    // clamp
    const max_pos = si.nMax - @as(i32, @intCast(si.nPage));
    new_pos = @max(0, @min(new_pos, max_pos));

    if (new_pos != g_scroll_pos) {
        const delta = g_scroll_pos - new_pos;
        g_scroll_pos = new_pos;
        _ = ScrollWindow(hwnd, 0, delta, null, null);
        layoutControls(hwnd);
    }
}

fn scrollContent(hwnd: HWND, delta: i32) void {
    var si = SCROLLINFO{ .fMask = SIF_ALL };
    _ = GetScrollInfo(hwnd, SB_VERT, &si);

    var new_pos = g_scroll_pos + delta;
    const max_pos = si.nMax - @as(i32, @intCast(si.nPage));
    new_pos = @max(0, @min(new_pos, max_pos));

    if (new_pos != g_scroll_pos) {
        const scroll_delta = g_scroll_pos - new_pos;
        g_scroll_pos = new_pos;
        _ = ScrollWindow(hwnd, 0, scroll_delta, null, null);
        layoutControls(hwnd);
    }
}

fn playSound(index: u16) void {
    const bank = sound_banks[g_current_bank];
    if (index < bank.wavs.len) {
        const wav = bank.wavs[index];
        // stop any playing sound and play this one
        _ = PlaySoundA(wav.data.ptr, null, SND_MEMORY | SND_ASYNC);
    }
}

fn handleBankChange(hwnd: HWND) void {
    if (g_combobox) |combo| {
        const sel = SendMessageA(combo, CB_GETCURSEL, 0, 0);
        if (sel >= 0 and @as(usize, @intCast(sel)) < sound_banks.len) {
            g_current_bank = @intCast(sel);
            // reset scroll position when changing banks
            g_scroll_pos = 0;
            layoutControls(hwnd);
        }
    }
}

pub fn main() void {
    const hinstance = GetModuleHandleA(null);

    const wc = WNDCLASSEXA{
        .lpfnWndProc = wndProc,
        .hInstance = hinstance,
        .hCursor = LoadCursorA(null, IDC_ARROW),
        .hbrBackground = @ptrFromInt(COLOR_BTNFACE + 1),
        .lpszClassName = "WormboardClass",
    };

    if (RegisterClassExA(&wc) == 0) {
        return;
    }

    const hwnd = CreateWindowExA(
        0,
        "WormboardClass",
        "wormboard",
        WS_OVERLAPPEDWINDOW | WS_VISIBLE | WS_VSCROLL | WS_CLIPCHILDREN,
        CW_USEDEFAULT,
        CW_USEDEFAULT,
        600,
        400,
        null,
        null,
        hinstance,
        null,
    );

    if (hwnd == null) {
        return;
    }

    var msg: MSG = undefined;
    while (GetMessageA(&msg, null, 0, 0) != 0) {
        _ = TranslateMessage(&msg);
        _ = DispatchMessageA(&msg);
    }
}
