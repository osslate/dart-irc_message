import "package:unittest/unittest.dart";
import "package:irc_message/irc_message.dart";

void main() {
    List<String> strings = [
        parse("FOO").toString(),
        parse(":test FOO").toString(),
        parse(":test!me@test.ing PRIVMSG #Test :This is a test").toString(),
        parse("PRIVMSG #foo :This is a test").toString(),
        parse(":test FOO bar baz quux").toString(),
        parse("@test=super;single :test!me@test.ing FOO bar baz quux :This is a test").toString()
    ];

    test("toString() == FOO", () {
        expect(strings[0], equals("FOO"));
    });

    test("toString() == :test FOO", () {
        expect(strings[1], equals(":test FOO"));
    });

    test("toString() == :test!me@test.ing PRIVMSG #Test :This is a test", () {
        expect(strings[2], equals(":test!me@test.ing PRIVMSG #Test :This is a test"));
    });

    test("toString() == PRIVMSG #foo :This is a test", () {
        expect(strings[3], equals("PRIVMSG #foo :This is a test"));
    });

    test("toString() == :test FOO bar baz quux", () {
        expect(strings[4], equals(":test FOO bar baz quux"));
    });

    test("toString() == @test=super;single :test!me@test.ing FOO bar baz quux :This is a test", () {
        expect(strings[5], equals("@test=super;single :test!me@test.ing FOO bar baz quux :This is a test"));
    });

    test("Prefixes are validated", () {
        var valid = parse(":hello!test@something.net COMMAND :t");
        var invalid = parse(":no COMMAND :t");

        expect(valid.hasHostmask(), equals(true));
        expect(invalid.hasHostmask(), equals(false));
    });

    test("Hostmasks are parsed properly", () {
        var hostmask = parse(":hello!test@something.net COMMAND :t").getHostmask();

        expect(hostmask, equals({
            "nick": "hello",
            "ident": "test",
            "hostname": "something.net"
        }));
    });

    test("Server masks are validated", () {
        var invalid = parse(":hello!test@something.net COMMAND :t");
        var valid = parse(":test.com COMMAND :t");

        expect(valid.hasServerMask(), equals(true));
        expect(invalid.hasServerMask(), equals(false));
    });

    
}
