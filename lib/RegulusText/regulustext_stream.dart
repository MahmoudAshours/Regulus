import 'dart:async';

import 'package:flutter/material.dart';

class RegulusTextStream {
  StreamController<double> _borderRadiusController =
      StreamController.broadcast();
  Sink<double> setWidth() => _borderRadiusController.sink;
  Stream<double> getWidth() => _borderRadiusController.stream;

  StreamController<double> _elevationController = StreamController.broadcast();

  Sink<double> setElevation() => _elevationController.sink;
  Stream<double> getElevation() => _elevationController.stream;

  StreamController<Color> _colorController = StreamController.broadcast();

  Sink<Color> setColor() => _colorController.sink;
  Stream<Color> getColor() => _colorController.stream;

  StreamController<Color> _shadowColorController = StreamController.broadcast();

  Sink<Color> setShadowColor() => _shadowColorController.sink;
  Stream<Color> getShadowColor() => _shadowColorController.stream;

  StreamController<bool> _showToolsController = StreamController.broadcast();

  Sink<bool> setShowBool() => _showToolsController.sink;
  Stream<bool> getShowBool() => _showToolsController.stream;

  void dispose() {
    _borderRadiusController.close();
    _elevationController.close();
    _shadowColorController.close();
    _showToolsController.close();
    _colorController.close();
  }
}
