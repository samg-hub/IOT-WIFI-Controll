import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:v2rayadmin/constant/ui.dart';
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

  String lastStateText(){
    if(espInputResponse.status == Status.NOTCALLED){
      return "no Action";
    }else if(espInputResponse.status == Status.LOADING){
      return "Loading...";
    }else if(espInputResponse.status == Status.COMPLETED){
      return espInputResponse.data.toString();
    }else {
      return "Please waite, reconnecting..";
    }
  }
  Color lastStateTextColor(){
    if(espInputResponse.status == Status.NOTCALLED){
      return Colors.black54;
    }else if(espInputResponse.status == Status.LOADING){
      return Colors.orange;
    }else if(espInputResponse.status == Status.COMPLETED){
      return Colors.green;
    }else {
      return cRed;
    }
  }
  Color lastStateImageColor(){
    if(espImageResponse.status == Status.NOTCALLED){
      return Colors.black54;
    }else if(espImageResponse.status == Status.LOADING){
      return Colors.orange;
    }else if(espImageResponse.status == Status.COMPLETED){
      return Colors.green;
    }else {
      return cRed;
    }
  }
  String lastStateImage(){
    if(espImageResponse.status == Status.NOTCALLED){
      return "Loading Image..";
    }else if(espImageResponse.status == Status.LOADING){
      return "Loading Image..";
    }else if(espImageResponse.status == Status.COMPLETED){
      return "Image Received";
    }else {
      return "Please waite, Reloading..";
    }
  }
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
  int statusCodeX = 4;
  int statusCodeY = 4;
  int statusCodeClose = 0;
  int statusCodeLeftRight = 0;
  int statusFlash = 0;

  Future<void> sendInputData({String? spcData})async{
    if (espImageResponse.status != Status.LOADING && espInputResponse.status != Status.LOADING) {
      debugPrintFunction("---------------------------------$statusCodeX$statusCodeY$statusCodeLeftRight$statusCodeClose");
      _setInputDataResponse(ApiResponse.loading());
      await _myRepo.sendInputRepo(spcData ?? "$statusCodeX$statusCodeY$statusCodeLeftRight$statusCodeClose$statusFlash")
      .then((value) {
        debugPrintFunction("input send Success -> $value");
        _setInputDataResponse(ApiResponse.completed(value));
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
    ipController.dispose();
    super.dispose();
  }

}
