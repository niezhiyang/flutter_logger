import 'package:flutter/material.dart';
import 'package:flutter_easylogger/src/syntax_highlighter.dart';

import 'util/code_util.dart';

class CodeOverlay {
  static OverlayEntry? _entry;
  static bool isShow = false;

  static void show(BuildContext context, String? fileUri) {
    if (fileUri != null) {
      if (!isShow) {
        _entry = OverlayEntry(builder: (_) {
          return Scaffold(
              appBar: AppBar(
                title: Text(fileUri),
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    CodeOverlay.remove();
                  },
                ),
              ),
              body: CodeWidget(
                fileUri: fileUri,
              ));
        });
        Overlay.of(context)?.insert(_entry!);
        isShow = true;
      }
    }
  }

  static remove() {
    if (isShow) {
      _entry?.remove();
    }
    isShow = false;
  }
}

class CodeWidget extends StatefulWidget {
  String? title;

  String? fileUri;

  CodeWidget({Key? key, this.fileUri}) : super(key: key);

  @override
  _CodeWidgetState createState() => _CodeWidgetState();
}

class _CodeWidgetState extends State<CodeWidget> {
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
    return _getBody();
  }

  Widget _getBody() {
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
            style: const TextStyle(fontFamily: 'monospace', fontSize: 11.0),
            children: <TextSpan>[
              DartSyntaxHighlighter(style).format(_code ?? "正在查找中。。。"),
            ],
          ),
        ),
      ),
    );
  }
}
