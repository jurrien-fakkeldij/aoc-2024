const std = @import("std");
const Retriever = @import("./retriever.zig").Retriever;
const Day1 = @import("./days/day1.zig").Day1;

pub const Solver = struct {
    pub fn solve(allocator: std.mem.Allocator, day: u32) !void {
        switch (day) {
            1 => {
                const input = try Retriever.get(allocator, day);
                defer allocator.free(input);
                try Day1.solve(input);
            },
            else => std.debug.print("Did not find the specified day to solve yet. Day {d} is not solvable yet, has this day already come out or did my creator (slacker) did not create the solution yet.\n", .{day}),
        }
    }
};
