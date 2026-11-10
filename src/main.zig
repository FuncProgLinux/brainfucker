const std = @import("std");
const mem = std.mem;
const Allocator = mem.Allocator;

pub fn main(init: std.process.Init) !void {
    const minimal = init.minimal;
    const arena: Allocator = init.arena.allocator();
}
