const std = @import("std");
const Location = struct { type: LocationType, visited: bool, direction: Direction };
const LocationType = enum { GROUND, PILLAR };
const Position = struct { x: i32, y: i32 };

const Direction = enum {
    NORTH,
    EAST,
    SOUTH,
    WEST,
    pub fn turn(self: Direction) Direction {
        switch (self) {
            .NORTH => {
                return Direction.EAST;
            },
            .EAST => {
                return Direction.SOUTH;
            },
            .SOUTH => {
                return Direction.WEST;
            },
            .WEST => {
                return Direction.NORTH;
            },
        }
    }
};
const Vector = struct { x: i32, y: i32 };
pub const Day6 = struct {
    const test_input: []const u8 =
        \\....#.....
        \\.........#
        \\..........
        \\..#.......
        \\.......#..
        \\..........
        \\.#..^.....
        \\........#.
        \\#.........
        \\......#...
    ;

    pub fn solve(input: []const u8) !void {
        std.debug.print("Solving Day 6\n", .{});
        try solvePart1(input);
        try solvePart2(input);
    }

    fn solvePart1(input: []const u8) !void {
        std.debug.print("Part 1\n", .{});
        const total_test = try findDistinctVisits(test_input);
        std.debug.print("test: {d} \n", .{total_test});

        const total = try findDistinctVisits(input);
        std.debug.print("answer: {d} \n", .{total});
    }

    fn solvePart2(input: []const u8) !void {
        std.debug.print("Part 2\n", .{});

        const total_test: u32 = try findNumberOfPlacesToBlockPath(test_input);
        std.debug.print("test: {d} \n", .{total_test});

        const total: u32 = try findNumberOfPlacesToBlockPath(input);
        std.debug.print("answer: {d} \n", .{total});
    }

    pub fn findDistinctVisits(input: []const u8) !u32 {
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        const allocator = gpa.allocator();
        defer _ = gpa.deinit();

        var locations = std.AutoHashMap(Position, Location).init(allocator);
        defer locations.deinit();

        var tokens = std.mem.tokenizeAny(u8, input, " \n");
        var row: i32 = 0;
        var guardPosition = Position{ .x = 0, .y = 0 };
        var guardDirection = Direction.NORTH;
        var visited = false;
        while (tokens.next()) |line| {
            var col: i32 = 0;
            var locationType: LocationType = LocationType.GROUND;
            for (line) |ch| {
                switch (ch) {
                    '#' => locationType = LocationType.PILLAR,
                    '.' => locationType = LocationType.GROUND,
                    '^' => {
                        locationType = LocationType.GROUND;
                        guardPosition.x = col;
                        guardPosition.y = row;
                        visited = true;
                    },
                    else => {
                        std.debug.print("Found weird character on location {d},{d}: {c}", .{ col, row, ch });
                        unreachable;
                    },
                }
                try locations.put(Position{ .x = col, .y = row }, Location{ .type = locationType, .visited = visited, .direction = Direction.NORTH });
                col += 1;
                visited = false;
            }
            row += 1;
        }
        var vectorDirection = getVector(guardDirection);
        // std.debug.print("Starting: {}\n", .{guardPosition});
        var nextGuardPosition = Position{ .x = guardPosition.x + vectorDirection.x, .y = guardPosition.y + vectorDirection.y };
        // std.debug.print("Next location:{}\n", .{nextGuardPosition});
        var totalDistinctVisit: u32 = 0;
        while (true) {
            var loc = locations.get(nextGuardPosition) orelse break;
            switch (loc.type) {
                .PILLAR => {
                    // std.debug.print("turning\n", .{});
                    guardDirection = guardDirection.turn();
                    vectorDirection = getVector(guardDirection);
                },
                .GROUND => {
                    guardPosition.x = nextGuardPosition.x;
                    guardPosition.y = nextGuardPosition.y;
                    // std.debug.print("loc:{}\n", .{loc});
                    if (!loc.visited) {
                        loc.visited = true;
                        loc.direction = guardDirection;
                        try locations.put(nextGuardPosition, loc);
                    }
                },
            }
            nextGuardPosition = Position{ .x = guardPosition.x + vectorDirection.x, .y = guardPosition.y + vectorDirection.y };
            // std.debug.print("Next location:{}\n", .{nextGuardPosition});
        }
        var it = locations.valueIterator();
        while (it.next()) |location| {
            if (location.visited) {
                totalDistinctVisit += 1;
            }
        }
        return totalDistinctVisit;
    }

    fn getVector(direction: Direction) Vector {
        switch (direction) {
            .NORTH => {
                return Vector{ .x = 0, .y = -1 };
            },
            .EAST => {
                return Vector{ .x = 1, .y = 0 };
            },
            .SOUTH => {
                return Vector{ .x = 0, .y = 1 };
            },
            .WEST => {
                return Vector{ .x = -1, .y = 0 };
            },
        }
    }

    fn findNumberOfPlacesToBlockPath(input: []const u8) !u32 {
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        const allocator = gpa.allocator();
        defer _ = gpa.deinit();

        var locations = std.AutoHashMap(Position, Location).init(allocator);
        defer locations.deinit();

        var tokens = std.mem.tokenizeAny(u8, input, " \n");
        var row: i32 = 0;
        var guardPosition = Position{ .x = 0, .y = 0 };
        var guardDirection = Direction.NORTH;
        var visited = false;
        while (tokens.next()) |line| {
            var col: i32 = 0;
            var locationType: LocationType = LocationType.GROUND;
            for (line) |ch| {
                switch (ch) {
                    '#' => locationType = LocationType.PILLAR,
                    '.' => locationType = LocationType.GROUND,
                    '^' => {
                        locationType = LocationType.GROUND;
                        guardPosition.x = col;
                        guardPosition.y = row;
                        visited = true;
                    },
                    else => {
                        std.debug.print("Found weird character on location {d},{d}: {c}", .{ col, row, ch });
                        unreachable;
                    },
                }
                try locations.put(Position{ .x = col, .y = row }, Location{ .type = locationType, .visited = visited, .direction = Direction.NORTH });
                col += 1;
                visited = false;
            }
            row += 1;
        }
        var vectorDirection = getVector(guardDirection);
        var nextGuardPosition = Position{ .x = guardPosition.x + vectorDirection.x, .y = guardPosition.y + vectorDirection.y };
        const startPosition = guardPosition;
        const startDirection = guardDirection;
        var path = std.AutoHashMap(Position, Location).init(allocator);
        defer path.deinit();

        var count: u32 = 0;
        while (true) {
            var loc = locations.get(nextGuardPosition) orelse break;
            switch (loc.type) {
                .PILLAR => {
                    guardDirection = guardDirection.turn();
                    vectorDirection = getVector(guardDirection);
                },
                .GROUND => {
                    guardPosition.x = nextGuardPosition.x;
                    guardPosition.y = nextGuardPosition.y;
                    if (!loc.visited) {
                        loc.visited = true;
                        loc.direction = guardDirection;
                        try locations.put(nextGuardPosition, loc);
                        try path.put(nextGuardPosition, loc);
                    }
                },
            }
            nextGuardPosition = Position{ .x = guardPosition.x + vectorDirection.x, .y = guardPosition.y + vectorDirection.y };
        }
        var it = path.keyIterator();
        while (it.next()) |position| {
            var loc = locations.get(position.*).?;
            const currentType = loc.type;
            switch (currentType) {
                .PILLAR => {
                    continue;
                },
                .GROUND => {
                    loc.type = LocationType.PILLAR;
                    try locations.put(position.*, loc);
                },
            }
            const hasLoop = try loopExists(allocator, locations, startPosition, startDirection);

            if (hasLoop) {
                count += 1;
            }
            loc.type = currentType;
            try locations.put(position.*, loc);
        }

        return count;
    }

    fn loopExists(allocator: std.mem.Allocator, locations: std.AutoHashMap(Position, Location), startPosition: Position, startDirection: Direction) !bool {
        var vectorDirection = getVector(startDirection);
        var guardDirection = startDirection;
        var loop_locations = locations;
        var nextGuardPosition = Position{ .x = startPosition.x + vectorDirection.x, .y = startPosition.y + vectorDirection.y };
        var guardPosition = startPosition;
        var loop = false;
        var path = std.AutoHashMap(Position, Location).init(allocator);
        defer path.deinit();
        while (true) {
            var loc = loop_locations.get(nextGuardPosition) orelse {
                break;
            };
            if (path.contains(nextGuardPosition) and path.get(nextGuardPosition).?.direction == guardDirection) {
                //found loop
                loop = true;
                break;
            }
            switch (loc.type) {
                .PILLAR => {
                    guardDirection = guardDirection.turn();
                    vectorDirection = getVector(guardDirection);
                },
                .GROUND => {
                    guardPosition.x = nextGuardPosition.x;
                    guardPosition.y = nextGuardPosition.y;
                    loc.visited = true;
                    loc.direction = guardDirection;
                    try loop_locations.put(nextGuardPosition, loc);
                    try path.put(nextGuardPosition, loc);
                },
            }
            nextGuardPosition = Position{ .x = guardPosition.x + vectorDirection.x, .y = guardPosition.y + vectorDirection.y };
        }
        return loop;
    }
};
