import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:v2rayadmin/constant/constants.dart';
import '../../../../constant/functions.dart';
import '../appExceptions.dart';
import 'baseApiService.dart';

class NetworkApiService extends BaseApiService {
  @override
  Future getResponse(String url, {String queryParms = ""}) async {
    dynamic responseJson;
    //we should implement access token and refresh token managing here
    try {
      Map<String, String> headersValue = {
        HttpHeaders.contentTypeHeader: 'image/jpeg',
      };
      final response = await http.get(
          Uri.parse("http://192.168.126.218/showImage?"),
          headers: headersValue).timeout(
          timeOutDuraion(),
          onTimeout: (){
            return timeOutException();
          }
      );
      debugPrintFunction("GET _ $url /${response.statusCode}->${response.body}");
      if(response.statusCode == 200){
        responseJson = returnResponse(response);
      }else{
        responseJson = Future.error("Error");
      }
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future postResponse(String url, Map<String, dynamic> jsonBody,
      {bool tokenSend = true}) async {
    String responseJson;
    Map<String, String> headers = {
      // HttpHeaders.contentTypeHeader: 'application/json',
      // HttpHeaders.content
    };
    //we should implement access token and refresh token managing here
    try {
      final response = await http.post(
        Uri.parse(ipAddress + url),
        headers: headers,
        body: jsonBody
        // body: jsonEncode(jsonBody),
      ).timeout(
          timeOutDuraion(),
          onTimeout: (){
            return timeOutException();
          }
      );
      // debugPrintFunction(
          // "POST/${response.statusCode} -> ${utf8.decode(response.bodyBytes)}");
        responseJson = utf8.decode(response.bodyBytes);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    var res = utf8.decode(response.bodyBytes);
    dynamic responseJson = jsonDecode(res);
    switch (response.statusCode) {
      case 200:
        return responseJson;
      case 201:
        return responseJson;
      case 400:
        throw UnauthorisedException(utf8.decode(response.bodyBytes));
      case 401:
        throw UnauthorisedException(utf8.decode(response.bodyBytes));
      case 403:
        throw UnauthorisedException(utf8.decode(response.bodyBytes));
      case 404:
        throw UnauthorisedException(utf8.decode(response.bodyBytes));
      case 408:
        throw UnauthorisedException(jsonEncode({
          'detail':("درخواست شما ارسال نشد،مجددا تلاش کنید")
        }));
      case 429:
        throw UnauthorisedException(utf8.decode(response.bodyBytes));
      case 500:
        throw UnauthorisedException(response.body.toString());
      default:
      //debugPrintFunction(response.body);
        throw FetchDataException(
            'Error occurred while communication with server' +
                ' with status code : ${response.statusCode}');
    }
  }
  dynamic timeOutException(){
    return returnResponse(http.Response(
        jsonEncode({
          'detail':("")
        }),
        408));//Request Timeout response status code
  }
  Duration timeOutDuraion(){
    return const Duration(seconds: 10);
  }
}