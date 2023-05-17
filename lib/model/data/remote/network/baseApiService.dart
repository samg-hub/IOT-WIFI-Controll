import 'dart:io';
import 'package:http/http.dart' as http;

import '../../../../constant/constants.dart';

abstract class BaseApiService {
  //this base url and access token are temp and should change in future
  final String baseUrl = ipAddress;
  //to call get api s from our server
  Future<dynamic> getResponse(String url, {String queryParms = ""});
  //to call post api s from our server
  Future<dynamic> postResponse(String url, Map<String, dynamic> jsonBody,
      {bool tokenSend = true});
}