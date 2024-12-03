const std = @import("std");
const Retriever = @import("./retriever.zig").Retriever;
const Day1 = @import("./days/day1.zig").Day1;
const Day2 = @import("./days/day2.zig").Day2;
const Day3 = @import("./days/day3.zig").Day3;
const Day4 = @import("./days/day4.zig").Day4;

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
            else => std.debug.print("Did not find the specified day to solve yet. Day {d} is not solvable yet, has this day already come out or did my creator (slacker) did not create the solution yet.\n", .{day}),
        }
    }
};
