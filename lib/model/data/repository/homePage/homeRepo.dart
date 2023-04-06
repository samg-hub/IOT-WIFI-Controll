
//we determine methods we want to implement in exTripRepoImp
// this is list of methods we can use in exTripRepoImp class
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../entity/homePage/homeModel.dart';

class HomeRepo {
  Future<HomeModel?> getHomeData() async {}
  Future<HomeModel?> getHistoryData() async {}

  //signUp and signIn
  Future<dynamic> sendVerificationCode(String phoneNumber)async{}

  Future<dynamic> smsCodeVerification(String mobileNumber,String verificationCode)async{}

  Future<dynamic?> editProfile(
    int id,
    String name,
    String nationalCode,
    String birthDate,
    String image,
  )async{}
  
  Future<http.ByteStream?> uploadImage(File imageFile) async{}
}
