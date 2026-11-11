const std = @import("std");
const mem = std.mem;
const testing = std.testing;

pub const USAGE =
    \\ brainfucker <file>
    \\
    \\ Options:
    \\ --help, -h: Print this help screen
;

/// Represents a parsed collection of CLI arguments for post-processing
pub const Options = struct {
    /// Set when --help or -h is passed, main prints the help screen and exits
    /// before doing anything else if this flag is passed.
    help: bool = false,

    /// Represents the positional arguments for the CLI. We do not need more
    /// than 3 in the entire program's lifecycle AFAIK.
    positionals: [3][]const u8 = undefined,

    /// Counter for positional arguments, used for safety/correct operations.
    positional_count: usize = 0,
};

/// Receives the process CLI arguments passed by the shell and serializes them
/// into the `Options` structure.
///
/// Note: Positional args are stored using a fixed inline buffer inside the
/// `Options` struct. This avoids the need for dynamic memory allocation and a
/// corresponding deinit lifecycle. For standard CLI usage, an arbitrary limit
/// like 3 simplifies memory management significantly...for me at least.
pub fn parseFlags(args: []const []const u8) !Options {
    var opts = Options{};
    var i: usize = 0;

    if (args.len == 0) {
        opts.help = true;
    }

    while (i < args.len) : (i += 1) {
        const arg: []const u8 = args[i];

        if (mem.eql(u8, arg, "--help") or mem.eql(
            u8,
            arg,
            "-h",
        )) {
            opts.help = true;
        } else if (arg.len > 0 and arg[0] == '-') {
            return error.UnknownOption;
        } else {
            // Unrecognized flags or regular values are treated as positional
            // arguments
            if (opts.positional_count >= opts.positionals.len) {
                return error.TooManyPositionalArguments;
            }

            opts.positionals[opts.positional_count] = arg;
            opts.positional_count += 1;
        }
    }

    return opts;
}

// Tests begin here

test "no args should redirect to --help" {
    const args: []const []const u8 = &[_][]const u8{};
    const opts = try parseFlags(args);

    try testing.expectEqual(0, opts.positional_count);
    try testing.expectEqual(true, opts.help);
}

test "parseFlags should return the correct structure for --help" {
    const args: []const []const u8 = &[_][]const u8{"--help"};
    const opts = try parseFlags(args);

    try testing.expectEqual(0, opts.positional_count);
    try testing.expectEqual(true, opts.help);
}

test "parseFlags should return the correct structure for -h" {
    const args: []const []const u8 = &[_][]const u8{"-h"};
    const opts = try parseFlags(args);

    try testing.expectEqual(0, opts.positional_count);
    try testing.expectEqual(true, opts.help);
}
