const std = @import("std");

const Day = enum {
    @"1",
    @"1-2",
    @"2",
    @"3",
    All,
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const options = b.addOptions();

    const day: Day = b.option(Day, "day", "Build the code for this day") orelse Day.All;
    options.addOption(Day, "day", day);

    const exe = b.addExecutable(.{
        .name = "aoc-24",
        .root_source_file = switch (day) {
            Day.@"1" => b.path("src/1/main.zig"),
            Day.@"1-2" => b.path("src/1-2/main.zig"),
            else => return,
    },
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}
