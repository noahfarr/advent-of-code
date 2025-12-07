const std = @import("std");
const print = @import("std").debug.print;

const input = @embedFile("input.txt");

pub fn main() !void {
    var lines = std.mem.tokenizeAny(u8, input, "\n\r");
    var timelines = [_]u64{0} ** 141;

    while (lines.next()) |line| {
        var next_timelines = [_]u64{0} ** 141;
        for (line, 0..) |char, i| {
            if (char == 'S') {
                next_timelines[i] += 1;
            } else if (char == '^') {
                if (timelines[i] > 0) {
                    if (i > 0) {
                        next_timelines[i - 1] += timelines[i];
                    }
                    if (i < timelines.len - 1) {
                        next_timelines[i + 1] += timelines[i];
                    }
                }
            } else {
                next_timelines[i] += timelines[i];
            }
        }
        timelines = next_timelines;
    }

    var total_timelines: u64 = 0;
    for (timelines) |timeline| {
        total_timelines += timeline;
    }
    print("Part 2: {}\n", .{total_timelines});
}
