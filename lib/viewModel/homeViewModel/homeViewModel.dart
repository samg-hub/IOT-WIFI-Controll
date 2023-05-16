import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../constant/functions.dart';
import '../../model/data/remote/response/apiResponseModel.dart';
import '../../model/data/remote/response/status.dart';
import '../../model/data/repository/homePage/mainRepoImp.dart';
import 'package:path/path.dart';

class HomeViewModel extends ChangeNotifier{
  //this instance of HomeRepositoryImpl is for accessing to APIs
  final _myRepo = MainRepoImp();

  ApiResponse<dynamic> espInputResponse = ApiResponse.notCalled();
  void _setInputDataResponse(ApiResponse<String> response)async{
    debugPrintFunction("_sendInputData");
    try{
      espInputResponse = response;
      await Future.delayed(const Duration(milliseconds: 1));
      debugPrintFunction("Update Status of _setInputData ${espInputResponse.status}");
      notifyListeners();
    }catch(e){
      debugPrintFunction("_send Input Err : $e");
    }
  }
  String getButtonLoginText(){
    if(espInputResponse.status == Status.COMPLETED){
      return "Connected, wait...";
    }else if(espInputResponse.status == Status.COMPLETED){
      return "Connect to IP";
    }else{
      return "Couldn't Connect, Tap to try again!";
    }
  }
  bool isSending = false;
  int Status_code_x = 4;
  int Status_code_y = 4;
  int Status_code_close = 0;
  int Status_code_left_right = 0;
  Future<void> sendInputData({String? spcData})async{
    if (isSending == false && espInputResponse.status != Status.LOADING) {
      isSending = true;
      _setInputDataResponse(ApiResponse.loading());
      await Future.delayed(Duration(seconds: 1));
      debugPrintFunction("send Input...*********************************************************************************");
      await _myRepo.sendInputRepo(spcData ??
          "$Status_code_x$Status_code_y$Status_code_left_right$Status_code_close")
          .then((value) {
        debugPrintFunction("input send Success");
        _setInputDataResponse(ApiResponse.completed("Done"));
      }).onError((error, stackTrace) {
        debugPrintFunction("Error on sending Data $error");
        _setInputDataResponse(ApiResponse.error(error.toString()));
      });
    }
  }
  bool isConnected = false;
  bool isDetecting = false;
  File? lastFile ;
  Future<File?> fileFromImageUrl() async {
    // "https://s8.uupload.ir/files/images_86vx.jpeg",
    //https://s8.uupload.ir/files/images_ysw.jpeg
    // "https://s8.uupload.ir/files/cup2_0vwl.jpeg",
    // "https://s8.uupload.ir/files/download_9sk3.jpeg",
    if(isDetecting == true) {
      print("start to file from Image URL");
      try {
        final response = await _myRepo.getImage();
        final documentDirectory = await getApplicationDocumentsDirectory();
        final file = File(join(documentDirectory.path, '${generatePassword(8)}.jpg'));
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
  int mapValue(double value, double fromLow, double fromHigh, double toLow,
      double toHigh) {
    double val1 =
        ((value - fromLow) * (toHigh - toLow) / (fromHigh - fromLow)) + toLow;
    return val1.round();
  }
  String generatePassword(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

}
