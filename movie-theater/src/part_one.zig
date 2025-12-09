const std = @import("std");
const print = @import("std").debug.print;

const input = @embedFile("input.txt");

const Rectangle = struct {
    a: Tile,
    b: Tile,

    pub fn area(self: Rectangle) i64 {
        const width = self.b.x - self.a.x + 1;
        const height = self.b.y - self.a.y + 1;
        return width * height;
    }
};

const Tile = struct {
    x: i64,
    y: i64,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var red_tiles = std.ArrayListUnmanaged(Tile){};
    defer red_tiles.deinit(allocator);

    var lines = std.mem.tokenizeAny(u8, input, "\n\r");
    var i: usize = 0;
    while (lines.next()) |line| : (i += 1) {
        var coordinates = std.mem.tokenizeAny(u8, line, ",");
        const tile: Tile = Tile{
            .x = try std.fmt.parseInt(i64, coordinates.next().?, 10),
            .y = try std.fmt.parseInt(i64, coordinates.next().?, 10),
        };
        try red_tiles.append(allocator, tile);
    }

    var largest_rectangle: ?Rectangle = null;
    for (red_tiles.items) |tile| {
        for (red_tiles.items) |other| {
            const rectangle = Rectangle{
                .a = tile,
                .b = other,
            };
            if (largest_rectangle) |largest| {
                if (rectangle.area() > largest.area()) {
                    largest_rectangle = rectangle;
                }
            } else {
                largest_rectangle = rectangle;
            }
        }
    }

    print("Part one: {d}\n", .{largest_rectangle.?.area()});
}
