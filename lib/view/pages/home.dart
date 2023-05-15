import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import 'camera.dart';
import 'bndbox.dart';
import 'models.dart';

class HomePage extends StatefulWidget {

  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _recognitions = [];
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "mobilenet";

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

  onSelect(model) {
    setState(() {
      _model = model;
    });
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
                _model,
                setRecognitions,
                // "https://s8.uupload.ir/files/images_86vx.jpeg",
                // "https://s8.uupload.ir/files/cup2_0vwl.jpeg",
                "https://s8.uupload.ir/files/download_9sk3.jpeg"
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: (){
                    setState(() {

                    });
                  },
                  child: Container(
                    color: Colors.yellow,
                    height: 56,
                    width: 130,
                  ),
                )
              ),
              BndBox(
                  _recognitions ?? <Widget>[],
                  math.max(_imageHeight, _imageWidth),
                  math.min(_imageHeight, _imageWidth),
                  300,
                  300,
                  _model
              ),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(math.max(_imageHeight, _imageWidth).toString()),
              //     Text(math.min(_imageHeight, _imageWidth).toString()),
              //     Text("--"+screen.height.toString()),
              //     Text("--"+screen.width.toString())
              //   ],
              // )
            ],
          ),
        )
    );
  }
}