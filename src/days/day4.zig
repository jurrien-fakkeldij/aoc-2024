const std = @import("std");
pub const Day4 = struct {
    const test_input: []const u8 =
        \\7 6 4 2 1
        \\1 2 7 8 9
        \\9 7 6 2 1
        \\1 3 2 4 5
        \\8 6 4 4 1
        \\1 3 6 7 9
    ;

    pub fn solve(input: []const u8) !void {
        std.debug.print("Solving Day 4\n", .{});
        try solvePart1(input);
        try solvePart2(input);
    }

    fn solvePart1(_: []const u8) !void {
        std.debug.print("Part 1\n", .{});
        const total_test = 0;
        std.debug.print("test: {d} \n", .{total_test});

        const total = 0;
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
