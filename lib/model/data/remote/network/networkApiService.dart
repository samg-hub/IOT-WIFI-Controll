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
  Future<String?> getAccessToken() async {
    String? accessToken;
    await SharedPreference().getString(sharedAccessToken).then((value) {
      accessToken = value != null ? "Bearer $value" : "";
    });
    return accessToken;
  }

  @override
  Future getResponse(String url, {String queryParms = ""}) async {
    String? accessToken = await getAccessToken();
    dynamic responseJson;
    //we should implement access token and refresh token managing here
    try {
      Map<String, String> headersValue = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: accessToken.toString()
      };
      final response = await http.get(
          Uri.parse(xTravelBaseUrl + url + queryParms),
          headers: headersValue).timeout(
          timeOutDuraion(),
          onTimeout: (){
            return timeOutException();
          }
      );
      debugPrintFunction("GET _ $url /${response.statusCode} \n ${response.body}");
      if (response.statusCode == 401) {
        debugPrintFunction("(GET) 401 Code Recived _ try to refresh Token...");
        await refreshToken().then((value) async {
          debugPrintFunction(
              " + Refresh Token Updated Completely _ try getting Data Again...");
          String? newAccessToken = await getAccessToken();
          Map<String, String> headersValue = {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: newAccessToken.toString()
          };
          try {
            debugPrintFunction("new ------> ${accessToken.toString() == newAccessToken.toString()}");
            final data = await http.get(
                Uri.parse(xTravelBaseUrl + url + queryParms),
                headers: headersValue).timeout(
                timeOutDuraion(),
                onTimeout: (){
                  return timeOutException();
                }
            );
            debugPrintFunction("GET NEW/${data.statusCode} \n ${data.body}");
            responseJson = returnResponse(data);
          } on SocketException {
            throw FetchDataException('No Internet Connection');
          }
        });
      } else {
        responseJson = returnResponse(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future patchResponse(String url, String args, {Map<String, dynamic>? jsonBody}) async {
    String? accessToken = await getAccessToken();
    dynamic responseJson;
    //we should implement access token and refresh token managing here
    try {
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: accessToken.toString(),
      };
      final response = await http.patch(Uri.parse(xTravelBaseUrl + url + args),
          headers: headers, body:jsonBody != null? jsonEncode(jsonBody):null).timeout(
          timeOutDuraion(),
          onTimeout: (){
            debugPrintFunction("time out....");
            return timeOutException();
          }
      );
      debugPrintFunction(
          "PATCH / $url ${response.statusCode} \n ${utf8.decode(response.bodyBytes)}");
      if (response.statusCode == 401) {
        debugPrintFunction("(Patch) 401 Code Recived _ try to refresh Token...");
        await refreshToken().then((value) async {
          debugPrintFunction(
              " + Refresh Token Updated Completely _ try getting Data Again...");
          String? newAccessToken = await getAccessToken();
          Map<String, String> headersValue = {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: newAccessToken.toString()
          };
          try {
            debugPrintFunction("new data with token $newAccessToken");
            final data = await http.patch(
                Uri.parse(xTravelBaseUrl + url + args),
                headers: headersValue,
                body: jsonBody != null? jsonEncode(jsonBody):null).timeout(
                timeOutDuraion(),
                onTimeout: (){
                  return timeOutException();
                }
            );
            responseJson = returnResponse(data);
            debugPrintFunction("Patch  $url NEW/${data.statusCode} \n ${data.body}");
          } on SocketException {
            throw FetchDataException('No Internet Connection');
          }
        });
      } else {
        responseJson = returnResponse(response);
      }
    } on SocketException {
      throw FetchDataException('شبکه قطع شده است!');
    } on TimeoutException{
      throw FetchDataException('درخواست شما ارسال نشد، مجددا تلاش کنید.');
    }
    return responseJson;
  }

  @override
  Future postResponse(String url, Map<String, dynamic> jsonBody,
      {bool tokenSend = true}) async {
    String? accessToken = await getAccessToken();
    dynamic responseJson;
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader:
      tokenSend == true ? accessToken.toString() : ""
    };
    //we should implement access token and refresh token managing here
    try {
      final response = await http.post(
        Uri.parse(xTravelBaseUrl + url),
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
      if (response.statusCode == 401) {
        debugPrintFunction("(POST) 401 Code Received _ try to refresh Token...");
        await refreshToken().then((value) async {
          debugPrintFunction(
              " + Refresh Token Updated Completely _ try getting Data Again...");
          String? newAccessToken = await getAccessToken();
          Map<String, String> headersValue = {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: newAccessToken.toString()
          };
          try {
            final data = await http.post(
              Uri.parse(xTravelBaseUrl + url),
              headers: headersValue,
              body: jsonEncode(jsonBody),
            ).timeout(
                timeOutDuraion(),
                onTimeout: (){
                  return timeOutException();
                }
            );
            responseJson = returnResponse(data);
          } on SocketException {
            throw FetchDataException('No Internet Connection');
          }
        });
      } else {
        responseJson = returnResponse(response);
      }
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

  @override
  Future<void> refreshToken() async {
    String? refreshToken;
    await SharedPreference().getString(sharedRefreshToken).then((value) {
      refreshToken = value;
    });
    debugPrintFunction("Call refresh Token Api Method");
    if (refreshToken != null) {
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
      };
      Map<String, dynamic> jsonBody = {"refresh": refreshToken};
      try {
        final response = await http.post(
          Uri.parse(xTravelBaseUrl + ApiEndPoints().refreshToken),
          headers: headers,
          body: jsonEncode(jsonBody),
        ).timeout(
            timeOutDuraion() ,
            onTimeout: (){
              return timeOutException();
            }
        );
        debugPrintFunction(
            "Refresh Token Api Called _ ${response.statusCode}| -> ${utf8.decode(response.bodyBytes)}");
        //در صورتی که با موفقیت
        if (response.statusCode == 200) {
          var res = utf8.decode(response.bodyBytes);
          dynamic responseJson = jsonDecode(res);
          await SharedPreference.setData(
              sharedAccessToken, responseJson['access']);
          await SharedPreference.setData(
              sharedRefreshToken, responseJson['refresh']);
        } else if (response.statusCode == 401) {
          // منقضی شدن رفرش توکن
          debugPrintFunction("Token Expired! - 401");
          SharedPreference().clearAllSavedUserData();
          return Future.error("401");
        } else {
          return Future.error(response.body.toString());
          //اینجا باید چک شه چه چیزی از سمت سرور میاد
        }
        // return returnResponse(response);
      } on SocketException {
        throw FetchDataException('No Internet Connection');
      }
    } else {
      SharedPreference().clearAllSavedUserData();
      debugPrintFunction("User LogOut");
      return Future.error("User Log out");
      //exit Application
    }
  }

  @override
  Future<http.ByteStream> uploadImageFile(String url, File imageFile) async {
    String? accessToken = await getAccessToken();
    Map<String, String> headersValue = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: accessToken.toString()
    };
    var stream = http.ByteStream(imageFile.openRead());
    stream.cast();
    var length = await imageFile.length();
    var uri = Uri.parse(xTravelBaseUrl + url);
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(headersValue);

    var multipartFile = http.MultipartFile(
      'image',
      stream,
      length,
      filename: basename(imageFile.path),
    );
    request.fields['image_type'] = "load";
    request.files.add(multipartFile);

    var response = await request.send();
    return response.stream;
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