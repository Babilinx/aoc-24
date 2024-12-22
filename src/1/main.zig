const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();


    var location_ids_a = std.ArrayList(i32).init(allocator);
    var location_ids_b = std.ArrayList(i32).init(allocator);

    const file = std.fs.cwd().openFile("src/1/input", .{}) catch |err| {
        std.log.err("Failed to open the file: {s}", .{@errorName(err)});
        return;
    };
    defer file.close();

    while (file.reader().readUntilDelimiterOrEofAlloc(allocator, '\n', std.math.maxInt(usize)) catch |err| {
        std.log.err("Failed to read line: {s}", .{@errorName(err)});
        return;
    }) |line| {

        var it = std.mem.tokenizeScalar(u8, line, ' ');
        try location_ids_a.append(try std.fmt.parseInt(i32, it.next().?, 10));
        try location_ids_b.append(try std.fmt.parseInt(i32, it.next().?, 10));
    }

    std.mem.sort(i32, location_ids_a.items, {}, comptime std.sort.asc(i32));
    std.mem.sort(i32, location_ids_b.items, {}, comptime std.sort.asc(i32));

    var diff: u32 = 0;

    for (location_ids_a.items, location_ids_b.items) |a, b| {
        diff += @abs(a - b);
    }

    std.debug.print("Day 1 answer: {}\n", .{diff});
}
