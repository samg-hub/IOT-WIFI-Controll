import 'dart:io';
import 'package:http/http.dart' as http;

abstract class BaseApiService {
  //this base url and access token are temp and should change in future
  final String xTravelBaseUrl = "http://192.168.4.1/";
  //to call get api s from our server
  Future<dynamic> getResponse(String url, {String queryParms = ""});
  //to call patch api s from our server
  Future<dynamic> patchResponse(String url, String args,
      {Map<String, dynamic>? jsonBody});
  //to call post api s from our server
  Future<dynamic> postResponse(String url, Map<String, dynamic> jsonBody,
      {bool tokenSend = true});
  //upload image to server
  Future<http.ByteStream> uploadImageFile(String url, File file);
  Future<dynamic> refreshToken();
}