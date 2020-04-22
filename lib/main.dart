import 'package:flutter/material.dart';
import 'package:regulus/RegulusContainer/regulus_container.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        backgroundColor: Color(0xff363A44),
        body: Center(
          child: RegulusContainer(
            child: FlutterLogo(size: 400,colors: Colors.amber,),
          ),
        ),
      ),
    );
  }
}
