import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import '../components/camera.dart';
import '../components/bndbox.dart';

class HomePage extends StatefulWidget {
  HomePage();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _recognitions = [];
  int _imageHeight = 200;
  int _imageWidth = 200;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    loadModel();
    super.initState();

  }

  loadModel() async {
    String? res = await Tflite.loadModel(
      model: "assets/ssd_mobilenet.tflite",
      labels: "assets/ssd_mobilenet.txt");
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {

    Size screen = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Camera(
                setRecognitions,
                // "https://s8.uupload.ir/files/images_86vx.jpeg",
                // "https://s8.uupload.ir/files/cup2_0vwl.jpeg",
                "https://s8.uupload.ir/files/download_9sk3.jpeg",
                _imageHeight.toDouble(),
                _imageWidth.toDouble()
              ),
              BndBox(
                  _recognitions ?? <Widget>[],
                  math.max(_imageHeight, _imageWidth),
                  math.min(_imageHeight, _imageWidth),
                  _imageWidth.toDouble(),
                  _imageHeight.toDouble()
              ),
            ],
          ),
        )
    );
  }
}