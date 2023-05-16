import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';
import 'package:path/path.dart';

File? lastFile ;

typedef void Callback(List<dynamic> list, int h, int w);

class Camera extends StatefulWidget {
  final Callback setRecognitions;
  final String picAddress;
  final double height;
  final double width;
  Camera(this.setRecognitions,this.picAddress,this.height,this.width);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  // late CameraController controller;
  bool isDetecting = false;
  int _secondsRemaining = 10;
  Timer _timer = Timer(const Duration(milliseconds: 0), () {});

  @override
  void initState() {
    super.initState();
    isDetecting = false;
    startTimer();
  }
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          isDetecting = false;
          _secondsRemaining--;
          print("timer = $_secondsRemaining");
        } else {
          setState(() {
            isDetecting = true;
            print("--------------------------timer restart");
            _secondsRemaining =10;
          });
        }
    });
  }
  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      maxHeight: widget.height,
      maxWidth: widget.width,
      alignment: AlignmentDirectional.topStart,
      child:Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.red,width: 3),
              borderRadius: const BorderRadius.all(Radius.circular(10))
            ),
            height: widget.height,
            width: widget.width,
            child:isDetecting == true? FutureBuilder(
              future:fileFromImageUrl2(),
              builder: (context, snapshot){
                print("FutureBuilder Run : ${snapshot.connectionState.name} - ${snapshot.hasData}");
                if(snapshot.hasData){
                  try{
                    Tflite.detectObjectOnImage(
                      path: snapshot.data!.path,
                      numResultsPerClass: 5,
                      threshold:  0.3,
                    ).then((recognitions)async {
                      widget.setRecognitions(recognitions!, widget.height.toInt(), widget.width.toInt());
                    });
                  }catch(e){
                    print("error -> $e");
                  }
                  return Image.file(snapshot.data!);
                }else if(snapshot.hasError){
                  print("Status Tap tp try again...${snapshot.connectionState.name}");
                  return  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.rotate_left_outlined,color: Colors.black,),
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: const Center(child: Text("Error Getting Data!, try again",style: TextStyle(color: Colors.black),),),
                      )
                    ],
                  );
                }else{
                  return defaultPic();
                }
              },
            ):defaultPic(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomLeft: Radius.circular(10))
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                child: Text("Disconnected"),
              ),
            ),
          )
        ],
      ),
      );
  }
  Widget defaultPic(){
    return lastFile != null ?Image.file(lastFile!):
    const Center(child: CircularProgressIndicator(),);
  }
  Future<File?> fileFromImageUrl2() async {
    if(isDetecting == true) {
      print("start to file from Image URL");
      try {
        final response = await http.get(Uri.parse(widget.picAddress));
        final documentDirectory = await getApplicationDocumentsDirectory();
        final file = File(join(documentDirectory.path, '${generatePassword(6)}.jpg'));
        file.writeAsBytesSync(response.bodyBytes);
        print("---------------------------------------------------------response Image File = ${response.statusCode}");
        lastFile = file;
        return file;
      } catch (error) {
        print("error on fileFromImageUrl -> $error");
        return null;
      }
    }else {
      return null;
    }
  }
  String generatePassword(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }
}
