part of irc_message;

class Message {
    Map tags;
    String prefix;
    String command;
    List params;

    Message(this.tags, this.prefix, this.command, this.params);

    String toString() {
        String repr = "";

        if (this.tags.length != 0) {
            repr += "@";
            this.tags.forEach((tag, value) {
                repr += value != true
                      ? "$tag=$value"
                      : tag;
                repr += ";";
            });

            repr = "${repr.substring(0, repr.length - 1)} ";
        }

        // append the prefix/hostmask
        if (this.prefix.length != 0) {
            repr += ":${this.prefix} ";
        }

        // append the command
        if (this.command.length != 0) {
            repr += "${this.command} ";
        }

        // append any command paramuments
        if (this.params.length != 0) {
            this.params.forEach((param) {
                if (param.indexOf(" ") == -1) {
                    repr += "$param ";
                } else {
                    repr += ":$param ";
                }
            });
        }

        return repr.substring(0, repr.length - 1);
    }

    bool hasHostmask() => this.prefix.indexOf("@") != -1 &&
                          this.prefix.indexOf("!") != -1;

    bool hasServerMask() => this.prefix.indexOf("@") == -1 &&
                            this.prefix.indexOf("!") == -1 &&
                            this.prefix.indexOf(".") != -1;

    String getHostmask() {
        String regex = new RegExp("[!@]");
        List extracts = this.prefix.split(regex);

        return {
            "nick": extracts[0],
            "ident": extracts[1],
            "hostname": extracts[2]
        };
    }
}
