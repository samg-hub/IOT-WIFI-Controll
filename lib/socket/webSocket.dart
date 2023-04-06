import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../constant/constants.dart';
import '../constant/functions.dart';
import '../constant/ui.dart';
import '../model/data/local/shared/sharedPreference.dart';

class WebSocket {
  WebSocket({required this.vm, required this.context, required this.vmN});
  final ChangeNotifier vm;
  final ViewModelsName vmN;
  final BuildContext context;

  WebSocketChannel? channel;
  bool isWebsocketRunning = false;
  int retryLimit = 3;
  bool websocketErrorMessage = false;

  dynamic checkNull(dynamic data) {
    try {
      if (data != null) {
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  void startStream() async {
    String? accessToken = await SharedPreference().getString(sharedAccessToken);
    if (isWebsocketRunning) {
      return;
    }
    String url =
        'ws:///ws/passengers?token=${accessToken.toString()}';
    channel = WebSocketChannel.connect(
      Uri.parse(url),
    );
    channel!.stream.listen(
      (event) {
        isWebsocketRunning = true;
        debugPrintFunction("event Waiting -> $event");
        websocketErrorMessage = true;
        //_setData(event);
      },
      onDone: () {
        isWebsocketRunning = false;
        debugPrintFunction("on done");
      },
      onError: (err) {
        debugPrintFunction("Waiting Socket-> $err");
        if (websocketErrorMessage == false) {
          Dialogs().showSnackBar(context, "مشکل ارتباط باسرور");
          websocketErrorMessage = true;
          return Future.error("");
        }
        if (retryLimit > 0) {
          retryLimit--;
          startStream();
        } else {
          isWebsocketRunning = false;
        }
      },
    );
  }

  void closeChannelStream(String txt) {
    //تکست برای زمانی است که ما متوجه بشیم از کدام خط کد سوکت ما بسته می‌شود
    debugPrintFunction(txt);
    channel!.sink.close();
    isWebsocketRunning = false;
    debugPrintFunction("socket closed");
  }
}
