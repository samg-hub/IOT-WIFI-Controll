import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../constant/functions.dart';
import '../../model/data/remote/response/apiResponseModel.dart';
import '../../model/data/remote/response/status.dart';
import 'package:path/path.dart';
import '../../model/data/repository/homePage/mainRepoImp.dart';

class HomeViewModel extends ChangeNotifier{

  //text editing controll for IP Address textfield
  final ipController = TextEditingController();
  //this instance of HomeRepositoryImpl is for accessing to APIs
  final _myRepo = MainRepoImp();

  ApiResponse<dynamic> espInputResponse = ApiResponse.notCalled();
  void _setInputDataResponse(ApiResponse<String> response)async{
    // debugPrintFunction("_sendInputData");
    try{
      espInputResponse = response;
      await Future.delayed(const Duration(milliseconds: 1));
      // debugPrintFunction("Update Status of _setInputData ${espInputResponse.status}");
      notifyListeners();
    }catch(e){
      debugPrintFunction("_send Input Err : $e");
    }
  }

  ApiResponse<dynamic> espImageResponse = ApiResponse.notCalled();
  void _setImageDataResponse(ApiResponse<String> response)async{
    espImageResponse = response;
  }
  String getButtonLoginText(){
    if(espInputResponse.status == Status.COMPLETED){
      return "Connected, wait...";
    }else if(espInputResponse.status == Status.NOTCALLED){
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

  Future<void> sendInputData({String? spcData,bool finalData = false})async{
    if (espImageResponse.status != Status.LOADING && (espInputResponse.status != Status.LOADING || finalData == true)) {
      // print("---------------------------------$Status_code_x$Status_code_y$Status_code_left_right$Status_code_close");
      _setInputDataResponse(ApiResponse.loading());
      if(finalData == true){
        await Future.delayed(const Duration(milliseconds: 200));
      }
      await _myRepo.sendInputRepo(spcData ?? "$Status_code_x$Status_code_y$Status_code_left_right$Status_code_close")
      .then((value) {
        debugPrintFunction("input send Success");
        _setInputDataResponse(ApiResponse.completed("Done"));
      }).onError((error, stackTrace) {
        debugPrintFunction("Error on sending Data $error");
        _setInputDataResponse(ApiResponse.error(error.toString()));
      });
      if((Status_code_close != 0 || Status_code_left_right != 0) && finalData == false){
        sendInputData();
      }
    }
  }
  bool isConnected = false;
  bool isDetecting = false;
  File? lastFile ;
  Future<File?> fileFromImageUrl() async {
    if(isDetecting == true && espImageResponse.status != Status.LOADING && espInputResponse.status != Status.LOADING) {
      _setImageDataResponse(ApiResponse.loading());
      // print("start to file from Image URL");
      try {
        final response = await _myRepo.getImage();
        final documentDirectory = await getApplicationDocumentsDirectory();
        final file = File(join(documentDirectory.path, '${generatePassword(8)}.jpg'));
        file.writeAsBytesSync(response.bodyBytes);
        // print("---------------------------------------------------------response Image File = ${response.statusCode}");
        _setImageDataResponse(ApiResponse.completed("Done"));
        lastFile = file;
        return file;
      } catch (error) {
        _setImageDataResponse(ApiResponse.error("Failed"));

        // print("error on fileFromImageUrl -> $error");
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

  @override
  void dispose() {
    // TODO: implement dispose
    ipController.dispose();
    super.dispose();
  }

}
