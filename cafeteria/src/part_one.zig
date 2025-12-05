const std = @import("std");
const print = @import("std").debug.print;

const input = @embedFile("input.txt");

const Range = struct {
    min: usize,
    max: usize,

    fn contains(self: Range, value: usize) bool {
        return value >= self.min and value <= self.max;
    }
};

fn isRange(line: []const u8) bool {
    return std.mem.indexOfScalar(u8, line, '-') != null;
}

fn isID(line: []const u8) bool {
    return std.mem.indexOfScalar(u8, line, '-') == null and line.len > 0;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var ranges: std.ArrayList(Range) = .empty;
    defer ranges.deinit(allocator);

    var num_fresh_ids: usize = 0;

    var lines = std.mem.tokenizeAny(u8, input, "\n\r");
    while (lines.next()) |line| {
        if (isRange(line)) {
            var range = std.mem.splitScalar(u8, std.mem.trim(u8, line, " \n\r\t"), '-');

            const start = try std.fmt.parseInt(usize, range.first(), 10);
            const stop = try std.fmt.parseInt(usize, range.rest(), 10);
            try ranges.append(allocator, Range{ .min = start, .max = stop });
        } else if (isID(line)) {
            const id = try std.fmt.parseInt(usize, line, 10);
            for (ranges.items) |range| {
                if (range.contains(id)) {
                    num_fresh_ids += 1;
                    break;
                }
            }
        }
    }
    print("Part one : {}\n", .{num_fresh_ids});
}
