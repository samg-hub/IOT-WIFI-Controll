import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sbukBot/constant/constants.dart';
import '../../../../constant/functions.dart';
import '../appExceptions.dart';
import 'baseApiService.dart';

class NetworkApiService extends BaseApiService {
  @override
  Future getResponse(String url, {String queryParms = ""}) async {
    dynamic responseJson;
    try {
      final response = await http.get(
        Uri.parse("$ipAddress$url"),
        headers: {
          HttpHeaders.contentTypeHeader : "text/plain" 
        }
      ).timeout(
          timeOutDuraion(),
      );
      debugPrintFunction("GET _ $ipAddress$url /${response.statusCode}->${response.body}");
      if (response.statusCode != 200) {
        throw FetchDataException("500 Error");
      }
      responseJson = response;
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future postResponse(String url, Map<String, dynamic> jsonBody,
      {bool tokenSend = true}) async {
    String responseJson;
    try {
      final response = await http.post(
        Uri.parse(ipAddress + url),
        body: jsonBody
      ).timeout(
          timeOutDuraion(),
      );
      debugPrintFunction(
          "POST/${response.statusCode} -> ${utf8.decode(response.bodyBytes)}");
      if (response.statusCode != 200) {
        throw FetchDataException("500 error");
      }
        responseJson = utf8.decode(response.bodyBytes);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Duration timeOutDuraion(){
    return const Duration(seconds: 10);
  }
}