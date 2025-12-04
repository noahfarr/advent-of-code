const std = @import("std");
const print = @import("std").debug.print;

const input = @embedFile("input.txt");

const Point = struct { r: isize, c: isize };

const directions = [_]Point{
    .{ .r = -1, .c = -1 }, .{ .r = -1, .c = 0 }, .{ .r = -1, .c = 1 },
    .{ .r = 0, .c = -1 },  .{ .r = 0, .c = 1 },  .{ .r = 1, .c = -1 },
    .{ .r = 1, .c = 0 },   .{ .r = 1, .c = 1 },
};

pub fn main() !void {
    var grid: [10][10]u8 = undefined;

    var lines = std.mem.tokenizeAny(u8, input, "\n\r");
    var i: usize = 0;
    var j: usize = 0;
    while (lines.next()) |line| {
        for (line) |char| {
            grid[i][j] = char;
            i += 1;
        }
        i = 0;
        j += 1;
    }
    print("Grid:\n", .{});
}
