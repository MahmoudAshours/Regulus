import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:regulus/RegulusContainer/reguluscon_stream.dart';

class RegulusContainer extends StatefulWidget {
  final bool show;
  final FlutterLogo child;
  RegulusContainer({@required this.child, this.show});

  @override
  _RegulusContainerState createState() => _RegulusContainerState();
}

class _RegulusContainerState extends State<RegulusContainer> {
  RegulusContainerStream _bloc = RegulusContainerStream();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        Overlay.of(context).insert(
          OverlayEntry(
            builder: (_) => OverlayClass(bloc: _bloc),
          ),
        );

        _bloc.setShowBool().add(widget.show);
        print(widget.show);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: StreamBuilder<double>(
        stream: _bloc.getWidth(),
        builder: (context, borderRadius) {
          return StreamBuilder<double>(
            stream: _bloc.getElevation(),
            builder: (context, elevationSnapshot) {
              return StreamBuilder<Color>(
                stream: _bloc.getColor(),
                builder: (context, color) {
                  return StreamBuilder<Color>(
                    stream: _bloc.getShadowColor(),
                    builder: (context, shadowColor) {
                      return PhysicalModel(
                        color: color.data ?? Colors.transparent,
                        borderRadius:
                            BorderRadius.circular(borderRadius.data ?? 0),
                        child: widget.child,
                        shadowColor: shadowColor.data ?? Colors.black,
                        elevation: elevationSnapshot.data ?? 0,
                        clipBehavior: Clip.hardEdge,
                      );
                    },
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
  final RegulusContainerStream bloc;
  OverlayClass({this.bloc});
  @override
  _OverlayClassState createState() => _OverlayClassState();
}

class _OverlayClassState extends State<OverlayClass> {
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
                      StreamBuilder<double>(
                        stream: widget.bloc.getWidth(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return ExpansionTile(
                            title: Text(
                              'Border Radius',
                              style: TextStyle(color: Colors.blue),
                            ),
                            children: <Widget>[
                              Slider(
                                value: snapshot.data ?? 0,
                                max: 100,
                                min: 0,
                                onChanged: (r) => widget.bloc.setWidth().add(r),
                              )
                            ],
                          );
                        },
                      ),
                      StreamBuilder<double>(
                        stream: widget.bloc.getElevation(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return ExpansionTile(
                            title: Text('Elevation',
                                style: TextStyle(color: Colors.blue)),
                            children: <Widget>[
                              Slider(
                                value: snapshot.data ?? 0,
                                max: 100,
                                min: 0,
                                onChanged: (r) =>
                                    widget.bloc.setElevation().add(r),
                              )
                            ],
                          );
                        },
                      ),
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
                            title: Text('Shadow Color',
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
