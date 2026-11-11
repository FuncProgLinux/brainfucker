const std = @import("std");
const cli = @import("cli.zig");

const mem = std.mem;
const Io = std.Io;
const Allocator = mem.Allocator;

pub fn main(init: std.process.Init) !void {
    const minimal = init.minimal;
    const arena: Allocator = init.arena.allocator();

    const io = init.io;
    var stdout_buffer: [2048]u8 = undefined;
    var stdout_file_writer: Io.File.Writer = .init(
        .stdout(),
        io,
        &stdout_buffer,
    );

    const stdout = &stdout_file_writer.interface;

    const args = (try minimal.args.toSlice(arena))[1..];
    const opts = try cli.parseFlags(args);

    if (opts.help) {
        try stdout.print("{s}\n", .{cli.USAGE});
        try stdout.flush();
        return;
    }
}

// Tests begin here
test {
    _ = cli;
}
