import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import 'models.dart';

typedef void Callback(List<dynamic> list, int h, int w);

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  final String model;

  Camera(this.cameras, this.model, this.setRecognitions);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  // late CameraController controller;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();

    File img = File('assets/cup2.png');
    Tflite.detectObjectOnImage(
        path:img.path ,
        imageMean: 127.5, // defaults to 0.0
        numResultsPerClass: 2,
        imageStd:
        255.0, // defaults to https://github.com/shaqian/flutter_tflite/blob/master/lib/tflite.dart#L219
        // outputType: "png", // defaults to "png"
        asynch: true // defaults to true
      // bytesList: img.planes.map((plane) {
      //   return plane.bytes;
      // }).toList(),
      // imageHeight: img.height,
      // imageWidth: img.width,
      // numResults: 2,
    )
        .then((recognitions) {
      int endTime = DateTime.now().millisecondsSinceEpoch;
      print("Detection -------------------------- took ");

      widget.setRecognitions(recognitions!, 300, 300);

      isDetecting = false;
    });

    // if (widget.cameras == null || widget.cameras.length < 1) {
    //   print('No camera is found');
    // } else {
    //   controller = CameraController(
    //     widget.cameras[0],
    //     ResolutionPreset.high,
    //   );
    //
    //   controller.initialize().then((_) {
    //     if (!mounted) {
    //       return;
    //     }
    //     setState(() {});

        //   controller.startImageStream((CameraImage img) {
        //     if (!isDetecting) {
        //       isDetecting = true;
        //
        //       int startTime = DateTime.now().millisecondsSinceEpoch;
        //
        //       if (widget.model == mobilenet) {
        //
        //       } else if (widget.model == posenet) {
        //         Tflite.runPoseNetOnFrame(
        //           bytesList: img.planes.map((plane) {
        //             return plane.bytes;
        //           }).toList(),
        //           imageHeight: img.height,
        //           imageWidth: img.width,
        //           numResults: 2,
        //         ).then((recognitions) {
        //           int endTime = DateTime.now().millisecondsSinceEpoch;
        //           print("Detection took ${endTime - startTime}");
        //
        //           widget.setRecognitions(recognitions!, img.height, img.width);
        //
        //           isDetecting = false;
        //         });
        //       } else {
        //         Tflite.detectObjectOnFrame(
        //           bytesList: img.planes.map((plane) {
        //             return plane.bytes;
        //           }).toList(),
        //           model: widget.model == yolo ? "YOLO" : "SSDMobileNet",
        //           imageHeight: img.height,
        //           imageWidth: img.width,
        //           imageMean: widget.model == yolo ? 0 : 127.5,
        //           imageStd: widget.model == yolo ? 255.0 : 127.5,
        //           numResultsPerClass: 1,
        //           threshold: widget.model == yolo ? 0.2 : 0.4,
        //         ).then((recognitions) {
        //           int endTime = DateTime.now().millisecondsSinceEpoch;
        //           print("Detection took ${endTime - startTime}");
        //
        //           widget.setRecognitions(recognitions!, img.height, img.width);
        //
        //           isDetecting = false;
        //         });
        //       }
        //     }
        //   });
    //   });
    // }
  }

  @override
  void dispose() {
    // controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (controller == null || !controller.value.isInitialized) {
    //   return Container();
    // }

    Size? tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    // tmp = controller.value.previewSize;
    var previewH = math.max(tmp!.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight:
          screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
          screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: Container(
        height: 300,
        width: 300,
        child: Image.asset("assets/cup2.png") ,
      ),
    );
  }
}
