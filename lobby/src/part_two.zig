const std = @import("std");
const print = @import("std").debug.print;

const input = @embedFile("input.txt");

const Battery = struct {
    joltage: i64 = -1,
    index: usize = 0,
};

pub fn main() !void {
    var total_joltage: i64 = 0;
    const num_batteries: usize = 12;

    var lines = std.mem.tokenizeAny(u8, input, "\n\r");
    while (lines.next()) |line| {

        var joltage: i64 = 0;
        var index: usize = 0;
        for (0..num_batteries) |i| {
            var battery: Battery = Battery{};
            const digit = num_batteries - i - 1;
            for (line[index..line.len-digit], 0..) |char, j| {
                if (char > battery.joltage) {
                    battery = Battery{
                        .joltage = char,
                        .index = j,
                    };
                }
            }
            joltage += (battery.joltage - '0') * std.math.pow(i64, 10, @intCast(digit));
            index += battery.index + 1;
        }
        total_joltage += joltage;
    }
    print("Total joltage: {}\n", .{total_joltage});
}
