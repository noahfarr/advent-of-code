const std = @import("std");
const print = std.debug.print;

const input = @embedFile("input.txt");

const Tile = struct {
    x: i64,
    y: i64,
};

const Rectangle = struct {
    a: Tile,
    b: Tile,

    pub fn area(self: Rectangle) u64 {
        const width = @abs(self.b.x - self.a.x) + 1;
        const height = @abs(self.b.y - self.a.y) + 1;
        return width * height;
    }

    pub fn contains(self: Rectangle, tile: Tile) bool {
        return tile.x > @min(self.a.x, self.b.x) and tile.x < @max(self.a.x, self.b.x) and tile.y > @min(self.a.y, self.b.y) and tile.y < @max(self.a.y, self.b.y);
    }

    pub fn isIntersectedBySegment(self: Rectangle, p: Tile, q: Tile) bool {
        if (p.x == q.x) {
            if (p.x > @min(self.a.x, self.b.x) and p.x < @max(self.a.x, self.b.x)) {
                if (!(@max(p.y, q.y) <= @min(self.a.y, self.b.y) or @min(p.y, q.y) >= @max(self.a.y, self.b.y))) return true;
            }
        } else if (p.y == q.y) {
            if (p.y > @min(self.a.y, self.b.y) and p.y < @max(self.a.y, self.b.y)) {
                if (!(@max(p.x, q.x) <= @min(self.a.x, self.b.x) or @min(p.x, q.x) >= @max(self.a.x, self.b.x))) return true;
            }
        }
        return false;
    }
};

fn isTileInsidePolygon(x: f64, y: f64, vertices: []const Tile) bool {
    var inside = false;
    var i: usize = 0;
    while (i < vertices.len) : (i += 1) {
        const p = vertices[i];
        const q = vertices[(i + 1) % vertices.len];

        const px = @as(f64, @floatFromInt(p.x));
        const qx = @as(f64, @floatFromInt(q.x));
        const py = @as(f64, @floatFromInt(p.y));
        const qy = @as(f64, @floatFromInt(q.y));

        if (@abs(px - qx) == 0.0 and @abs(px - x) == 0.0) {
            if (y >= @min(py, qy) and y <= @max(py, qy)) return true;
        }
        if (@abs(py - qy) == 0.0 and @abs(py - y) == 0.0) {
            if (x >= @min(px, qx) and x <= @max(px, qx)) return true;
        }
        if ((py > y) != (qy > y)) {
            if (x < (qx - px) * (y - py) / (qy - py) + px) {
                inside = !inside;
            }
        }
    }
    return inside;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var red_tiles = std.ArrayListUnmanaged(Tile){};
    defer red_tiles.deinit(allocator);

    var lines = std.mem.tokenizeAny(u8, input, "\n\r");
    while (lines.next()) |line| {
        var coordinates = std.mem.tokenizeAny(u8, line, ",");
        const tile = Tile{
            .x = try std.fmt.parseInt(i64, coordinates.next().?, 10),
            .y = try std.fmt.parseInt(i64, coordinates.next().?, 10),
        };
        try red_tiles.append(allocator, tile);
    }

    var max_area: u64 = 0;

    for (0..red_tiles.items.len) |i| {
        for (i + 1..red_tiles.items.len) |j| {
            const rectangle = Rectangle{
                .a = red_tiles.items[i],
                .b = red_tiles.items[j],
            };
            const area = rectangle.area();

            if (area <= max_area) continue;

            var is_empty = true;
            for (red_tiles.items) |tile| {
                if (rectangle.contains(tile)) {
                    is_empty = false;
                    break;
                }
            }
            if (!is_empty) continue;

            var is_intersected = false;
            for (0..red_tiles.items.len) |k| {
                const p = red_tiles.items[k];
                const q = red_tiles.items[(k + 1) % red_tiles.items.len];
                if (rectangle.isIntersectedBySegment(p, q)) {
                    is_intersected = true;
                    break;
                }
            }
            if (is_intersected) continue;

            if (!isTileInsidePolygon(@as(f64, @floatFromInt(rectangle.a.x + rectangle.b.x)) / 2.0, @as(f64, @floatFromInt(rectangle.a.y + rectangle.b.y)) / 2.0, red_tiles.items)) continue;

            if (!isTileInsidePolygon(@as(f64, @floatFromInt(rectangle.a.x)), @as(f64, @floatFromInt(rectangle.b.y)), red_tiles.items)) continue;
            if (!isTileInsidePolygon(@as(f64, @floatFromInt(rectangle.b.x)), @as(f64, @floatFromInt(rectangle.a.y)), red_tiles.items)) continue;

            max_area = area;
        }
    }

    print("Part Two Answer: {d}\n", .{max_area});
}
