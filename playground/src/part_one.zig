const std = @import("std");
const print = @import("std").debug.print;

const input = @embedFile("input.txt");

const JunctionBox = struct {
    x: i64,
    y: i64,
    z: i64,

    pub fn distance(self: JunctionBox, other: JunctionBox) i64 {
        const dx = self.x - other.x;
        const dy = self.y - other.y;
        const dz = self.z - other.z;
        return dx * dx + dy * dy + dz * dz;
    }
};

const Connection = struct {
    from: usize,
    to: usize,
    distance: i64,

    pub fn lessThan(_: void, lhs: Connection, rhs: Connection) bool {
        return lhs.distance < rhs.distance;
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var junction_boxes = std.ArrayListUnmanaged(JunctionBox){};
    defer junction_boxes.deinit(allocator);

    var lines = std.mem.tokenizeAny(u8, input, "\n\r");
    while (lines.next()) |line| {
        var coordinates = std.mem.tokenizeAny(u8, line, ",");
        const junction_box = JunctionBox{
            .x = try std.fmt.parseInt(i64, coordinates.next().?, 10),
            .y = try std.fmt.parseInt(i64, coordinates.next().?, 10),
            .z = try std.fmt.parseInt(i64, coordinates.next().?, 10),
        };
        try junction_boxes.append(allocator, junction_box);
    }

    var connections = std.ArrayListUnmanaged(Connection){};
    defer connections.deinit(allocator);

    for (junction_boxes.items, 0..) |from, i| {
        for (junction_boxes.items[i + 1 ..], 0..) |to, offset| {
            const j = i + offset + 1;
            const dist = from.distance(to);
            try connections.append(allocator, Connection{
                .from = i,
                .to = j,
                .distance = dist,
            });
        }
    }

    std.mem.sort(Connection, connections.items, {}, Connection.lessThan);

    var parents = try allocator.alloc(usize, junction_boxes.items.len);
    defer allocator.free(parents);
    for (parents, 0..) |*p, idx| p.* = idx;

    const find_root = struct {
        fn func(parent: []usize, i: usize) usize {
            if (parent[i] == i) return i;
            parent[i] = func(parent, parent[i]);
            return parent[i];
        }
    }.func;

    const limit = @min(1000, connections.items.len);
    for (connections.items[0..limit]) |connection| {
        const from = find_root(parents, connection.from);
        const to = find_root(parents, connection.to);

        if (from != to) {
            parents[from] = to;
        }
    }

    var circuit_sizes = std.AutoHashMap(usize, i32).init(allocator);
    defer circuit_sizes.deinit();

    for (0..junction_boxes.items.len) |i| {
        const root = find_root(parents, i);
        const entry = try circuit_sizes.getOrPut(root);
        if (entry.found_existing) {
            entry.value_ptr.* += 1;
        } else {
            entry.value_ptr.* = 1;
        }
    }

    var sizes = std.ArrayListUnmanaged(i32){};
    defer sizes.deinit(allocator);

    var iterator = circuit_sizes.valueIterator();
    while (iterator.next()) |val| {
        try sizes.append(allocator, val.*);
    }

    std.mem.sort(i32, sizes.items, {}, std.sort.desc(i32));

    const result: i64 = @as(i64, sizes.items[0]) * @as(i64, sizes.items[1]) * @as(i64, sizes.items[2]);
    print("Part one: {}\n", .{result});
}
