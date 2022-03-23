const std = @import("std");
const testing = std.testing;
const mem = std.mem;
const print = std.debug.print;

/// find the length of a string
export fn stringLength(str: [*:0]const u8) u8 {
    var res: u8 = 0;
    var char = str[0];
    var ind: usize = 0;
    while (char != 0) { // while it is not null
        res += 1;
        ind += 1;
        char = str[ind];
    }
    return res;
}

/// takes a string and extracts characters
/// as long as a character is encountered
export fn extractChars(str: [*:0]const u8, res: [*]u8, end: u8) void {
    // count first
    //comptime var count: u8 = 0;
    var char = str[0];
    var ind: usize = 0;
    // while (char != end) { // while it is not null
    //     count += 1;
    //     ind += 1;
    //     char = str[ind];
    // }

    // now start filling
    ind = 0;
    char = str[ind];
    while (char != 0 and char != end) {
        res[ind] = char;
        ind += 1;
        char = str[ind];
    }
}

/// takes two strings and the length limit for comparision
/// the order doesn't matter
/// the length limit is a whole number of the characters to be compared
/// so as an example, a test for comparing "alice" and "alwin" for the first two characters should return zero
/// i.e. compareTo("alwin", "alice", 2) = 0 -- they're the same!
export fn compareTo(str1: [*:0]const u8, str2: [*:0]const u8) i32 {
    var res: i32 = 0;
    var l: usize = stringLength(str1); 
    // immediately return 0 fi both are equal
    if (mem.eql(u8,str1[0..l],str2[0..l])) {
        return res;
    } else { // if not, iterate over until you find distinct characters
    // return the ASCII difference between the first and second string
        var ind: usize = 0;
        var ch1 = str1[ind];
        var ch2 = str2[ind];
        while (ind < l) {
            if (ch1 != ch2) {
                // @intCast(), since your'e working with u8s
                res = @intCast(i32, ch1) - @intCast(i32, ch2);
                break;
            }
            ind += 1;
            ch1 = str1[ind];
            ch2 = str2[ind];
        }
    }
    return res;
}

// checks for strict equality between two strings
export fn equals(str1: [*:0]const u8, str2: [*:0]const u8) bool {
    var res = true;
    var i: usize = 0;
    var ch1 = str1[i];
    var ch2 = str2[i];
    while (ch1 != 0) { // while not null    
        if (ch1 != ch2) {
            return false;
        }
        i += 1;
        ch1 = str1[i];
        ch2 = str2[i];
    }
    return res;
}

/// checks if a given character is present in the string, if it does, it returns the character
// if not, it returns -1
pub fn indexOf(str: [*:0]const u8, ch: u8) !i32 {
    var found = false;
    var ind: usize = 0;
    var res: i32 = 0;
    var len: u8 = stringLength(str);
    while (ind < len) : (ind += 1) {
        if (str[ind] == ch) {
            found = true;
            res = @intCast(i32, ind);
            break;
        }
    }
    if (found == false) {
        res = -1;
    }
    return res;
}

/// checks if a given string starts with a phrase
export fn startsWith(str: [*:0]const u8, phrase: [*:0]const u8) bool {
    var pl = stringLength(phrase);
    var res = false;
    var ind: usize = 0;
    while (ind < pl) {
        res = if (str[ind] == phrase[ind]) true else false;
        ind += 1;
    }
    return res;
}

/// checks if a string ends with the phrase given
export fn endsWith(str: [*:0] const u8, phrase: [*:0] const u8) bool {
    var res = false;
    // using integers as index trackers
    // since when zero, they decrement to -1 and overflow the buffer
    // when declared to be unsigned
    var i: i32 = stringLength(str) - 1;
    var j: i32 = stringLength(phrase) - 1;
    while (j >= 0 and i >= 0) {
        // will not work without an @intCast
        // since elements are being accessed
        res = if (str[@intCast(usize, i)] == phrase[@intCast(usize, j)]) true else false;
        i -= 1;
        j -= 1;
    }
    return res;
}

/// get last index of a string
export fn lastIndexOf(str: [*:0]const u8) usize {
    return stringLength(str) - 1;
}

test "comparing string literals" {
    comptime var str1 = "alwin"; // you can also figure out the type at comptile time
    const str2 = "alice";
    // comparing just first two characters
    try testing.expectEqual(compareTo(str2, str1), -14);
    // finding the length of a string
    try testing.expectEqual(stringLength("somestring"), 10);
    // chekcing for strict equality
    try testing.expectEqual(equals("hello", "hello"), true);
    
    try testing.expect(startsWith("shelby","she"));
    try testing.expectEqual(endsWith("hello world", "world"), true);

    try testing.expect(lastIndexOf("world") == 4);

    try testing.expectEqual(indexOf("hola",'l'), 2);

    const str = "helloworld";
    var buf = [_]u8{0} ** str.len;
    extractChars(str, &buf, 'w');
    const slice: []u8 = buf[0..];
    print("slice is {s}\n",.{slice});
    try testing.expect(true);
}