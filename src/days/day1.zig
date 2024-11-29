const std = @import("std");
pub const Day1 = struct {
    const test_input =
        \\Test Input
    ;

    pub fn solve(input: []const u8) void {
        std.debug.print("Solving Day 1\n", .{});
        solvePart1(input);
        solvePart2(input);
    }

    fn solvePart1(input: []const u8) void {
        std.debug.print("Part 1\n", .{});
        std.debug.print("input: {s}\n", .{input});
    }

    fn solvePart2(input: []const u8) void {
        std.debug.print("Part 2\n", .{});
        std.debug.print("input: {s}\n", .{input});
    }
};
