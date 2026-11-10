const std = @import("std");

const OpCode = enum {
    /// Increases the value of the current cell.
    /// Used for values: + and -
    add,
    /// Moves the memory pointer to another cell.
    /// Used for values: < and >
    move,
    /// Prints the actual cell byte.
    /// Used for values: .
    print,
    /// Reads a byte.
    /// Used for values: ,
    read,
    /// Jumps if the cell is 0
    /// Used for values: [
    jump_zero,
    /// Jumps if the cell is NOT 0
    /// Used for values: ]
    jump_not_zero,
};

/// Represents an instruction as a whole. It receives an `OpCode` and also a
/// descriptive `arg` to allow us to perform peephole optimizations.
const BFInstruction = struct {
    op: OpCode,
    arg: i32,
};
