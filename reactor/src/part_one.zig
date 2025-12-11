const std = @import("std");
const print = @import("std").debug.print;

const input = @embedFile("input.txt");

const Device = struct { name: []const u8, attached_to: std.ArrayListUnmanaged([]const u8) };
const Graph = std.StringHashMap(std.ArrayListUnmanaged([]const u8));

fn findPath(graph: *const Graph, from: []const u8, to: []const u8) !u32 {
    if (std.mem.eql(u8, from, to)) {
        return 1;
    }

    var paths: u32 = 0;
    if (graph.get(from)) |attached_to| {
        for (attached_to.items) |device| {
            paths += try findPath(graph, device, to);
        }
    }
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

    const from = "you";
    const to = "out";
    const solution = findPath(&graph, from, to);
    print("Part one: {!}\n", .{solution});
}
