const std = @import("std");
const print = @import("std").debug.print;

const input = @embedFile("input.txt"); 

const paper: u8 = 64; // '@'
const grid_size = 140;
const Grid = [grid_size][grid_size]u8;

const Cell = struct { row: isize, column: isize };
const directions = [_]Cell{
    .{ .row = -1, .column = -1 }, .{ .row = -1, .column = 0 }, .{ .row = -1, .column = 1 },
    .{ .row = 0, .column = -1 },  .{ .row = 0, .column = 1 },  .{ .row = 1, .column = -1 },
    .{ .row = 1, .column = 0 },   .{ .row = 1, .column = 1 },
};

fn out_of_bounds(row: isize, column: isize) bool {
    return row < 0 or row >= grid_size or column < 0 or column >= grid_size;
}

fn get_cell(grid: *const Grid, row: isize, column: isize) u8 {
    return grid[@intCast(row)][@intCast(column)];
}

fn set_cell(grid: *Grid, row: isize, column: isize, value: u8) void {
    grid[@intCast(row)][@intCast(column)] = value;
}

fn is_paper(grid: *const Grid, row: isize, column: isize) bool {
    return get_cell(grid, row, column) == paper;
}

fn is_accessible(grid: *const Grid, row: isize, column: isize) bool {
    var count: usize = 0;
    for (directions) |direction| {
        if (out_of_bounds(row + direction.row, column + direction.column)) {
            continue;
        } 
        if (is_paper(grid, row + direction.row, column + direction.column)) {
            count += 1;
        }
    }
    return count < 4;
}

pub fn main() !void {
    var grid: Grid = undefined;

    var lines = std.mem.tokenizeAny(u8, input, "\n\r");

    var row: isize = 0;
    while (lines.next()) |line| {
        var column: isize = 0;
        for (line) |char| {
            set_cell(&grid, row, column, char);
            column += 1;
        }
        row += 1;
    }

    var num_accessible: isize = 0;
    for (0..grid_size) |i| {
        for (0..grid_size) |j| {
            if (is_paper(&grid, @intCast(i), @intCast(j)) and is_accessible(&grid, @intCast(i), @intCast(j))) {
                num_accessible += 1;
            }
        }
    }

    print("Part One: {}\n", .{num_accessible});
}
