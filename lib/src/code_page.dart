import 'package:flutter/material.dart';
import 'package:flutter_easylogger/src/util/code_util.dart';

import 'syntax_highlighter.dart';

class CodePage extends StatefulWidget {
  String? title;

  String? fileUri;

  CodePage({Key? key, this.fileUri}) : super(key: key);

  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  String? _code;

  @override
  void initState() {
    super.initState();
    CodeUtil.getCode(widget.fileUri).then((value) {
      if (mounted) {
        setState(() {
          _code = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ""),
      ),
      body: _getBody1(),
    );
  }

  Widget _getBody() {
    final SyntaxHighlighterStyle style =
        Theme.of(context).brightness == Brightness.dark
            ? SyntaxHighlighterStyle.darkThemeStyle()
            : SyntaxHighlighterStyle.lightThemeStyle();
    return SingleChildScrollView(
      child: Container(
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontFamily: 'monospace', fontSize: 10.0),
            children: <TextSpan>[
              DartSyntaxHighlighter(style).format(_code ?? "正在查找中。。。"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBody1() {
    final SyntaxHighlighterStyle style =
        Theme.of(context).brightness == Brightness.dark
            ? SyntaxHighlighterStyle.darkThemeStyle()
            : SyntaxHighlighterStyle.lightThemeStyle();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontFamily: 'monospace', fontSize: 10.0),
            children: <TextSpan>[
              DartSyntaxHighlighter(style).format(_code ?? "正在查找中。。。"),
            ],
          ),
        ),
      ),
    );
  }
}
