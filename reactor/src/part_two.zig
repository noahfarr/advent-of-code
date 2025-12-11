const std = @import("std");
const print = @import("std").debug.print;

const input = @embedFile("input.txt");

const Device = struct { name: []const u8, attached_to: std.ArrayListUnmanaged([]const u8) };
const Graph = std.StringHashMap(std.ArrayListUnmanaged([]const u8));
const Cache = std.StringHashMap(std.StringHashMap(u64));

fn findPath(allocator: std.mem.Allocator, graph: *const Graph, cache: *Cache, from: []const u8, to: []const u8) !u64 {
    if (cache.get(from)) |paths| {
        if (paths.get(to)) |path| {
            return path;
        }
    }

    if (std.mem.eql(u8, from, to)) {
        return 1;
    }

    var paths: u64 = 0;
    if (graph.get(from)) |attached_to| {
        for (attached_to.items) |device| {
            paths += try findPath(allocator, graph, cache, device, to);
        }
    }

    const memoization = try cache.getOrPut(from);
    if (!memoization.found_existing) {
        memoization.value_ptr.* = std.StringHashMap(u64).init(allocator);
    }

    try memoization.value_ptr.*.put(to, paths);
    return paths;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var graph = Graph.init(allocator);
    defer {
        var value_iterator = graph.valueIterator();
        while (value_iterator.next()) |attached_to| {
            attached_to.deinit(allocator);
        }
        graph.deinit();
    }

    var lines = std.mem.tokenizeAny(u8, input, "\n\r");
    while (lines.next()) |line| {
        var devices = std.mem.tokenizeAny(u8, line, ":");

        var device = Device{ .name = devices.next().?, .attached_to = std.ArrayListUnmanaged([]const u8){} };
        var attached_to = std.mem.tokenizeAny(u8, devices.rest(), " ");
        while (attached_to.next()) |name| {
            try device.attached_to.append(allocator, name);
        }
        try graph.put(device.name, device.attached_to);
    }

    var cache = Cache.init(allocator);
    defer {
        var value_iterator = cache.valueIterator();
        while (value_iterator.next()) |memoization| {
            memoization.deinit();
        }
        cache.deinit();
    }

    const from = "svr";
    const to = "out";
    const fft = "fft";
    const dac = "dac";

    const svr_to_fft = try findPath(allocator, &graph, &cache, from, fft);
    const fft_to_dac = try findPath(allocator, &graph, &cache, fft, dac);
    const dac_to_out = try findPath(allocator, &graph, &cache, dac, to);

    var solution = svr_to_fft * fft_to_dac * dac_to_out;

    const svr_to_dac = try findPath(allocator, &graph, &cache, from, dac);
    const dac_to_fft = try findPath(allocator, &graph, &cache, dac, fft);
    const fft_to_out = try findPath(allocator, &graph, &cache, fft, to);

    solution += svr_to_dac * dac_to_fft * fft_to_out;

    print("Part two: {d}\n", .{solution});
}
