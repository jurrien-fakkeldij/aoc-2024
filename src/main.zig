//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.
const std = @import("std");
const http = std.http;

const Solver = @import("solver.zig").Solver;

pub fn main() !void {
    // Create a general purpose allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    // Parse args into string array (error union needs 'try')
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    // Get and print them!
    // std.debug.print("There are {d} args:\n", .{args.len});
    var nextIsDay = false;
    var day: u32 = 0;
    for (args) |arg| {
        if (std.mem.eql(u8, arg, "--day")) {
            nextIsDay = true;
            continue;
        }

        if (nextIsDay) {
            day = try std.fmt.parseInt(u32, arg, 10);
            // std.debug.print("  Trying to retrieve day: {d}\n", .{day});
        }
    }

    try Solver.solve(allocator, day);
}
