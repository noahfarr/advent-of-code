const std = @import("std");
const print = std.debug.print;

const input = @embedFile("input.txt");

fn isInvalidID(id: usize) !bool {
    var buf: [32]u8 = undefined;
    const s = try std.fmt.bufPrint(&buf, "{d}", .{id});

    return std.mem.eql(u8, s[0..s.len/2], s[s.len/2..]);
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
