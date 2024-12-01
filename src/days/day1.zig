const std = @import("std");
pub const Day1 = struct {
    const test_input: [:0]const u8 =
        \\3   4
        \\4   3
        \\2   5
        \\1   3
        \\3   9
        \\3   3
    ;

    pub fn solve(input: [:0]const u8) !void {
        std.debug.print("Solving Day 1\n", .{});
        try solvePart1(input);
        try solvePart2(input);
    }

    fn solvePart1(input: [:0]const u8) !void {
        std.debug.print("Part 1\n", .{});

        const total_test: u32 = try findDistance(test_input);
        std.debug.print("test: {d} \n", .{total_test});

        const total: u32 = try findDistance(input);
        std.debug.print("answer: {d} \n", .{total});
    }

    fn findDistance(input: [:0]const u8) !u32 {
        var tokens = std.mem.tokenizeAny(u8, input, " \n");

        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        const allocator = gpa.allocator();
        defer _ = gpa.deinit();

        var left = std.ArrayList(i32).init(allocator);
        var right = std.ArrayList(i32).init(allocator);
        defer left.deinit();
        defer right.deinit();

        while (tokens.next()) |token| {
            var num = try std.fmt.parseInt(i32, token, 10);
            try left.append(num);
            num = try std.fmt.parseInt(i32, tokens.next().?, 10);
            try right.append(num);
        }
        std.mem.sort(i32, left.items, {}, std.sort.asc(i32));
        std.mem.sort(i32, right.items, {}, std.sort.asc(i32));

        // std.debug.print("{d} {d}\n", .{ left.items, right.items });
        var total: u32 = 0;
        for (left.items, 0..) |value, i| {
            // std.debug.print("comparing {d} -> {d}\n", .{ value, right.items[i] });
            const dist: i32 = right.items[i] - value;
            total += @abs(dist);
        }

        return total;
    }

    fn findSimilarityScore(input: [:0]const u8) !i32 {
        var tokens = std.mem.tokenizeAny(u8, input, " \n");

        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        const allocator = gpa.allocator();
        defer _ = gpa.deinit();

        var left = std.ArrayList(i32).init(allocator);
        var right = std.AutoHashMap(i32, i32).init(allocator);
        defer left.deinit();
        defer right.deinit();

        while (tokens.next()) |token| {
            var num = try std.fmt.parseInt(i32, token, 10);
            try left.append(num);

            num = try std.fmt.parseInt(i32, tokens.next().?, 10);
            if (right.contains(num)) {
                try right.put(num, right.get(num).? + 1);
            } else try right.put(num, 1);
        }
        var total_score: i32 = 0;
        for (left.items) |num| {
            const similarityScore = if (right.contains(num)) num * right.get(num).? else 0;
            total_score += similarityScore;
        }

        return total_score;
    }

    fn solvePart2(input: [:0]const u8) !void {
        std.debug.print("Part 2\n", .{});
        const total_test: i32 = try findSimilarityScore(test_input);
        std.debug.print("test: {d} \n", .{total_test});

        const total: i32 = try findSimilarityScore(input);
        std.debug.print("answer: {d} \n", .{total});
    }
};
