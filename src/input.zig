const win32 = @import("win32.zig");

// keyboard mapping: 1-9, 0, then QWERTY order
// virtual key codes: '0'-'9' = 0x30-0x39, 'A'-'Z' = 0x41-0x5A
pub const QWERTY_KEYS = "QWERTYUIOPASDFGHJKLZXCVBNM";

pub fn keyToSoundIndex(vk: u32) ?u16 {
    // number keys: 1-9 -> 0-8, 0 -> 9
    if (vk >= '1' and vk <= '9') return @intCast(vk - '1');
    if (vk == '0') return 9;

    // letter keys: QWERTY order -> 10+
    for (QWERTY_KEYS, 0..) |key, i| {
        if (vk == key) return @intCast(10 + i);
    }
    return null;
}

// navigation constants
pub const BANKS_PER_PAGE: i32 = 13;

// calculate nav target from key press
pub fn getNavTarget(vk: u32, current_bank: usize, num_banks: usize) ?usize {
    if (num_banks == 0) return null;

    const base: i32 = @intCast(current_bank);
    const num: i32 = @intCast(num_banks);

    const target: i32 = switch (vk) {
        win32.VK_UP => base - 1,
        win32.VK_DOWN => base + 1,
        win32.VK_PRIOR => base - BANKS_PER_PAGE,
        win32.VK_NEXT => base + BANKS_PER_PAGE,
        win32.VK_HOME => 0,
        win32.VK_END => num - 1,
        else => return null,
    };

    // wrap around
    return @intCast(@mod(target, num));
}

pub fn isNavKey(vk: u32) bool {
    return switch (vk) {
        win32.VK_UP, win32.VK_DOWN, win32.VK_PRIOR, win32.VK_NEXT, win32.VK_HOME, win32.VK_END => true,
        else => false,
    };
}
