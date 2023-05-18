import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:v2rayadmin/viewModel/homeViewModel/homeViewModel.dart';

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
  double _secondsRemaining = 1;
  Timer _timer = Timer(const Duration(milliseconds: 0), () {});

  @override
  void initState() {
    super.initState();
    widget.homeVM.isDetecting = false;
    startTimer();
  }
  void startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
        if (_secondsRemaining > 0) {
          widget.homeVM.isDetecting = false;
          _secondsRemaining--;
        } else {
          setState(() {
            widget.homeVM.isDetecting = true;
            _secondsRemaining =1;
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
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: OverflowBox(
        maxHeight: widget.height,
        maxWidth: widget.width,
        alignment: AlignmentDirectional.center,
        child:Stack(
          children: [
            Container(
              height: widget.height,
              width: widget.width,
              child:widget.homeVM.isDetecting == true? FutureBuilder(
                future:widget.homeVM.fileFromImageUrl(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    try{
                      Tflite.detectObjectOnImage(
                        path: snapshot.data!.path,
                        numResultsPerClass: 1,
                        threshold:  0.5,
                      ).then((recognitions)async {
                        widget.setRecognitions(recognitions!, widget.height.toInt(), widget.width.toInt());
                      });
                    }catch(e){}
                    return Image.file(snapshot.data!,fit: BoxFit.fitWidth);
                  }else if(snapshot.hasError){
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
          ],
        ),
      ),
    );
  }
  Widget defaultPic(){
    return widget.homeVM.lastFile != null ?Image.file(widget.homeVM.lastFile!,fit: BoxFit.fitWidth):
    const Center(child: CircularProgressIndicator(),);
  }
}
