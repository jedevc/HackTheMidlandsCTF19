module flag;

import std.base64;
import std.algorithm;
import std.string;
import std.conv;
import std.traits;

const string data = "FSEAr3pjq183nQD3K1p0AI9ZZQp1KmOTK2AfZJALsD==";

alias base64decode = Base64.decode;

string get_flag(uint i) {
    if (i % 10_000 == 1337) {
        if ((i % 100_000_000) / 10_000 == 1337) {
            // i = 13371337
            return data
                .map!rot13
                .text()
                .base64decode()
                .map!(ch => to!string(to!char(ch)))
                .join();
        }
    }

    return "";
}

Char rot13(Char)(Char ch) if (isSomeChar!(Char)) {
    if (ch >= 'a' && ch <= 'z') {
        return (ch - 'a' + 13) % 26 + 'a';
    } else if (ch >= 'A' && ch <= 'Z') {
        return (ch - 'A' + 13) % 26 + 'A';
    } else {
        return ch;
    }
}
