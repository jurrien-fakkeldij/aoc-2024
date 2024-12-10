const std = @import("std");
const File = union(enum) { id: u64, empty: bool };
pub const Day9 = struct {
    const test_input: []const u8 =
        \\2333133121414131402
    ;

    pub fn solve(input: []const u8) !void {
        std.debug.print("Solving Day 9\n", .{});
        try solvePart1(input);
        try solvePart2(input);
    }

    fn solvePart1(input: []const u8) !void {
        std.debug.print("Part 1\n", .{});
        const total_test = try sortFileSystem(test_input);
        std.debug.print("test: {d} \n", .{total_test});

        const total = try sortFileSystem(input);
        std.debug.print("answer: {d} \n", .{total});
    }

    fn solvePart2(_: []const u8) !void {
        std.debug.print("Part 2\n", .{});

        const total_test: u32 = 0;
        std.debug.print("test: {d} \n", .{total_test});

        const total: u32 = 0;
        std.debug.print("answer: {d} \n", .{total});
    }

    fn sortFileSystem(input: []const u8) !u64 {
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        const allocator = gpa.allocator();
        defer _ = gpa.deinit();
        var fileSystem = std.ArrayList(File).init(allocator);
        defer fileSystem.deinit();
        var empty: bool = false;
        var fileNumber: u64 = 0;
        for (input) |ch| {
            if (ch >= '0' and ch <= '9') {
                const amount = @as(u32, @intCast(ch - '0'));
                for (0..amount) |_| {
                    if (!empty) {
                        try fileSystem.append(File{ .id = fileNumber });
                    } else {
                        try fileSystem.append(File{ .empty = true });
                    }
                }
                if (empty) {
                    fileNumber += 1;
                }
                empty = !empty;
            }
        }
        // std.debug.print("output: {any}\n", .{fileSystem.items});
        var compactFileSystem = std.ArrayList(File).init(allocator);
        const list = fileSystem.items;
        var last_index = list.len - 1;
        defer compactFileSystem.deinit();
        for (0.., fileSystem.items) |idx, item| {
            if (idx > last_index) {
                try compactFileSystem.append(item);
                continue;
            }
            switch (item) {
                .empty => {
                    while (true) {
                        switch (list[last_index]) {
                            .empty => {
                                last_index -= 1;
                            },
                            .id => {
                                break;
                            },
                        }
                    }

                    try compactFileSystem.append(list[last_index]);
                    try fileSystem.insert(last_index, File{ .empty = true });
                    _ = fileSystem.orderedRemove(last_index + 1);
                    last_index -= 1;
                },
                .id => {
                    try compactFileSystem.append(item);
                },
            }
        }
        // std.debug.print("compact:", .{});

        var checksum: u64 = 0;
        for (0.., compactFileSystem.items) |idx, item| {
            switch (item) {
                .empty => {
                    // std.debug.print(".", .{});
                    std.debug.print("idx:{d}", .{idx});
                },
                .id => {
                    // std.debug.print("{d}", .{item.id});
                    checksum += item.id * @as(u64, @intCast(idx));
                },
            }
        }
        return checksum;
    }
};
