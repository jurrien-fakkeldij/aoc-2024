const std = @import("std");
const Position = struct { x: isize, y: isize };
const Node = struct {
    type: NodeType,
    frequency: u8,
};

const Vector = struct { x: isize, y: isize };
const NodeType = enum { GROUND, TOWER, ANTINODE };

const directions = [_]Vector{
    Vector{ .x = 0, .y = 1 }, //RIGHT
    Vector{ .x = 1, .y = 1 }, //BOTTOM_RIGHT
    Vector{ .x = 1, .y = 0 }, //BOTTOM
    Vector{ .x = 1, .y = -1 }, //BOTTOM_LEFT
    Vector{ .x = 0, .y = -1 }, //LEFT
    Vector{ .x = -1, .y = -1 }, //TOP_LEFT
    Vector{ .x = -1, .y = 0 }, // TOP
    Vector{ .x = -1, .y = 1 }, // TOP_RIGHT
};
pub const Day8 = struct {
    const test_input: []const u8 =
        \\............
        \\........0...
        \\.....0......
        \\.......0....
        \\....0.......
        \\......A.....
        \\............
        \\............
        \\........A...
        \\.........A..
        \\............
        \\............
    ;

    pub fn solve(input: []const u8) !void {
        std.debug.print("Solving Day 7\n", .{});
        try solvePart1(input);
        try solvePart2(input);
    }

    fn solvePart1(_: []const u8) !void {
        std.debug.print("Part 1\n", .{});
        const total_test = try findTotalAntinodes(test_input);
        std.debug.print("test: {d} \n", .{total_test});

        const total = 0;
        std.debug.print("answer: {d} \n", .{total});
    }

    fn solvePart2(_: []const u8) !void {
        std.debug.print("Part 2\n", .{});

        const total_test = 0;
        std.debug.print("test: {d} \n", .{total_test});

        const total = 0;
        std.debug.print("answer: {d} \n", .{total});
    }

    fn findTotalAntinodes(input: []const u8) !u32 {
        var totalAntinodes: u32 = 0;
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        const allocator = gpa.allocator();
        defer _ = gpa.deinit();

        var locations = std.AutoHashMap(Position, std.ArrayList(Node)).init(allocator);
        defer locations.deinit();

        var anti_node_locations = std.AutoHashMap(Position, std.ArrayList(Node)).init(allocator);
        defer anti_node_locations.deinit();

        var tokens = std.mem.tokenizeAny(u8, input, " \n");
        var row: isize = 0;
        while (tokens.next()) |line| {
            var col: isize = 0;
            var nodeType: NodeType = NodeType.GROUND;
            for (line) |ch| {
                switch (ch) {
                    '.' => nodeType = NodeType.GROUND,
                    else => nodeType = NodeType.TOWER,
                }
                std.debug.print("setting node: {c} : {} \n", .{ ch, nodeType });
                var nodes = std.ArrayList(Node).init(allocator);
                try nodes.append(Node{ .type = nodeType, .frequency = ch });
                try locations.put(Position{ .x = col, .y = row }, nodes);
                col += 1;
            }
            row += 1;
        }

        var locationIterator = locations.iterator();
        while (locationIterator.next()) |location| {
            for (location.value_ptr.*.items) |node| {
                // std.debug.print("Found Node: {}\n", .{node});
                if (node.type == NodeType.TOWER) {
                    const current_tower = node;
                    std.debug.print("Found Tower: {}\n", .{location.key_ptr});
                    var locIter = locations.iterator();
                    while (locIter.next()) |search_location| {
                        if (location.key_ptr == search_location.key_ptr) {
                            continue;
                        }
                        const nodes = locations.get(search_location.key_ptr.*) orelse break;

                        for (nodes.items) |search_node| {
                            if (search_node.type == NodeType.TOWER) {
                                if (search_node.frequency == current_tower.frequency) {
                                    std.debug.print("Found Tower with same frequency: {}\n", .{search_location.key_ptr});
                                    const search_anti = Position{ .x = search_location.key_ptr.x + (search_location.key_ptr.x - location.key_ptr.x), .y = search_location.key_ptr.y + (search_location.key_ptr.y - location.key_ptr.y) };
                                    const current_anti = Position{ .x = location.key_ptr.x + (location.key_ptr.x - search_location.key_ptr.x), .y = location.key_ptr.y - (location.key_ptr.y - search_location.key_ptr.y) };
                                    std.debug.print("AntiNode on {} and {} \n", .{ search_anti, current_anti });
                                    if (locations.contains(search_anti)) {
                                        if (anti_node_locations.contains(search_anti)) {
                                            const old_anti_nodes = anti_node_locations.get(search_anti).?;
                                            var anti_nodes = try old_anti_nodes.clone();
                                            const anti_node = Node{ .frequency = current_tower.frequency, .type = NodeType.ANTINODE };
                                            try anti_nodes.append(anti_node);
                                            std.debug.print("new anti_nodes: {} \n", .{anti_nodes});
                                            anti_node_locations.put(search_anti, anti_nodes) catch {
                                                std.debug.print("something wrong", .{});
                                            };
                                            // old_anti_nodes.deinit();
                                        } else {
                                            const old_anti_nodes = anti_node_locations.get(search_anti).?;
                                            var anti_nodes = try old_anti_nodes.clone();
                                            const anti_node = Node{ .frequency = current_tower.frequency, .type = NodeType.ANTINODE };
                                            anti_nodes.append(anti_node) catch {
                                                std.debug.print("something wrong", .{});
                                            };
                                            anti_node_locations.put(search_anti, anti_nodes) catch {
                                                std.debug.print("something wrong", .{});
                                            };
                                            // old_anti_nodes.deinit();
                                        }
                                    }
                                    if (locations.contains(current_anti)) {
                                        if (anti_node_locations.contains(current_anti)) {
                                            var anti_nodes = locations.get(current_anti).?;
                                            const anti_node = Node{ .frequency = current_tower.frequency, .type = NodeType.ANTINODE };
                                            try anti_nodes.append(anti_node);
                                            anti_node_locations.put(search_anti, anti_nodes) catch {
                                                std.debug.print("something wrong", .{});
                                            };
                                        } else {
                                            var anti_nodes = std.ArrayList(Node).init(allocator);
                                            const anti_node = Node{ .frequency = current_tower.frequency, .type = NodeType.ANTINODE };
                                            anti_nodes.append(anti_node) catch {
                                                std.debug.print("something wrong", .{});
                                            };
                                            anti_node_locations.put(search_anti, anti_nodes) catch {
                                                std.debug.print("something wrong", .{});
                                            };
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        var anti_locationIterator = anti_node_locations.iterator();
        totalAntinodes = anti_node_locations.count();
        // nextLocation: while (anti_locationIterator.next()) |location| {
        //     for (location.value_ptr.*.items) |node| {
        //         if (node.type == NodeType.ANTINODE) {
        //             totalAntinodes += 1;
        //             continue :nextLocation;
        //         }
        //     }
        // }

        locationIterator = locations.iterator();
        while (locationIterator.next()) |location| {
            location.value_ptr.deinit();
        }
        anti_locationIterator = anti_node_locations.iterator();
        while (anti_locationIterator.next()) |location| {
            location.value_ptr.deinit();
        }
        return totalAntinodes;
    }
};
