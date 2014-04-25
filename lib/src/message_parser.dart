part of irc_message;

class MessageParser extends Converter {

    Message convert(String line) {
        return this._convert(line);
    }

    Message _convert(String line) {
        Message result = new Message({}, "", "", []);

        int position = 0;
        int nextSpace = 0;

        if (line[0] == "@") {
            nextSpace = line.indexOf(" ");

            if (nextSpace == -1) return null;

            var rawTags = line.substring(1, nextSpace).split(";");

            rawTags.forEach((tagPair) {
                var split = tagPair.split("=");
                var tag = split[0];
                var value = (split.length == 2)
                          ? split[1]
                          : true;

                result.tags[tag] = value;
            });

            position = nextSpace + 1;
        }

        while (line[position] == " ") position++;

        if (line[position] == ":") {
            nextSpace = line.indexOf(" ", position);

            if (nextSpace == -1) return null;

            result.prefix = line.substring(position + 1, nextSpace);
            position = nextSpace + 1;

            while (line[position] == " ") position++;
        }

        nextSpace = line.indexOf(" ", position);

        if (nextSpace == -1) {
            if (line.length > position) {
                result.command = line.substring(position);
            }

            return result;
        }

        result.command = line.substring(position, nextSpace);

        position = nextSpace + 1;

        while (line.length > position && line[position] == " ") position++;

        while (position < line.length) {
            nextSpace = line.indexOf(" ", position);

            if (line[position] == ":") {
                var param = line.substring(position + 1);
                result.params.add(param);
                break;
            }

            if (nextSpace != -1) {
                var param = line.substring(position, nextSpace);
                result.params.add(param);

                position = nextSpace + 1;

                while (line[position] == " ") position++;

                continue;
            }

            if (nextSpace == -1) {
                var param = line.substring(position);
                result.params.add(param);

                break;
            }
        }

        return result;
    }

    StringConversionSink startChunkedConversion(Sink<String> sink) {
        if (sink is! StringConversionSink) {
            sink = new StringConversionSink.from(sink);
        }
        return new _MessageParserSink(this, sink);
    }
}

class _MessageParserSink extends StringConversionSinkBase {
    final MessageParser _converter;
    final StringConversionSink _sink;

    _MessageParserSink(this._converter, this._sink);

    void addSlice(String chunk, int start, int end, bool isLast) {
        var result = this._converter._convert(chunk);

        _sink.add(result);
        if (isLast) _sink.close();
    }
}
