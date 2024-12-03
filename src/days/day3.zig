const std = @import("std");
pub const Day3 = struct {
    const test_input: [:0]const u8 = "xmul(2,4)mul( 2 , 4 )?(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))";
    const test_input_2: []const u8 = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))";

    pub fn solve(input: []const u8) !void {
        std.debug.print("Solving Day 1\n", .{});
        try solvePart1(input);
        try solvePart2(input);
    }
    fn resultOperations(input: []const u8) !u32 {
        const searchPattern = "mul(";
        var searchIdx: u32 = 0;
        var searchNumbers = false;
        var foundNumbers = [2]u32{ 0, 0 };
        var numIdx: u32 = 0;
        var total: u32 = 0;
        for (input) |token| {
            if (searchNumbers) {
                if (token == ',') {
                    numIdx += 1;
                    if (numIdx > 1) {
                        searchNumbers = false;
                        foundNumbers = [2]u32{ 0, 0 };
                        searchIdx = 0;
                        continue;
                    }
                } else if (token >= '0' and token <= '9') {
                    foundNumbers[numIdx] = foundNumbers[numIdx] * 10 + @as(u32, @intCast(token - '0'));
                } else if (token == ')' and numIdx == 1 and foundNumbers[0] >= 0 and foundNumbers[0] < 1000 and foundNumbers[1] >= 0 and foundNumbers[1] < 1000) {
                    total += foundNumbers[0] * foundNumbers[1];
                    searchNumbers = false;
                    foundNumbers = [2]u32{ 0, 0 };
                    searchIdx = 0;
                    continue;
                } else {
                    searchNumbers = false;
                    foundNumbers = [2]u32{ 0, 0 };
                    searchIdx = 0;
                    continue;
                }
            } else {
                if (token == searchPattern[searchIdx]) {
                    searchIdx += 1;
                } else {
                    searchIdx = 0;
                    continue;
                }

                if (searchIdx == searchPattern.len) {
                    searchNumbers = true;
                    foundNumbers = [2]u32{ 0, 0 };
                    numIdx = 0;
                }
            }
        }
        // var tok = std.zig.Tokenizer.init(test_input);
        // var toke = tok.next();
        // while (toke.tag != .eof) {
        //     tok.dump(&toke);
        //     toke = tok.next();
        // }
        // var total: u32 = 0;
        // mul: while (app.next()) |token| {
        // app.
        //     std.debug.print("token: {s}\n", .{token});
        //     var nums = std.mem.tokenizeAny(u8, token, ",");
        //     var list = std.ArrayList([]const u8).init(allocator);
        //     defer list.deinit();
        //
        //     while (nums.next()) |num| {
        //         try list.append(num);
        //     }
        //
        //     if (list.items.len != 2) {
        //         continue :mul;
        //     }
        //     const first = std.fmt.parseInt(u32, list.items[0], 10) catch continue :mul;
        //     const second = std.fmt.parseInt(u32, list.items[1], 10) catch continue :mul;
        //     std.debug.print("correct?: {s}\n", .{token});
        //     total += first * second;
        // }
        return total;
    }

    fn solvePart1(input: []const u8) !void {
        std.debug.print("Part 1\n", .{});

        const total_test: u32 = try resultOperations(test_input);
        std.debug.print("test: {d} \n", .{total_test});

        const total: u32 = try resultOperations(input);
        std.debug.print("answer: {d} \n", .{total});
    }

    fn solvePart2(input: []const u8) !void {
        std.debug.print("Part 2\n", .{});
        var idx: usize = 0;
        var total_test: u32 = 0;
        while (idx < test_input_2.len) {
            const dntidx = std.mem.indexOfPos(u8, test_input_2, idx, "don't()");
            if (dntidx != null) {
                total_test += try resultOperations(test_input_2[idx..dntidx.?]);
                const doidx = std.mem.indexOfPos(u8, test_input_2, dntidx.?, "do()");
                idx = doidx orelse break;
            } else {
                total_test += try resultOperations(test_input_2[idx..]);
                break;
            }
        }
        std.debug.print("test: {d} \n", .{total_test});

        idx = 0;

        var total: u32 = 0;
        while (idx < input.len) {
            const dntidx = std.mem.indexOfPos(u8, input, idx, "don't()");
            if (dntidx != null) {
                total += try resultOperations(input[idx..dntidx.?]);
                const doidx = std.mem.indexOfPos(u8, input, dntidx.?, "do()");
                idx = doidx orelse break;
            } else {
                total += try resultOperations(input[idx..]);
                break;
            }
        }
        std.debug.print("total: {d}\n", .{total});
    }
};
