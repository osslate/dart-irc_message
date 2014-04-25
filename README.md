# dart-irc_message
> Performant IRC parser for Dart based on [irc-message](https://github.com/expr/irc-message).

irc_message implements a Converter, and allows you to convert raw IRC lines individually or transform them from another stream (i.e. a Socket).

## Installation

Add `irc_message` as a dependency of your project via `pubspec.yaml`.

```yaml
dependencies:
  irc_message: any
```

## Usage

### Converting A Single Line

```dart
import "package:irc_message/irc_message.dart";

void convert() {
    MessageParser messageParser = new MessageParser();
    Message message = messageParser.convert(":NickServ!ns@services. PRIVMSG #Test :Hello!");

    String command = message.command;
    String prefix = message.prefix;
    String params = message.params.join(", ");

    print("$command from $prefix: $params");
}

void main() => convert();
```

### Converting Socket Stream

```dart
import "package:irc_message/irc_message.dart";
import "dart:convert";
import "dart:io";

const HOSTNAME = "irc.freenode.net";
const PORT = 6667;

void socketTest() {
    Socket.connect(HOSTNAME, PORT).then((stream) {
        stream.transform(UTF8.decoder)
              .transform(const LineSplitter())
              .transform(new MessageParser())
              .listen((message) {
                   String command = message.command;
                   String prefix = message.prefix;
                   String params = message.params.join(", ");

                   print("$command from $prefix: $params");
               });
    });
}

void main() => socketTest();
```
