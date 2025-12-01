const std = @import("std");
const print = @import("std").debug.print;

const input = @embedFile("input.txt");

pub fn main() !void {
    var lines = std.mem.tokenizeAny(u8, input, "\n\r");
    var dial: i32 = 50;
    var password: u32 = 0;

    while (lines.next()) |line| {
        const direction = line[0];
        const distance = try std.fmt.parseInt(i32, line[1..], 10);

        if (direction == 'L') {
            dial -= distance;
        } else if (direction == 'R') {
            dial += distance;
        }

        dial = @mod(dial, 100);

        if (dial == 0) {
            password += 1;
        }
    }
    print("Password: {}\n", .{password});
}
