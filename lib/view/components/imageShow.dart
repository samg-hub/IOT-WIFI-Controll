import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:v2rayadmin/viewModel/homeViewModel/homeViewModel.dart';
import '../../constant/ui.dart';

typedef void Callback(List<dynamic> list, int h, int w);

class ImageShow extends StatefulWidget {
  final HomeViewModel homeVM;
  final Callback setRecognitions;
  final double height;
  final double width;
  ImageShow(this.homeVM,this.setRecognitions,this.height,this.width);

  @override
  _ImageShowState createState() => _ImageShowState();
}

class _ImageShowState extends State<ImageShow> {
  // late CameraController controller;
  int _secondsRemaining = 5;
  Timer _timer = Timer(const Duration(milliseconds: 0), () {});

  @override
  void initState() {
    super.initState();
    widget.homeVM.isDetecting = false;
    startTimer();
  }
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          widget.homeVM.isDetecting = false;
          _secondsRemaining--;
          print("timer = $_secondsRemaining");
        } else {
          setState(() {
            widget.homeVM.isDetecting = true;
            print("--------------------------timer restart");
            _secondsRemaining =5;
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
              color: Colors.transparent,
              // border: Border.all(color: cRed,width: 3),
              borderRadius: const BorderRadius.all(Radius.circular(10))
            ),
            height: widget.height,
            width: widget.width,
            child:widget.homeVM.isDetecting == true? FutureBuilder(
              future:widget.homeVM.fileFromImageUrl(),
              builder: (context, snapshot){
                print("FutureBuilder Run : ${snapshot.connectionState.name} - ${snapshot.hasData}");
                if(snapshot.hasData){
                  try{
                    Tflite.detectObjectOnImage(
                      path: snapshot.data!.path,
                      numResultsPerClass: 1,
                      threshold:  0.3,
                    ).then((recognitions)async {
                      widget.setRecognitions(recognitions!, widget.height.toInt(), widget.width.toInt());
                    });
                  }catch(e){
                    print("error -> $e");
                  }
                  return Image.file(snapshot.data!,fit: BoxFit.fitWidth,);
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
                        child:Center(child: Text("Error Getting Data!, try again in $_secondsRemaining",
                          style: const TextStyle(color: Colors.black),),),
                      )
                    ],
                  );
                }else{
                  return defaultPic();
                }
              },
            ):defaultPic(),
          ),
          // Positioned(
          //   top: 56,
          //   left: 0,
          //   child: Container(
          //     decoration: BoxDecoration(
          //         color: cRed,
          //         borderRadius: const BorderRadius.only(topRight: Radius.circular(10),bottomLeft: Radius.circular(10))
          //     ),
          //     child: const Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
          //       child: Text("Disconnected"),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
  Widget defaultPic(){
    return widget.homeVM.lastFile != null ?Image.file(widget.homeVM.lastFile!,fit: BoxFit.fitWidth):
    const Center(child: CircularProgressIndicator(),);
  }
}
