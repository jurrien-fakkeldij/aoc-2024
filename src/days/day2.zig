const std = @import("std");
pub const Day2 = struct {
    const test_input: []const u8 =
        \\7 6 4 2 1
        \\1 2 7 8 9
        \\9 7 6 2 1
        \\1 3 2 4 5
        \\8 6 4 4 1
        \\1 3 6 7 9
    ;

    pub fn solve(input: []const u8) !void {
        std.debug.print("Solving Day 2\n", .{});
        try solvePart1(input);
        try solvePart2(input);
    }

    fn solvePart1(input: []const u8) !void {
        std.debug.print("Part 1\n", .{});
        const total_test = try safeReports(test_input);
        std.debug.print("test: {d} \n", .{total_test});

        const total = try safeReports(input);
        std.debug.print("answer: {d} \n", .{total});
    }

    fn safeReports(input: []const u8) !u32 {
        var tokens = std.mem.tokenizeAny(u8, input, "\n");

        var numSafeReports: u32 = 0;
        lines: while (tokens.next()) |token| {
            var reports = std.mem.tokenizeAny(u8, token, " ");
            var increasing = false;
            var decreasing = false;
            var idx: u32 = 0;
            while (reports.next()) |report| {
                if (reports.peek() == null) {
                    numSafeReports += 1;
                } else {
                    const num = try std.fmt.parseInt(i32, report, 10);
                    const peek_num = try std.fmt.parseInt(i32, reports.peek().?, 10);
                    if (num < peek_num) {
                        if (idx == 0) {
                            increasing = true;
                            decreasing = false;
                        }
                        if (decreasing) {
                            continue :lines;
                        }

                        if (@abs(num - peek_num) > 3) {
                            continue :lines;
                        }
                    } else if (num > peek_num) {
                        if (idx == 0) {
                            increasing = false;
                            decreasing = true;
                        }
                        if (increasing) {
                            continue :lines;
                        }

                        if (@abs(num - peek_num) > 3) {
                            continue :lines;
                        }
                    } else {
                        continue :lines;
                    }
                    idx += 1;
                }
            }

            // std.debug.print("line: {s} total:{d}\n", .{ token, total_test });
        }
        return numSafeReports;
    }

    fn solvePart2(input: []const u8) !void {
        std.debug.print("Part 2\n", .{});

        const total_test: u32 = try safeReportsWithDampener(test_input);
        std.debug.print("test: {d} \n", .{total_test});

        const total: u32 = try safeReportsWithDampener(input);
        std.debug.print("answer: {d} \n", .{total});
    }

    fn safeReportsWithDampener(input: []const u8) !u32 {
        var tokens = std.mem.tokenizeAny(u8, input, "\n");

        var numSafeReports: u32 = 0;
        lines: while (tokens.next()) |token| {
            var reports = std.mem.tokenizeAny(u8, token, " ");
            var increasing = false;
            var decreasing = false;
            var idx: u32 = 0;
            var faults: u32 = 0;
            var previousNumber: i32 = 0;
            while (reports.next()) |report| {
                if (reports.peek() == null) {
                    numSafeReports += 1;
                } else {
                    const num = try std.fmt.parseInt(i32, report, 10);
                    const peek_num = try std.fmt.parseInt(i32, reports.peek().?, 10);
                    if (idx == 0) {
                        if (num < peek_num) {
                            increasing = true;
                            decreasing = false;
                            if (@abs(num - peek_num) > 3 and faults == 1) {
                                continue :lines;
                            } else if (@abs(num - peek_num) > 3) {
                                faults += 1;
                                previousNumber = num;
                                idx += 1;
                                continue;
                            }
                        } else if (num > peek_num) {
                            increasing = false;
                            decreasing = true;
                            if (@abs(num - peek_num) > 3 and faults == 1) {
                                continue :lines;
                            } else if (@abs(num - peek_num) > 3) {
                                faults += 1;
                                previousNumber = num;
                                idx += 1;
                                continue;
                            }
                        } else {
                            if (faults == 1) {
                                continue :lines;
                            } else {
                                faults += 1;
                                previousNumber = num;
                                idx += 1;
                                continue;
                            }
                        }
                        previousNumber = peek_num;
                        idx += 1;
                        continue;
                    }

                    if (previousNumber < peek_num) {
                        if (decreasing and faults == 1) {
                            continue :lines;
                        } else if (decreasing) {
                            previousNumber = num;
                            faults += 1;
                            idx += 1;
                            continue;
                        }

                        if (@abs(previousNumber - peek_num) > 3 and faults == 1) {
                            continue :lines;
                        } else if (@abs(previousNumber - peek_num) > 3) {
                            faults += 1;
                            previousNumber = num;
                            idx += 1;
                            continue;
                        }
                    } else if (previousNumber > peek_num) {
                        if (increasing and faults == 1) {
                            continue :lines;
                        } else if (increasing) {
                            faults += 1;
                            previousNumber = num;
                            idx += 1;
                            continue;
                        }

                        if (@abs(previousNumber - peek_num) > 3 and faults == 1) {
                            continue :lines;
                        } else if (@abs(previousNumber - peek_num) > 3) {
                            faults += 1;
                            previousNumber = num;
                            idx += 1;
                            continue;
                        }
                    } else {
                        if (faults == 1) {
                            continue :lines;
                        } else {
                            faults += 1;
                            previousNumber = num;
                            idx += 1;
                            continue;
                        }
                    }
                    previousNumber = peek_num;
                    idx += 1;
                }
            }

            // std.debug.print("line: {s} total:{d}\n", .{ token, numSafeReports });
        }
        return numSafeReports;
    }
};
