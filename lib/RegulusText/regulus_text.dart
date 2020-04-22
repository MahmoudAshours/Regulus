import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:regulus/RegulusText/regulustext_stream.dart'; 

class RegulusText extends StatefulWidget {
  final bool show;
  final Text child;
  RegulusText({@required this.child, this.show = false});

  @override
  _RegulusTextState createState() => _RegulusTextState();
}

class _RegulusTextState extends State<RegulusText> {
  RegulusTextStream _bloc = RegulusTextStream();
  @override
  void initState() {
    super.initState();
    // _bloc.setShowBool(widget.show);
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        Overlay.of(context).insert(
          OverlayEntry(
            builder: (_) => OverlayClass(bloc: _bloc),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: StreamBuilder<double>(
        stream: _bloc.getWidth(),
        builder: (context, borderRadius) {
          return StreamBuilder<Color>(
            stream: _bloc.getColor(),
            builder: (context, color) {
              return StreamBuilder<Color>(
                stream: _bloc.getShadowColor(),
                builder: (context, shadowColor) {
                  return DefaultTextStyle(
                    style: TextStyle(
                        color: color.data, backgroundColor: shadowColor.data),
                    child: widget.child,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class OverlayClass extends StatefulWidget {
  final RegulusTextStream bloc;
  OverlayClass({this.bloc});
  @override
  _OverlayClassState createState() => _OverlayClassState();
}

class _OverlayClassState extends State<OverlayClass> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: widget.bloc.getShowBool(),
      builder: (context, AsyncSnapshot<bool> showBool) {
        print(showBool.data);
        if (showBool.data == null || !showBool.data)
          return AnimatedPositioned(
            duration: Duration(seconds: 2),
            left: 20,
            top: 60,
            width: 300,
            height: 300,
            child: SingleChildScrollView(
              child: Material(
                child: Container(
                  color: Colors.black,
                  child: Column(
                    children: <Widget>[
                      StreamBuilder<Color>(
                        stream: widget.bloc.getColor(),
                        builder: (context, snapshot) {
                          return ExpansionTile(
                            title: Text('Color',
                                style: TextStyle(color: Colors.blue)),
                            children: [
                              ColorPicker(
                                pickerColor: snapshot.data ?? Colors.red,
                                onColorChanged: (c) =>
                                    widget.bloc.setColor().add(c),
                                colorPickerWidth: 300,
                                displayThumbColor: true,
                                showLabel: true,
                                pickerAreaHeightPercent: 0.8,
                              ),
                            ],
                          );
                        },
                      ),
                      StreamBuilder<Color>(
                        stream: widget.bloc.getShadowColor(),
                        builder: (context, snapshot) {
                          return ExpansionTile(
                            title: Text('Background Color',
                                style: TextStyle(color: Colors.blue)),
                            children: [
                              ColorPicker(
                                pickerColor: snapshot.data ?? Colors.white,
                                onColorChanged: (c) =>
                                    widget.bloc.setShadowColor().add(c),
                                colorPickerWidth: 300,
                                displayThumbColor: true,
                                showLabel: true,
                                pickerAreaHeightPercent: 0.8,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        return SizedBox.shrink();
      },
    );
  }
}
