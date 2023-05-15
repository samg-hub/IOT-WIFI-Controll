import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

File? lastFile ;

typedef void Callback(List<dynamic> list, int h, int w);

class Camera extends StatefulWidget {
  final Callback setRecognitions;
  final String model;
  final String picAddress;

  Camera(this.model, this.setRecognitions,this.picAddress);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  // late CameraController controller;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();
    isDetecting = false;
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size? tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    // tmp = controller.value.previewSize;
    var previewH = math.max(tmp!.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight: 300,
      maxWidth: 300,
      alignment: AlignmentDirectional.topStart,
      child:InkWell(
        onTap: (){
          setState(() {
            isDetecting = false;
          });
        },
        child: Container(
          color: Colors.white,
          height: 300,
          width: 300,
          child:lastFile == null? FutureBuilder(
            future:fileFromImageUrl(),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Container(color: Colors.white,child: const Center(child: Text("waiting",style: TextStyle(color: Colors.black),),),);
              }else if(snapshot.connectionState == ConnectionState.done){
                  print("Get image on ${snapshot.data!}");
                  Tflite.detectObjectOnImage(
                    path: snapshot.data!.path,
                    imageMean: 127.5, // defaults to 0.0
                    numResultsPerClass: 1,
                    threshold:  0.4,
                    imageStd:127.5,
                    asynch: true, // defaults to true
                  ).then((recognitions) {
                    isDetecting = true;
                    widget.setRecognitions(recognitions!, 300, 300);
                  });
                  return Image.file(snapshot.data!);
              }else{
                return Container(color: Colors.red,child: const Center(child: Text("Error Loading Image!"),),);
              }
            },
          ):InkWell(
            onTap: (){
              setState(() {
                isDetecting = false;
              });
            },
            child: Image.file(lastFile!),
          ),
        ),
      )
      );
  }
  Future<File?> fileFromImageUrl() async {
    if(!isDetecting){
      isDetecting = true;
      print("start to file from Image URL");
      File response = await http.get(Uri.parse(widget.picAddress)).then((response)async{
        final documentDirectory = await getApplicationDocumentsDirectory();
        final file = File(join(documentDirectory.path, '${generatePassword(6)}.jpg'));
        file.writeAsBytesSync(response.bodyBytes);
        print("response Image File = ${file.path} / ${response.statusCode}");
        lastFile = file;
        return file;
      }).onError((error, stackTrace){
        print("error");
        return Future.error(error.toString());
      });
      closeInAppWebView().toString();
      return response;
    }
  }
  String generatePassword(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }
}
