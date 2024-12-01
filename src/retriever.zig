const std = @import("std");
const http = std.http;

pub const Retriever = struct {
    pub fn get(day: u32) ![:0]const u8 {
        // Create a general purpose allocator
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        const allocator = gpa.allocator();
        defer _ = gpa.deinit();
        // Create a HTTP client
        var client = std.http.Client{ .allocator = gpa.allocator() };
        defer client.deinit();

        var env_map = try std.process.getEnvMap(allocator);
        defer env_map.deinit();

        const session = env_map.get("AOCSESSION").?;
        const sessionTag = "session=";
        const concat: []const []const u8 = &.{ sessionTag, session };
        const sessionCookie = try std.mem.concat(allocator, u8, concat);
        defer allocator.free(sessionCookie);
        // Allocate a buffer for server headers
        var buf: [4096]u8 = undefined;

        // Start the HTTP request
        const cookies: [1]http.Header = .{http.Header{ .name = "Cookie", .value = sessionCookie }};
        const max_len = 2048;
        var bufUri: [max_len]u8 = undefined;
        const uriString = try std.fmt.bufPrint(&bufUri, "https://adventofcode.com/2024/day/{}/input", .{day});
        const uri = try std.Uri.parse(uriString);

        var req = try client.open(.GET, uri, .{ .extra_headers = &cookies, .server_header_buffer = &buf });
        defer req.deinit();

        // Send the HTTP request headers
        try req.send();
        // Finish the body of a request
        try req.finish();

        // Waits for a response from the server and parses any headers that are sent
        try req.wait();

        var rdr = req.reader();
        const body: []const u8 = try rdr.readAllAlloc(gpa.allocator(), 1024 * 1024 * 4);
        // std.debug.print("response={s}\n", .{body});
        // std.debug.print("status={d}\n", .{req.response.status}); // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
        var bodyArrList = std.ArrayList(u8).init(gpa.allocator());
        try bodyArrList.appendSlice(body);
        return bodyArrList.toOwnedSliceSentinel(0);
    }
};
