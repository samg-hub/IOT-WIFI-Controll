import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:provider/provider.dart';
import 'package:tflite/tflite.dart';
import 'package:v2rayadmin/constant/constants.dart';
import 'package:v2rayadmin/viewModel/homeViewModel/homeViewModel.dart';
import 'dart:math' as math;
import '../../constant/ui.dart';
import '../components/imageShow.dart';
import '../components/bndbox.dart';

class ControllPage extends StatefulWidget {
  const ControllPage({super.key});
  @override
  ControllPageState createState() => ControllPageState();
}
const List<Widget> options = <Widget>[
  Text('on'),
  Text('off'),
];
class ControllPageState extends State<ControllPage> {
  List<dynamic> _recognitions = [];
  int _imageHeight = 240;
  int _imageWidth = 320;

  final List<bool> _selectedOption = <bool>[true, false];
  bool isConnecting = true;

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
    await Tflite.loadModel(
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
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, homeVM, child) {
          return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  ImageShow(
                      homeVM,
                      setRecognitions,
                      _imageHeight.toDouble(),
                      _imageWidth.toDouble()
                  ),
                  BndBox(
                      _recognitions,
                      math.min(_imageHeight.toInt(), _imageWidth.toInt()),
                      math.max(_imageHeight.toInt(), _imageWidth.toInt()),
                      _imageHeight.toDouble(),
                      _imageWidth.toDouble(),
                  ),
                  Positioned(
                    left: 0,right: 0,top: 0,
                    child: Container(color: Colors.black54,height: 56,),
                  ),
                  Positioned(
                    top: dSpace_16,left: dSpace_16,
                    child:Text("Server IP : $ipInput",style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                  ),
                  Positioned(
                    top: 0,right: 0,
                    child: Row(
                      children: [
                        ToggleButtons(
                          direction: Axis.horizontal,
                          onPressed: (int index) {
                            setState(() {
                              // The button that is tapped is set to true, and the others to false.
                              for (int i = 0; i < _selectedOption.length; i++) {
                                _selectedOption[i] = i == index;
                              }
                            });
                          },
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          selectedBorderColor: _selectedOption[0] == false
                              ? Colors.red[700]
                              : Colors.green[700],
                          selectedColor: Colors.white,
                          fillColor: _selectedOption[0] == false
                              ? Colors.red[200]
                              : Colors.green[200],
                          color: _selectedOption[0] == false
                              ? Colors.red[400]
                              : Colors.green[400],
                          constraints: const BoxConstraints(
                            minHeight: 40.0,
                            minWidth: 80.0,
                          ),
                          textStyle: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                          isSelected: _selectedOption,
                          children: options,
                        ),
                        _selectedOption[0]?Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                if(homeVM.statusFlash == 0){
                                  homeVM.statusFlash = 1;
                                }else{
                                  homeVM.statusFlash = 0;
                                }
                              });
                            },
                            child:homeVM.statusFlash == 0?const Icon(Icons.flash_off_rounded,color: Colors.white,):
                            const Icon(Icons.flash_on,color: Colors.white,),
                          ),
                        ):Container(width: 16,),
                      ],
                    ),
                  ),
                  _selectedOption[0]?
                      Positioned(
                        top: 56 + dSpace_16,
                        left: dSpace_16,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(padding: EdgeInsets.only(left: dSpace_8,bottom: dSpace_4),child: const Text('Data :'),),
                            Container(
                              decoration: BoxDecoration(
                                  color: homeVM.lastStateTextColor(),
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              padding: EdgeInsets.symmetric(horizontal: dSpace_16,vertical: dSpace_8),
                              child: Text(homeVM.lastStateText(),style: const TextStyle(color: Colors.white),),
                            ),
                            SizedBox(height: dSpace_8,),
                            Padding(padding: EdgeInsets.only(left: dSpace_8,bottom: dSpace_4),child: const Text('Stream :'),),
                            Container(
                              decoration: BoxDecoration(
                                  color: homeVM.lastStateImageColor(),
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              padding: EdgeInsets.symmetric(horizontal: dSpace_16,vertical: dSpace_8),
                              child: Text(homeVM.lastStateImage(),style: const TextStyle(color: Colors.white),),
                            )
                          ],
                        ),
                      ):Container(),
                  Positioned(
                    left: 0,right: 0,bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _selectedOption[0] == true
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 28 + 8),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(28),
                                      onTapDown: (details) {
                                        homeVM.statusCodeClose = 1;
                                        homeVM.sendInputData();
                                      },
                                      onTapUp: (details) {
                                        homeVM.statusCodeClose = 0;
                                      },
                                      overlayColor:
                                      MaterialStateColor.resolveWith(
                                              (states) => cRed),
                                      child: Container(
                                        width: 56,
                                        height: 56,
                                        decoration: const BoxDecoration(
                                            color: Colors.black12,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(28))),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(28),
                                        overlayColor:
                                        MaterialStateColor.resolveWith(
                                                (states) =>
                                                homeVM.statusCodeLeftRight == 1
                                                ? Colors.blue
                                                : Colors.black38),
                                        onTapDown: (details) {
                                          if (homeVM.statusCodeLeftRight == 0) {
                                            homeVM.statusCodeLeftRight = 1;
                                            homeVM.sendInputData();
                                          }
                                        },
                                        onTapUp: (details) {
                                          if (homeVM.statusCodeLeftRight == 1) {
                                              homeVM.isSending = false;
                                              homeVM.statusCodeLeftRight = 0;
                                          }
                                        },
                                        child: Container(
                                          width: 56,
                                          height: 56,
                                          decoration: const BoxDecoration(
                                              color: Colors.black12,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(28))),
                                          child: const Icon(
                                            Icons.square_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(28),
                                        overlayColor:
                                        MaterialStateColor.resolveWith(
                                                (states) =>
                                                homeVM.statusCodeLeftRight == 2
                                                ? Colors.blue
                                                : Colors.black38),
                                        onTapDown: (details) {
                                          if (homeVM.statusCodeLeftRight == 0) {
                                            homeVM.statusCodeLeftRight = 2;
                                            homeVM.sendInputData();
                                          }
                                        },
                                        onTapUp: (details) {
                                          if (homeVM.statusCodeLeftRight == 2) {
                                            homeVM.isSending = false;
                                            homeVM.statusCodeLeftRight = 0;
                                          }
                                        },
                                        child: Container(
                                          width: 56,
                                          height: 56,
                                          decoration: const BoxDecoration(
                                              color: Colors.black12,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(28))),
                                          child: const Icon(
                                            Icons.circle_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Joystick(
                            period: const Duration(milliseconds: 200),
                            mode: JoystickMode.all,
                            stick: Container(
                              height: 40,width: 40,
                              decoration: BoxDecoration(
                                color: cRed,
                                borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                            // period: Duration(milliseconds: 1000),
                            listener: (details) {
                              homeVM.statusCodeX = homeVM.mapValue(details.x, -1, 1, 0, 8);
                              homeVM.statusCodeY = homeVM.mapValue(details.y, -1, 1, 8, 0);
                              // isSending = true;
                              if (details.x != 0 && details.y != 0) {
                                homeVM.sendInputData();
                              } else {
                                homeVM.isSending = false;
                              }
                              // _sendMessage(details.x.toString());
                            },
                          ),
                        ],
                      )
                          : Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                            Text("Controll Buttuns is not Active")
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }
}