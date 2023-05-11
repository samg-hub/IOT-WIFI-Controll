import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../constant/functions.dart';
import '../../model/data/entity/homePage/homeModel.dart';
import '../../model/data/remote/response/apiResponseModel.dart';
import '../../model/data/remote/response/status.dart';
import '../../model/data/repository/homePage/homeRepoImp.dart';
import '../../view/components/dialogs/dialogTwoSelection.dart';

class HomeViewModel extends ChangeNotifier{
  //this instance of HomeRepositoryImpl is for accessing to APIs
  final _myRepo = HomeRepoImp();

  ApiResponse<dynamic> espInputResponse = ApiResponse.notCalled();
  void _setInputDataResponse(ApiResponse<String> response)async{
    debugPrintFunction("_sendInputData");
    try{
      espInputResponse = response;
      await Future.delayed(const Duration(milliseconds: 1));
      notifyListeners();
      debugPrintFunction("Update Status of _setInputData");
    }catch(e){
      debugPrintFunction("_send Input Err : $e");
    }
  }
  Future<void> sendInputData(String input)async{
    debugPrintFunction("send Input...");
    await _myRepo.sendInputRepo(input).onError((error, stackTrace){
      debugPrintFunction("Error on sending Data $error");
      _setInputDataResponse(ApiResponse.error(error.toString()));
    }).then((value){
      debugPrintFunction("input send Success");
      _setInputDataResponse(ApiResponse.completed("Done"));
    });
  }

  ApiResponse<HomeModel> homeDataResponse = ApiResponse.notCalled();
  void _setHomeDataResponse(ApiResponse<HomeModel> response)async{
    debugPrintFunction("__setHomeDataResponse");
    try {
      homeDataResponse = response;
      await Future.delayed(const Duration(milliseconds: 1)); 
      notifyListeners();
      debugPrintFunction("update status : ${homeDataResponse.status}");
    } catch (e) {
      debugPrintFunction("home error : $e");
    }
  }

  //this method is for getting home data
  Future<void> fetchHomeData({bool loading = true}) async {
    debugPrintFunction("fetchHomeData");
    if (homeDataResponse.status != Status.LOADING) {
      if (loading == true) {
        //اینجا برای اینکه کاربر متوجه آپدیت شدن صفحه نشه ما وضعیت لودینگ را حذف میکنیم
        _setHomeDataResponse(ApiResponse.loading());
      }
      await _myRepo.getHomeData()
        .then((value) {
          _setHomeDataResponse(ApiResponse.completed(value));
      }).onError((error, stackTrace) {
        _setHomeDataResponse(ApiResponse.error(error.toString()));
      });
    }
  }
  Future<dynamic> saveProfileData(int id, String name, String national_code,
      String birth_date, String? image) async {
    return await _myRepo.editProfile(
      id, name, national_code, birth_date, image
    );
  }

  /*********************    Start Send Image to Server  ************************/
  File? loadImageFile;
  File? get getLoadImageFile => loadImageFile;
  Future<String?> getUploadedImageCode() async {
    await sendImage();
  }
  Future<void> sendImage() async {
    try {
      var response = await _myRepo.uploadImage(getLoadImageFile!);
      debugPrintFunction("response = $response");
      await utf8.decoder.bind(response).join().then((value) {
        Map<String, dynamic> temp = json.decode(value);
      }).onError((error, stackTrace) {

      });
    } catch (e) {
      debugPrintFunction("uploading error -> $e");
    }
  }
  /*********************    End of Send Image to Server  ************************/
}
