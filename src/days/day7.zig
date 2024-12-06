const std = @import("std");
pub const Day7 = struct {
    const test_input: []const u8 =
        \\....#.....
        \\.........#
        \\..........
        \\..#.......
        \\.......#..
        \\..........
        \\.#..^.....
        \\........#.
        \\#.........
        \\......#...
    ;

    pub fn solve(input: []const u8) !void {
        std.debug.print("Solving Day 7\n", .{});
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
