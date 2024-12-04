const std = @import("std");
const Point = struct { x: i32, y: i32 };
const Vector = struct { x: i32, y: i32 };
pub const Day4 = struct {
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
        std.debug.print("Solving Day 4\n", .{});
        try solvePart1(input);
        try solvePart2(input);
    }

    fn solvePart1(input: []const u8) !void {
        std.debug.print("Part 1\n", .{});
        const total_test = try findXMAS(test_input);
        std.debug.print("test: {d} \n", .{total_test});

        const total = try findXMAS(input);
        std.debug.print("answer: {d} \n", .{total});
    }

    fn solvePart2(input: []const u8) !void {
        std.debug.print("Part 2\n", .{});

        const total_test: u32 = try findMASX(test_input);
        std.debug.print("test: {d} \n", .{total_test});

        const total: u32 = try findMASX(input);
        std.debug.print("answer: {d} \n", .{total});
    }

    fn findMASX(input: []const u8) !u32 {
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        const allocator = gpa.allocator();
        defer _ = gpa.deinit();

        var locations = std.AutoHashMap(Point, u8).init(allocator);
        defer locations.deinit();

        var tokens = std.mem.tokenizeAny(u8, input, " \n");
        var row: i32 = 0;
        while (tokens.next()) |line| {
            var col: i32 = 0;
            for (line) |ch| {
                try locations.put(Point{ .x = col, .y = row }, ch);
                col += 1;
            }
            row += 1;
        }

        var total: u32 = 0;
        var locIt = locations.keyIterator();
        var patternIdx: i32 = 0;
        next: while (locIt.next()) |location| {
            // std.debug.print("Checking position: {} -> {c}\n", .{ location.*, locations.get(location.*).? });
            patternIdx = 1;
            if (locations.get(location.*) == 'A') {
                const searchDirections = [4]Vector{ Vector{ .x = -1, .y = -1 }, Vector{ .x = 1, .y = 1 }, Vector{ .x = 1, .y = -1 }, Vector{ .x = -1, .y = 1 } };

                for (searchDirections) |direction| {
                    switch (locations.get(.{ .x = location.x + direction.x, .y = location.y + direction.y }) orelse continue) {
                        'M' => {
                            if (locations.get(.{ .x = location.x - direction.x, .y = location.y - direction.y }) != 'S') {
                                continue :next;
                            }
                        },
                        'S' => {
                            if (locations.get(.{ .x = location.x - direction.x, .y = location.y - direction.y }) != 'M') {
                                continue :next;
                            }
                        },
                        else => {
                            continue :next;
                        },
                    }
                }
                total += 1;
            }
        }
        return total;
    }
    fn findXMAS(input: []const u8) !u32 {
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        const allocator = gpa.allocator();
        defer _ = gpa.deinit();

        var locations = std.AutoHashMap(Point, u8).init(allocator);
        defer locations.deinit();

        var tokens = std.mem.tokenizeAny(u8, input, " \n");
        var row: i32 = 0;
        while (tokens.next()) |line| {
            var col: i32 = 0;
            for (line) |ch| {
                try locations.put(Point{ .x = col, .y = row }, ch);
                col += 1;
            }
            row += 1;
        }
        const pattern = "XMAS";
        var total: u32 = 0;
        var locIt = locations.keyIterator();
        var patternIdx: i32 = 0;
        var direction = Vector{ .x = 0, .y = 0 };
        while (locIt.next()) |location| {
            // std.debug.print("Checking position: {} -> {c}\n", .{ location.*, locations.get(location.*).? });
            patternIdx = 0;
            if (locations.get(location.*) == pattern[@as(usize, @intCast(patternIdx))]) {
                //find all directions next.
                // std.debug.print("Found X: {}\n", .{location.*});
                patternIdx = 1;
                var xDir: i32 = -1;
                var yDir: i32 = -1;
                while (xDir < 2) {
                    next: while (yDir < 2) {
                        // std.debug.print("checking: {d},{d} want {c} at idx {d} find {}\n", .{ location.x + xDir, location.y + yDir, pattern[@intCast(patternIdx)], patternIdx, locations.get(.{ .x = location.x + xDir, .y = location.y + yDir }) == pattern[@intCast(patternIdx)] });
                        if (xDir == 0 and yDir == 0) {
                            yDir += 1;
                            continue;
                        }

                        if (locations.get(.{ .x = location.x + xDir, .y = location.y + yDir }) == pattern[@as(usize, @intCast(patternIdx))]) {
                            // std.debug.print("possible direction {d},{d}\n", .{ xDir, yDir });
                            //found possible direction.
                            // std.debug.print("Found M: {}, {}\n", .{ location.x + xDir, location.y + yDir });
                            direction.x = xDir;
                            direction.y = yDir;
                            patternIdx += 1;
                            while (patternIdx < pattern.len) {
                                if (locations.get(.{ .x = location.x + (xDir * patternIdx), .y = location.y + (yDir * patternIdx) }) != pattern[@as(usize, @intCast(patternIdx))]) {
                                    direction.x = 0;
                                    direction.y = 0;
                                    patternIdx = 1;
                                    yDir += 1;
                                    continue :next;
                                }
                                // std.debug.print("Found next {c} : {}\n", .{ pattern[@intCast(patternIdx)], .{ .x = location.x + (xDir * patternIdx), .y = location.x + (yDir * patternIdx) } });
                                patternIdx += 1;
                            }
                            // std.debug.print("end of while should be good: {d},{d} : {d},{d}\n", .{ location.x, location.y, location.x + (xDir * patternIdx), location.y + (yDir * patternIdx) });
                            total += 1;
                            patternIdx = 1;
                        }
                        yDir += 1;
                    }
                    yDir = -1;
                    xDir += 1;
                }
            }
        }
        return total;
    }
};
