const std = @import("std");
const print = std.debug.print;

const input = @embedFile("input.txt");

fn isInvalidID(id: usize) !bool {
    var buf: [32]u8 = undefined;
    const s = try std.fmt.bufPrint(&buf, "{d}", .{id});

    var length: usize = 1;
    while (length <= s.len / 2): (length += 1) {

        if (s.len % length != 0) continue;

        const pattern = s[0..length];
        var match = true;

        var i: usize = length;
        while (i < s.len) : (i += length) {
            if (!std.mem.eql(u8, pattern, s[i..i+length])) {
                match = false;
                break;
            }
        }
        if (match) {
            return true;
        }
    }
    return false;
}


pub fn main() !void {
    var pairs = std.mem.tokenizeScalar(u8, input, ',');

    var sum_of_invalid_ids: usize = 0;
    while (pairs.next()) |pair| {

        var numbers = std.mem.splitScalar(u8, std.mem.trim(u8, pair, " \n\r\t"), '-');

        const start = try std.fmt.parseInt(usize, numbers.first(), 10);
        const stop = try std.fmt.parseInt(usize, numbers.rest(), 10);

        for (start..stop + 1) |i| {
            if ((try isInvalidID(i))) {
                sum_of_invalid_ids += i;
            }
        }
    }
    print("{d}\n", .{sum_of_invalid_ids});
}
