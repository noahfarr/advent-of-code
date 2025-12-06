const std = @import("std");
const print = std.debug.print;

const input = @embedFile("input.txt");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var grid = std.ArrayListUnmanaged([]const u8){};
    defer grid.deinit(allocator);

    var lines = std.mem.tokenizeAny(u8, input, "\n\r");
    var max_width: usize = 0;

    while (lines.next()) |line| {
        try grid.append(allocator, line);
        if (line.len > max_width) max_width = line.len;
    }

    var total: u64 = 0;
    var numbers = std.ArrayListUnmanaged(u64){};
    defer numbers.deinit(allocator);
    var op: u8 = 0;

    var j: usize = 0;
    while (j < max_width) : (j += 1) {
        var is_separator = true;
        var digits = std.ArrayListUnmanaged(u8){};
        defer digits.deinit(allocator);

        for (grid.items) |row| {
            if (j < row.len) {
                const token = row[j];
                if (token != ' ') {
                    is_separator = false;
                    if (std.ascii.isDigit(token)) {
                        try digits.append(allocator, token);
                    } else if (token == '+' or token == '*') {
                        op = token;
                    }
                }
            }
        }

        // If we hit a separator column, solve the accumulated problem
        if (is_separator) {
            if (numbers.items.len > 0) {
                if (op == '+') {
                    var sum: u64 = 0;
                    for (numbers.items) |n| sum += n;
                    total += sum;
                } else if (op == '*') {
                    var product: u64 = 1;
                    for (numbers.items) |n| product *= n;
                    total += product;
                }
                // Reset for next problem
                numbers.clearRetainingCapacity();
                op = 0;
            }
        } else {
            // Not a separator; parse the vertical digits into a number
            if (digits.items.len > 0) {
                const number = try std.fmt.parseInt(u64, digits.items, 10);
                try numbers.append(allocator, number);
            }
        }
    }

    // Handle the final problem if the file didn't end with a space column
    if (numbers.items.len > 0) {
        if (op == '+') {
            var sum: u64 = 0;
            for (numbers.items) |n| sum += n;
            total += sum;
        } else if (op == '*') {
            var product: u64 = 1;
            for (numbers.items) |n| product *= n;
            total += product;
        }
    }

    print("Part two: {}\n", .{total});
}
