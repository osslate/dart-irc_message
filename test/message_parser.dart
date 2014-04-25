import "package:unittest/unittest.dart";
import "package:irc_message/irc_message.dart";

void main() {
    var p = new MessageParser();

    List<Message> objects = [
        p.convert("FOO"),
        p.convert(":test FOO"),
        p.convert(":test FOO    "),
        p.convert(":test!me@test.ing PRIVMSG #Test :This is a test"),
        p.convert("PRIVMSG #foo :This is a test"),
        p.convert(":test PRIVMSG foo :A string   with spaces   "),
        p.convert(":test     PRIVMSG    foo     :bar"),
        p.convert(":test FOO bar baz quux"),
        p.convert("FOO bar baz quux"),
        p.convert("FOO bar baz quux :This is a test"),
        p.convert(":test PRIVMSG #fo:oo :This is a test"),
        p.convert("@test=super;single :test!me@test.ing FOO bar baz quux :This is a test")
    ];

    test("Message should have command", () {
        var message = objects[0];

        expect(message.tags, equals({}));
        expect(message.prefix, equals(""));
        expect(message.command, equals("FOO"));
        expect(message.params, equals([]));
    });

    test("Message should have prefix, command", () {
        var message = objects[1];

        expect(message.tags, equals({}));
        expect(message.prefix, equals("test"));
        expect(message.command, equals("FOO"));
        expect(message.params, equals([]));
    });

    test("Message should have prefix, command (whitespace)", () {
        var message = objects[2];

        expect(message.tags, equals({}));
        expect(message.prefix, equals("test"));
        expect(message.command, equals("FOO"));
        expect(message.params, equals([]));
    });

    test("Message should have prefix, command, 2 params", () {
        var message = objects[3];

        expect(message.tags, equals({}));
        expect(message.prefix, equals("test!me@test.ing"));
        expect(message.command, equals("PRIVMSG"));
        expect(message.params, equals(["#Test", "This is a test"]));
    });

    test("Message should have command, 2 params", () {
        var message = objects[4];

        expect(message.tags, equals({}));
        expect(message.prefix, equals(""));
        expect(message.command, equals("PRIVMSG"));
        expect(message.params, equals(["#foo", "This is a test"]));
    });

    test("Message should have prefix, command, 2 params (whitespace 1)", () {
        var message = objects[5];

        expect(message.tags, equals({}));
        expect(message.prefix, equals("test"));
        expect(message.command, equals("PRIVMSG"));
        expect(message.params, equals(["foo", "A string   with spaces   "]));
    });

    test("Message should have prefix, command, 2 params (whitespace 2)", () {
        var message = objects[6];

        expect(message.tags, equals({}));
        expect(message.prefix, equals("test"));
        expect(message.command, equals("PRIVMSG"));
        expect(message.params, equals(["foo", "bar"]));
    });

    test("Message should have prefix, command, three params (non-trailing)", () {
        var message = objects[7];

        expect(message.tags, equals({}));
        expect(message.prefix, equals("test"));
        expect(message.command, equals("FOO"));
        expect(message.params, equals(["bar", "baz", "quux"]));
    });

    test("Message should have command, four params", () {
        var message = objects[8];

        expect(message.tags, equals({}));
        expect(message.prefix, equals(""));
        expect(message.command, equals("FOO"));
        expect(message.params, equals(["bar", "baz", "quux"]));
    });

    test("Message should have command, four params (trailing)", () {
        var message = objects[9];

        expect(message.tags, equals({}));
        expect(message.prefix, equals(""));
        expect(message.command, equals("FOO"));
        expect(message.params, equals(["bar", "baz", "quux", "This is a test"]));
    });

    test("Message should have prefix, command, two params (colon)", () {
        var message = objects[10];

        expect(message.tags, equals({}));
        expect(message.prefix, equals("test"));
        expect(message.command, equals("PRIVMSG"));
        expect(message.params, equals(["#fo:oo", "This is a test"]));
    });

    test("Message should have tags, prefix, command, params", () {
        var message = objects[11];

        expect(message.tags, equals({"test": "super", "single": true}));
        expect(message.prefix, equals("test!me@test.ing"));
        expect(message.command, equals("FOO"));
        expect(message.params, equals(["bar", "baz", "quux", "This is a test"]));
    });
}
