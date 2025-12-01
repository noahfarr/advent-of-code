const std = @import("std");
const print = @import("std").debug.print;

const input = @embedFile("input.txt");

pub fn main() !void {
    var lines = std.mem.tokenizeAny(u8, input, "\n\r");
    var dial: i32 = 50;
    var password: u64 = 0;

    while (lines.next()) |line| {
        const direction = line[0];
        const distance = try std.fmt.parseInt(i32, line[1..], 10);

        password += @as(u64, @intCast(distance)) / 100;
        const remainder = @mod(distance, 100);

        if (direction == 'L') {
            if (dial != 0 and dial - remainder <= 0) {
                password += 1;
            }
            dial = @mod(dial - remainder, 100);
        } else if (direction == 'R') {
            if (dial + remainder >= 100) {
                password += 1;
            }
            dial = @mod(dial + remainder, 100);
        }
    }
    print("Password: {}\n", .{password});
}
