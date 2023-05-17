import 'package:flutter/material.dart';
import 'dart:math' as math;

class BndBox extends StatelessWidget {
  final List<dynamic>? results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  double h_y =-1 ;
  double w_x =-1 ;
  BndBox(this.results, this.previewH, this.previewW, this.screenH, this.screenW);

  @override
  Widget build(BuildContext context) {
    List<Widget> _renderBoxes() {
      if(results != null){
        return results!.map((re) {
          var x0 = re["rect"]["x"];
          var w0 = re["rect"]["w"];
          var y0 = re["rect"]["y"];
          var h0 = re["rect"]["h"];
          h_y = 0.5-(y0 + h0/2);
          w_x = 0.5-(x0 + w0/2);
          var scaleW, scaleH, x, y, w, h;

          if (screenH / screenW > previewH / previewW) {
            scaleW = screenH / previewH * previewW;
            scaleH = screenH;
            var difW = (scaleW - screenW) / scaleW;
            x = (x0 - difW / 2) * scaleW;
            w = w0 * scaleW;
            if (x0 < difW / 2) w -= (difW / 2 - x0) * scaleW;
            y = y0 * scaleH;
            h = h0 * scaleH;
          } else {
            scaleH = screenW / previewW * previewH;
            scaleW = screenW;
            var difH = (scaleH - screenH) / scaleH;
            x = x0 * scaleW;
            w = w0 * scaleW;
            y = (y0 - difH / 2) * scaleH;
            h = h0 * scaleH;
            if (y0 < difH / 2) h -= (difH / 2 - y0) * scaleH;
          }
          Size size = MediaQuery.of(context).size;
          return Positioned(
            left:(size.width/2 - 160)+ math.max(0, x) ,
            top:(size.height/2 - 120)+math.max(0, y),
            width: w,
            height: h,
            child:re["detectedClass"] != "kldwqf"? Container(
              padding: const EdgeInsets.only(top: 5.0, left: 5.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 3.0,
                ),
              ),
              child: Text(
                "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}% ",
                // "\n ${status()}"
                    // "x:${((x0 as double) * 100).toInt()},y:${((y0 as double) * 100).toInt()}"
                    // "\n h:${((h0 as double) * 100).toInt()},w:${((w0 as double) * 100).toInt()}"
                    // "\n ${((y0 as double)*100).toInt()}/100 - ${((h0 as double) *100).toInt()}/100 ",
                style: const TextStyle(
                  color:Colors.red,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ):Container(),
          );
        }).toList();
      }else{
        return [];
      }
    }
    return Stack(
      children:  _renderBoxes(),
    );
  }
  String status(){
    double goal = 0.05;
    int verticalState = 0;
    int horizantalState = 0;

    if((h_y > goal)){
      verticalState = 1;
    }
    if((h_y < goal)){
      verticalState = -1;
    }

    if((w_x > goal)){
      horizantalState = 1;
    }
    if((w_x < goal)){
      horizantalState = -1;
    }
    if((w_x >=-goal && w_x <= goal)){
      horizantalState = 0;
    }
    if((h_y >=-goal && h_y <= goal)){
      verticalState = 0;
    }
    return "$verticalState   $horizantalState";
  }
}