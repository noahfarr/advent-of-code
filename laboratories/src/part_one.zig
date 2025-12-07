const std = @import("std");
const print = @import("std").debug.print;

const input = @embedFile("input.txt");

pub fn main() !void {
    var lines = std.mem.tokenizeAny(u8, input, "\n\r");
    var beams = [_]bool{false} ** 141;

    var num_splits: usize = 0;

    while (lines.next()) |line| {
        var next_beams = [_]bool{false} ** 141;
        for (line, 0..) |char, i| {
            if (char == 'S') {
                next_beams[i] = true;
            } else if (char == '^') {
                if (beams[i]) {
                    if (i > 0) {
                        next_beams[i - 1] = true;
                    }
                    if (i < beams.len - 1) {
                        next_beams[i + 1] = true;
                    }
                    num_splits += 1;
                }
            } else {
                if (beams[i]) {
                    next_beams[i] = true;
                }
            }
        }
        beams = next_beams;
    }
    print("Part 1: {}\n", .{num_splits});
}
