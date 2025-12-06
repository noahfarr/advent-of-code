const std = @import("std");
const print = std.debug.print;

const input = @embedFile("input.txt");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var columns = std.ArrayListUnmanaged(std.ArrayListUnmanaged(u32)){};

    defer {
        for (columns.items) |*column| column.deinit(allocator);
        columns.deinit(allocator);
    }

    var lines = std.mem.tokenizeAny(u8, input, "\n\r");
    var total: u64 = 0;

    while (lines.next()) |line| {
        var tokens = std.mem.tokenizeAny(u8, line, " ");
        var column: usize = 0;

        while (tokens.next()) |token| : (column += 1) {
            if (column >= columns.items.len) {
                try columns.append(allocator, std.ArrayListUnmanaged(u32){});
            }

            if (std.mem.eql(u8, token, "+")) {
                var sum: u64 = 0;
                for (columns.items[column].items) |n| {
                    sum += n;
                }
                total += sum;
            } else if (std.mem.eql(u8, token, "*")) {
                var product: u64 = 1;
                for (columns.items[column].items) |n| {
                    product *= n;
                }
                total += product;
            } else {
                const number = try std.fmt.parseInt(u32, token, 10);
                try columns.items[column].append(allocator, number);
            }
        }
    }

    print("Part one: {}\n", .{total});
}
