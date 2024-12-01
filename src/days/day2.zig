const std = @import("std");
pub const Day2 = struct {
    const test_input: [:0]const u8 =
        \\3   4
        \\4   3
        \\2   5
        \\1   3
        \\3   9
        \\3   3
    ;

    pub fn solve(input: []const u8) !void {
        std.debug.print("Solving Day 2\n", .{});
        try solvePart1(input);
        try solvePart2(input);
    }

    fn solvePart1(_: []const u8) !void {
        std.debug.print("Part 1\n", .{});

        const total_test: u32 = 0;
        std.debug.print("test: {d} \n", .{total_test});

        const total: u32 = 0;
        std.debug.print("answer: {d} \n", .{total});
    }

    fn solvePart2(_: []const u8) !void {
        std.debug.print("Part 2\n", .{});

        const total_test: u32 = 0;
        std.debug.print("test: {d} \n", .{total_test});

        const total: u32 = 0;
        std.debug.print("answer: {d} \n", .{total});
    }
};
