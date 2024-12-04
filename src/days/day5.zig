const std = @import("std");
const Point = struct { x: i32, y: i32 };
const Vector = struct { x: i32, y: i32 };
pub const Day5 = struct {
    const test_input: []const u8 =
        \\MMMSXXMASM
        \\MSAMXMSMSA
        \\AMXSXMAAMM
        \\MSAMASMSMX
        \\XMASAMXAMM
        \\XXAMMXXAMA
        \\SMSMSASXSS
        \\SAXAMASAAA
        \\MAMMMXMMMM
        \\MXMXAXMASX
    ;

    pub fn solve(input: []const u8) !void {
        std.debug.print("Solving Day 5\n", .{});
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
