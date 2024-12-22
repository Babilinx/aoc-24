const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var safe_reports: i32 = 0;

    const file = std.fs.cwd().openFile("src/2/input", .{}) catch |err| {
        std.log.err("Failed to open the file: {s}", .{@errorName(err)});
        return;
    };
    defer file.close();

    blk: while (file.reader().readUntilDelimiterOrEofAlloc(allocator, '\n', std.math.maxInt(usize)) catch |err| {
        std.log.err("Failed to read line: {s}", .{@errorName(err)});
        return;
    }) |line| {
        var it = std.mem.tokenizeScalar(u8, line, ' ');
        var previous: i32 = try std.fmt.parseInt(i32, it.next().?, 10);
        var current: i32 = try std.fmt.parseInt(i32, it.next().?, 10);
        var diff: u32 = @abs(previous - current);
        var biggering: bool = undefined;

        if (diff < 1 or diff > 3) {
            continue;
        }

        biggering = (current > previous);

        std.debug.print("current: {} previous: {} biggering: {}\n", .{ current, previous, biggering });
        previous = current;

        while (it.next()) |next| {
            current = try std.fmt.parseInt(i32, next, 10);
            diff = @abs(previous - current);
            std.debug.print("current: {} previous: {} biggering: {}\n", .{ current, previous, biggering });
            if (diff < 1 or diff > 3) {
                continue :blk;
            }
            if ((current > previous) != biggering) {
                continue :blk;
            }

            previous = current;
        }

        std.debug.print("End of line, safe report\n", .{});
        safe_reports += 1;
    }

    std.debug.print("Day 2 answer: {}\n", .{safe_reports});
}
