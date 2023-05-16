import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../../../../constant/constants.dart';
import '../../../../constant/functions.dart';
import '../../local/shared/sharedPreference.dart';
import '../appExceptions.dart';
import 'apiEndPoints.dart';
import 'baseApiService.dart';

class NetworkApiService extends BaseApiService {
  @override
  Future getResponse(String url, {String queryParms = ""}) async {
    dynamic responseJson;
    //we should implement access token and refresh token managing here
    try {
      Map<String, String> headersValue = {
        HttpHeaders.contentTypeHeader: 'application/json',
      };
      final response = await http.get(
          Uri.parse(baseUrl + url + queryParms),
          headers: headersValue).timeout(
          timeOutDuraion(),
          onTimeout: (){
            return timeOutException();
          }
      );
      debugPrintFunction("GET _ $url /${response.statusCode} \n ${response.body}");
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future postResponse(String url, Map<String, dynamic> jsonBody,
      {bool tokenSend = true}) async {
    dynamic responseJson;
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    //we should implement access token and refresh token managing here
    try {
      final response = await http.post(
        Uri.parse(baseUrl + url),
        headers: headers,
        body: jsonEncode(jsonBody),
      ).timeout(
          timeOutDuraion(),
          onTimeout: (){
            return timeOutException();
          }
      );
      debugPrintFunction(url);
      debugPrintFunction(
          "POST/${response.statusCode} -> \n ${utf8.decode(response.bodyBytes)}");
        responseJson = returnResponse(response);
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
    return const Duration(seconds: 5);
  }
}