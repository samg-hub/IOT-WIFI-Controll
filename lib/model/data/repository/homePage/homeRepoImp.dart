import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../constant/constants.dart';
import '../../../../constant/functions.dart';
import '../../entity/homePage/homeModel.dart';
import '../../local/shared/sharedPreference.dart';
import '../../remote/network/apiEndPoints.dart';
import '../../remote/network/baseApiService.dart';
import '../../remote/network/networkApiService.dart';
import 'homeRepo.dart';

//we determine methods we want to implement in exTripRepoImp
// this is list of methods we can use in exTripRepoImp class
class HomeRepoImp implements HomeRepo {
  final BaseApiService _apiService = NetworkApiService();
  @override
  Future<HomeModel> getHomeData() async {
    debugPrintFunction("Getting Home Data");
    try {
      dynamic response = await _apiService.getResponse(ApiEndPoints().homeData);
      final data = HomeModel.fromJson(response);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<HomeModel> getHistoryData() async {
    debugPrintFunction("Getting History Data");
    try {
      dynamic response = await _apiService.getResponse(ApiEndPoints().homeData,
          queryParms: "?count=1000");
      final data = HomeModel.fromJson(response);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> sendVerificationCode(String phoneNumber) async {
    try {
      dynamic response = await _apiService.postResponse(
          ApiEndPoints().sendVerificationCode, {"phone_number": phoneNumber},
          tokenSend: false);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future smsCodeVerification(
      String mobileNumber, String verificationCode) async {
    try {
      dynamic response = await _apiService.postResponse(
        ApiEndPoints().smsCodeVerificationCode,
        {
          "mobile_number": mobileNumber,
          "verification_code": verificationCode,
          "mobile_app_passenger_account": true
        },
        tokenSend: false,
      );
      debugPrintFunction("sharedPreference set data");
      await SharedPreference.setData(sharedMobileNumber, mobileNumber);
      await SharedPreference.setData(
          sharedAccessToken, response["access_token"]);
      await SharedPreference.setData(
          sharedRefreshToken, response["refresh_token"]);

    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> cancelLoad(int loadID) async {
    try {
      dynamic response =
          await _apiService.patchResponse(ApiEndPoints().cancelLoad+"$loadID/", "");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> cancelExclusive(int travelId) async {
    try {
      dynamic response = await _apiService.patchResponse(
          ApiEndPoints().cancelExTrip+"$travelId/", "");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> cancelNormalTravel(int travelId) async {
    try {
      dynamic response = await _apiService.patchResponse(
          ApiEndPoints().cancelNormalTravel+"$travelId/", "");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> editProfile(int id, String name, String nationalCode,
      String birth_date, String? image) async {
    try {
      debugPrintFunction("imageee ->$image");
      String body =
          '{"id": "${id.toString()}","name": "$name", "national_code": "$nationalCode","birth_date": "$birth_date", "image": "${image.toString()}"}';
      dynamic response = await _apiService
        .patchResponse(
          "${ApiEndPoints().appUserProfileApi}$id/", "",
          jsonBody: {
            "id":id,
            "name":name,
            "national_code" : nationalCode,
            "birth_date" : birth_date,
            "image" : image,
          }
          );
      return response;
    } catch (e) {
      debugPrintFunction("error -> $e");
      rethrow;
    }
  }

  @override
  Future<http.ByteStream> uploadImage(File imageFile) async {
    try {
      return _apiService.uploadImageFile("custom_image_api/", imageFile);
    } catch (e) {
      rethrow;
    }
  }
}
