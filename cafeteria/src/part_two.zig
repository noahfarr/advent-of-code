const std = @import("std");
const print = @import("std").debug.print;

const input = @embedFile("input.txt");

const Range = struct {
    min: usize,
    max: usize,

    fn lessThan(context: void, a: Range, b: Range) bool {
        _ = context;
        return a.min < b.min;
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

    var lines = std.mem.tokenizeAny(u8, input, "\n\r");
    while (lines.next()) |line| {
        if (isRange(line)) {
            var range = std.mem.splitScalar(u8, std.mem.trim(u8, line, " \n\r\t"), '-');

            const start = try std.fmt.parseInt(usize, range.first(), 10);
            const stop = try std.fmt.parseInt(usize, range.rest(), 10);
            try ranges.append(allocator, Range{ .min = start, .max = stop });
        } else {
            break;
        }
    }
    std.sort.block(Range, ranges.items, {}, Range.lessThan);

    var num_fresh_ids: usize = 0;

    var min: usize = ranges.items[0].min;
    var max: usize = ranges.items[0].max;
    for (ranges.items[1..]) |next| {
        if (next.min <= max) {
            if (next.max > max) {
                max = next.max;
            }
        } else {
            num_fresh_ids += (max - min + 1);

            min = next.min;
            max = next.max;
        }
    }
    num_fresh_ids += (max - min + 1);
    print("Part two : {}\n", .{num_fresh_ids});
}
