import 'package:flutter/material.dart';

class TestOverLay {
  static OverlayEntry? _holder;

  static late  Widget view;

  static void remove() {
    if (_holder != null) {
      _holder?.remove();
      _holder = null;
    }
  }

  static void show({required BuildContext context, required Widget view}) {
    TestOverLay.view = view;

    remove();
    //创建一个OverlayEntry对象
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      return new Positioned(
          top: MediaQuery.of(context).size.height * 0.7,
          child: _buildDraggable(context));
    });

    //往Overlay中插入插入OverlayEntry
    Overlay.of(context)?.insert(overlayEntry);

    _holder = overlayEntry;
  }

  static _buildDraggable(context) {
    return  Draggable(
      child: view,
      feedback: view,
      onDragStarted: (){
      },
      onDragEnd: (detail) {
        createDragTarget(offset: detail.offset, context: context);
      },
      childWhenDragging: Container(),
    );
  }

  static void refresh() {
    _holder?.markNeedsBuild();
  }

  static void createDragTarget({Offset? offset, BuildContext? context}) {
    if (_holder != null) {
      _holder?.remove();
    }

    _holder =  OverlayEntry(builder: (context) {
      bool isLeft = true;
      if (offset!.dx + 100 > MediaQuery.of(context).size.width / 2) {
        isLeft = false;
      }

      double maxY = MediaQuery.of(context).size.height - 100;

      return  Positioned(
          top: offset.dy < 50 ? 50 : offset.dy < maxY ? offset.dy : maxY,
          left: isLeft ? 0 : null,
          right: isLeft ? null : 0,
          child: DragTarget(
            onWillAccept: (data) {
              print('onWillAccept: $data');
              return true;
            },
            onAccept: (data) {
              print('onAccept: $data');
              // refresh();
            },
            onLeave: (data) {
              print('onLeave');
            },
            builder: (BuildContext context, List incoming, List rejected) {
              return _buildDraggable(context);
            },
          ));
    });
    Overlay.of(context!)!.insert(_holder!);
  }
}