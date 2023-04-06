import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

debugPrintFunction(Object? txt) {
  if (kDebugMode) {
    print(txt);
  }
}
Future<void> makePhoneCall(String phoneNumber) async {
  debugPrintFunction("phone number is : $phoneNumber");
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  bool res = await canLaunchUrl(launchUri);
  if (res) {
    await launchUrl(launchUri);
  }
}