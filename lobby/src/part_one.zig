const std = @import("std");
const print = @import("std").debug.print;

const input = @embedFile("input.txt");

const Battery = struct {
    joltage: i32 = -1,
    index: usize = 0,
};

pub fn main() !void {
    var total_joltage: i32 = 0;

    var lines = std.mem.tokenizeAny(u8, input, "\n\r");
    while (lines.next()) |line| {
        var tens: Battery = Battery{};

        for (line[0..line.len-1], 0..) |char, i| {
            const battery: Battery = Battery{
                .joltage = char,
                .index = i,
            };
            if (battery.joltage > tens.joltage) {
                tens = battery;
            }
        }

        var ones: Battery = Battery{};
        for (line[tens.index+1..], 0..) |char, i| {
            const battery: Battery = Battery{
                .joltage = char,
                .index = i,
            };
            if (battery.joltage > ones.joltage) {
                ones = battery;
            }
        }
        const joltage: i32 = (tens.joltage - '0') * 10 + (ones.joltage - '0');
        total_joltage += joltage;
    }
    print("Total joltage: {}\n", .{total_joltage});
}
