const std = @import("std");
const Calibration = struct {
    outcome: i64,
    numbers: []i64,
    pub fn isPossible(self: Calibration, withExtraCheck: bool) bool {
        if (withExtraCheck) {
            return isEqualWithConcat(self.outcome, 0, self.numbers);
        }
        return isEqual(self.outcome, self.numbers, withExtraCheck);
    }

    fn isEqual(outcome: i64, numbers: []i64, withExtraCheck: bool) bool {
        if (numbers.len == 1) {
            return outcome == numbers[0];
        }
        const i: usize = numbers.len - 1;

        const division = std.math.divExact(i64, outcome, numbers[i]) catch {
            return isEqual(outcome - numbers[i], numbers[0..i], withExtraCheck);
        };
        return isEqual(outcome - numbers[i], numbers[0..i], withExtraCheck) or isEqual(division, numbers[0..i], withExtraCheck);
    }
    fn isEqualWithConcat(outcome: i64, acc: i64, numbers: []i64) bool {
        if (numbers.len == 1) {
            const con = concatNumbers(acc, numbers[0]) catch {
                return false;
            };
            return outcome == acc + numbers[0] or outcome == acc * numbers[0] or outcome == con;
        }
        const con = concatNumbers(acc, numbers[0]) catch {
            return false;
        };
        return isEqualWithConcat(outcome, acc + numbers[0], numbers[1..]) or isEqualWithConcat(outcome, acc * numbers[0], numbers[1..]) or isEqualWithConcat(outcome, con, numbers[1..]);
    }

    fn concatNumbers(first: i64, second: i64) !i64 {
        var buf: [20]u8 = undefined;
        var buf2: [20]u8 = undefined;
        _ = try std.fmt.bufPrint(&buf, "{}", .{first});
        _ = try std.fmt.bufPrint(&buf2, "{}", .{second});
        var result: [buf.len + buf2.len]u8 = undefined;
        std.mem.copyForwards(u8, result[0..], &buf);
        std.mem.copyForwards(u8, result[buf.len..], &buf2);

        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        const allocator = gpa.allocator();
        defer _ = gpa.deinit();
        var list = std.ArrayList(u8).init(allocator);
        defer list.deinit();
        for (result) |ch| {
            if (ch != 170) {
                try list.append(ch);
            }
        }

        const mergedNumber = try std.fmt.parseInt(i64, list.items, 10);
        return mergedNumber;
    }
};
pub const Day7 = struct {
    const test_input: []const u8 =
        \\190: 10 19
        \\3267: 81 40 27
        \\83: 17 5
        \\156: 15 6
        \\7290: 6 8 6 15
        \\161011: 16 10 13
        \\192: 17 8 14
        \\21037: 9 7 18 13
        \\292: 11 6 16 20
    ;

    pub fn solve(input: []const u8) !void {
        std.debug.print("Solving Day 7\n", .{});
        try solvePart1(input);
        try solvePart2(input);
    }

    fn solvePart1(input: []const u8) !void {
        std.debug.print("Part 1\n", .{});
        const total_test = try totalCalibrationResult(test_input, false);
        std.debug.print("test: {d} \n", .{total_test});

        const total = try totalCalibrationResult(input, false);
        std.debug.print("answer: {d} \n", .{total});
    }

    fn solvePart2(input: []const u8) !void {
        std.debug.print("Part 2\n", .{});

        const total_test = try totalCalibrationResult(test_input, true);
        std.debug.print("test: {d} \n", .{total_test});

        const total = try totalCalibrationResult(input, true);
        std.debug.print("answer: {d} \n", .{total});
    }

    fn totalCalibrationResult(input: []const u8, extraCheck: bool) !i64 {
        var sum: i64 = 0;
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        const allocator = gpa.allocator();
        defer _ = gpa.deinit();

        var tokens = std.mem.tokenizeAny(u8, input, "\n");
        var calibrations = std.ArrayList(Calibration).init(allocator);
        defer calibrations.deinit();
        while (tokens.next()) |token| {
            var first: bool = true;
            var numberList = std.ArrayList(i64).init(allocator);
            defer numberList.deinit();
            var numbers = std.mem.tokenizeAny(u8, token, ": ");
            var outcome: i64 = 0;
            while (numbers.next()) |number| {
                const intgr = try std.fmt.parseInt(i64, number, 10);
                if (first) {
                    outcome = intgr;
                    first = false;
                } else {
                    try numberList.append(intgr);
                }
            }
            const _numberlist = try numberList.toOwnedSlice();
            const calibration = Calibration{ .outcome = outcome, .numbers = _numberlist };
            try calibrations.append(calibration);
        }

        for (calibrations.items) |calibration| {
            if (calibration.isPossible(extraCheck)) {
                sum += calibration.outcome;
            }
            allocator.free(calibration.numbers);
        }
        return sum;
    }
};
