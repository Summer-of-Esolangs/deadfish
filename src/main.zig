const std = @import("std");
const Io = std.Io;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const alloc = init.gpa;

    var args = init.minimal.args.iterate();
    _ = args.next();

    var source: []u8 = undefined;

    if (args.next()) |file_path| {
        source = try std.Io.Dir.cwd().readFileAlloc(
            io,
            file_path,
            alloc,
            .unlimited,
        );
    } else {
        std.debug.print("Missing deadfish file!!!\n", .{});
        std.process.exit(1);
    }

    defer alloc.free(source);

    var register: isize = 0;

    for (source) |cmd| {
        switch (cmd) {
            'i' => register += 1,
            'd' => register -= 1,
            's' => register *= register,
            'o' => std.debug.print("{}\n", .{register}),
            else => {},
        }

        if (register == -1 or register == 256) register = 0;
    }
}
