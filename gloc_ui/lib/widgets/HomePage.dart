import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:gloc_ui/data/ClocRequest.dart';
import 'package:gloc_ui/data/ClocResult.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: _Dropzone()),
        ElevatedButton(
          onPressed: () {
            context.goNamed('loading',
                extra: ClocRequest(
                    'https://github.com/CS540-22/GLOC', RequestType.single));
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

class _Dropzone extends StatefulWidget {
  _Dropzone({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DropzoneState();
}

class _DropzoneState extends State<_Dropzone> {
  late DropzoneViewController dropController;
  bool isHighlighted = false;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
            color: isHighlighted ? Colors.green : Colors.white,
            child: Stack(children: [
              DropzoneView(
                operation: DragOperation.copy,
                cursor: CursorType.Default,
                onCreated: (ctrl) => dropController = ctrl,
                onHover: () {
                  setState(() => isHighlighted = true);
                },
                onLeave: () {
                  setState(() => isHighlighted = false);
                },
                onDrop: (ev) async {
                  try {
                    final bytes = await dropController.getFileData(ev);
                    List<ClocResult> result =
                        (json.decode(String.fromCharCodes(bytes)) as List)
                            .map((i) => ClocResult.fromJson(i))
                            .toList();
                    setState(() => isHighlighted = false);
                    if (result.length == 1) {
                      context.goNamed('details', extra: result[0]);
                    } else if (result.length > 1) {
                      context.goNamed('history', extra: result);
                    }
                  } catch (e) {
                    setState(() => isHighlighted = false);
                  }
                },
              ),
              Center(child: Text('Drop results here')),
            ])));
  }
}
