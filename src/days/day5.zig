const std = @import("std");
const OrderingRule = struct { before: u32, after: u32 };
pub const Day5 = struct {
    const test_input: []const u8 =
        \\47|53
        \\97|13
        \\97|61
        \\97|47
        \\75|29
        \\61|13
        \\75|53
        \\29|13
        \\97|29
        \\53|29
        \\61|53
        \\97|53
        \\61|29
        \\47|13
        \\75|47
        \\97|75
        \\47|61
        \\75|61
        \\47|29
        \\75|13
        \\53|13
        \\
        \\75,47,61,53,29
        \\97,61,53,29,13
        \\75,29,13
        \\75,97,47,61,53
        \\61,13,29
        \\97,13,75,29,47
    ;

    pub fn solve(input: []const u8) !void {
        std.debug.print("Solving Day 5\n", .{});
        try solvePart1(input);
        try solvePart2(input);
    }

    fn sumMiddleCorrectUpdates(input: []const u8) !u32 {
        var sum: u32 = 0;
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        const allocator = gpa.allocator();
        defer _ = gpa.deinit();

        var rules = std.ArrayList(OrderingRule).init(allocator);
        defer rules.deinit();

        var manual = std.ArrayList(std.ArrayList(u32)).init(allocator);
        defer manual.deinit();

        var tokens = std.mem.tokenizeAny(u8, input, "\n");
        while (tokens.next()) |token| {
            if (std.mem.containsAtLeast(u8, token, 1, "|")) {
                var split = std.mem.splitAny(u8, token, "|");
                try rules.append(OrderingRule{ .before = try std.fmt.parseInt(u32, split.next().?, 10), .after = try std.fmt.parseInt(u32, split.peek().?, 10) });
            } else {
                var split = std.mem.splitAny(u8, token, ",");

                var pages = std.ArrayList(u32).init(allocator);
                while (split.next()) |num| {
                    try pages.append(try std.fmt.parseInt(u32, num, 10));
                }
                try manual.append(pages);
            }
        }

        nextUpdates: for (manual.items) |pages| {
            // std.debug.print("checking pages: {d}\n", .{pages.items});
            for (0.., pages.items) |index, page| {
                for (rules.items) |rule| {
                    if (rule.before == page) {
                        if (index == 0) {
                            continue;
                        }
                        var curPos: isize = @as(isize, @intCast(index)) - 1;
                        while (curPos >= 0) : (curPos -= 1) {
                            const idx = @as(usize, @intCast(curPos));
                            if (pages.items[idx] == rule.after) {
                                continue :nextUpdates;
                            }
                        }
                    } else if (rule.after == page) {
                        if (index == (pages.items.len - 1)) {
                            continue;
                        }
                        for (index..(pages.items.len - 1)) |idx| {
                            if (pages.items[idx] == rule.before) {
                                continue :nextUpdates;
                            }
                        }
                    }
                }
            }
            // std.debug.print("all rules passed: {d}\n", .{pages.items});
            const middle = pages.items.len / 2;
            // std.debug.print("taking middle {d}, val: {d}", .{ middle, pages.items[middle] });
            sum += pages.items[middle];
        }

        for (manual.items) |item| {
            item.deinit();
        }
        return sum;
    }

    fn solvePart1(input: []const u8) !void {
        std.debug.print("Part 1\n", .{});
        const total_test = try sumMiddleCorrectUpdates(test_input);
        std.debug.print("test: {d} \n", .{total_test});

        const total = try sumMiddleCorrectUpdates(input);
        std.debug.print("answer: {d} \n", .{total});
    }

    fn solvePart2(input: []const u8) !void {
        std.debug.print("Part 2\n", .{});

        const total_test: u32 = try fixAndSumFaulty(test_input);
        std.debug.print("test: {d} \n", .{total_test});

        const total: u32 = try fixAndSumFaulty(input);
        std.debug.print("answer: {d} \n", .{total});
    }

    fn fixAndSumFaulty(input: []const u8) !u32 {
        var sum: u32 = 0;
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        const allocator = gpa.allocator();
        defer _ = gpa.deinit();

        var rules = std.ArrayList(OrderingRule).init(allocator);
        defer rules.deinit();

        var manual = std.ArrayList(std.ArrayList(u32)).init(allocator);
        defer manual.deinit();

        var tokens = std.mem.tokenizeAny(u8, input, "\n");
        while (tokens.next()) |token| {
            if (std.mem.containsAtLeast(u8, token, 1, "|")) {
                var split = std.mem.splitAny(u8, token, "|");
                try rules.append(OrderingRule{ .before = try std.fmt.parseInt(u32, split.next().?, 10), .after = try std.fmt.parseInt(u32, split.peek().?, 10) });
            } else {
                var split = std.mem.splitAny(u8, token, ",");

                var pages = std.ArrayList(u32).init(allocator);
                while (split.next()) |num| {
                    try pages.append(try std.fmt.parseInt(u32, num, 10));
                }
                try manual.append(pages);
            }
        }
        var fixed: bool = false;
        for (manual.items) |pages| {
            // std.debug.print("checking pages: {d}\n", .{pages.items});
            var index: usize = 0;
            nextPage: while (index < pages.items.len) : (index += 1) {
                const page = pages.items[index];
                // std.debug.print("checking index: {d}\n", .{index});
                for (rules.items) |rule| {
                    if (rule.before == page) {
                        // std.debug.print("Found rule.before: {} for page: {d}\n", .{ rule, page });
                        if (index == 0) {
                            continue;
                        }
                        var curPos: isize = @as(isize, @intCast(index)) - 1;
                        while (curPos >= 0) : (curPos -= 1) {
                            const idx = @as(usize, @intCast(curPos));
                            if (pages.items[idx] == rule.after) {
                                //fix
                                // std.debug.print("item == rule.after: {d}\n", .{pages.items[idx]});
                                pages.items[idx] = rule.before;
                                pages.items[index] = rule.after;
                                fixed = true;
                                if (index != 0) {
                                    index -= 1;
                                }
                                // std.debug.print("fixed to {d} using {}\n", .{ pages.items, rule });
                                continue :nextPage;
                            }
                        }
                    } else if (rule.after == page) {
                        // std.debug.print("Found rule.after: {} for page: {d}\n", .{ rule, page });
                        if (index == (pages.items.len - 1)) {
                            continue;
                        }
                        for (index..(pages.items.len)) |idx| {
                            if (pages.items[idx] == rule.before) {
                                pages.items[idx] = rule.after;
                                pages.items[index] = rule.before;
                                fixed = true;
                                if (index != 0) {
                                    index -= 1;
                                }
                                // std.debug.print("fixed to {d} using {}\n", .{ pages.items, rule });
                                continue :nextPage;
                            }
                        }
                    }
                }
            }
            if (fixed) {
                // std.debug.print("fixed rules passed: {d}\n", .{pages.items});
                const middle = pages.items.len / 2;
                // std.debug.print("taking middle {d}, val: {d}", .{ middle, pages.items[middle] });
                sum += pages.items[middle];
                fixed = false;
            }
        }

        for (manual.items) |item| {
            item.deinit();
        }
        return sum;
    }
};
