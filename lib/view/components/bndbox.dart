import 'package:flutter/material.dart';
import 'dart:math' as math;

class BndBox extends StatelessWidget {
  final List<dynamic>? results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
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
            child:re["detectedClass"] == "Ball" ||re["detectedClass"] == "Gate" ? Container(
              padding: const EdgeInsets.only(top: 5.0, left: 5.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 3.0,
                ),
              ),
              child: Text(
                "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}% ",
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
}