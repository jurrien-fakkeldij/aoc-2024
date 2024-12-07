const std = @import("std");
const Retriever = @import("./retriever.zig").Retriever;
const Day1 = @import("./days/day1.zig").Day1;
const Day2 = @import("./days/day2.zig").Day2;
const Day3 = @import("./days/day3.zig").Day3;
const Day4 = @import("./days/day4.zig").Day4;
const Day5 = @import("./days/day5.zig").Day5;
const Day6 = @import("./days/day6.zig").Day6;
const Day7 = @import("./days/day7.zig").Day7;
const Day8 = @import("./days/day8.zig").Day8;

pub const Solver = struct {
    pub fn solve(allocator: std.mem.Allocator, day: u32) !void {
        switch (day) {
            0 => {
                std.debug.print("Solving all days\n", .{});
                for (1..25) |curDay| {
                    try solve(allocator, @intCast(curDay));
                }
            },
            1 => {
                const input = try Retriever.get(allocator, day);
                defer allocator.free(input);
                try Day1.solve(input);
            },
            2 => {
                const input = try Retriever.get(allocator, day);
                defer allocator.free(input);
                try Day2.solve(input);
            },
            3 => {
                const input = try Retriever.get(allocator, day);
                defer allocator.free(input);
                try Day3.solve(input);
            },
            4 => {
                const input = try Retriever.get(allocator, day);
                defer allocator.free(input);
                try Day4.solve(input);
            },
            5 => {
                const input = try Retriever.get(allocator, day);
                defer allocator.free(input);
                try Day5.solve(input);
            },
            6 => {
                const input = try Retriever.get(allocator, day);
                defer allocator.free(input);
                try Day6.solve(input);
            },
            7 => {
                const input = try Retriever.get(allocator, day);
                defer allocator.free(input);
                try Day7.solve(input);
            },
            8 => {
                const input = try Retriever.get(allocator, day);
                defer allocator.free(input);
                try Day8.solve(input);
            },
            else => std.debug.print("Did not find the specified day to solve yet. Day {d} is not solvable yet, has this day already come out or did my creator (slacker) did not create the solution yet.\n", .{day}),
        }
    }
};
