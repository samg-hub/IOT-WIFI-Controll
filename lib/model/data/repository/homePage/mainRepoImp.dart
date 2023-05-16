import 'package:http/http.dart' as http;
import '../../remote/network/apiEndPoints.dart';
import '../../remote/network/baseApiService.dart';
import '../../remote/network/networkApiService.dart';
import 'mainRepo.dart';

class MainRepoImp implements MainRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<void> sendInputRepo(String input) async {
    try{
      print("sending....");
      dynamic response = await _apiService.postResponse(
        ApiEndPoints().espInput,
        {"input" : input}
      );
      print("response : "+response.toString());
    }catch(e){
      return Future.error(e.toString());
    }
  }

  @override
  Future<dynamic> getImage() async {
    try{
      print("get Image....");
      //https://s8.uupload.ir/files/images_(1)_9bu1.jpeg
      //https://s8.uupload.ir/files/images_ysw.jpeg
      //https://s8.uupload.ir/files/bakll_n96l.jpeg
      //https://s8.uupload.ir/files/cups_py3a.jpeg
      //https://s8.uupload.ir/files/tree_sum.jpeg
      //https://s8.uupload.ir/files/cat_s1q8.jpeg
      //https://s8.uupload.ir/files/sa_f7q1.jpeg
      //https://s8.uupload.ir/files/dw_rzy5.jpeg
      final response = await http.get(Uri.parse("https://s8.uupload.ir/files/cups_py3a.jpeg"));
      // dynamic response = await _apiService.getResponse(
      //     ApiEndPoints().espImage,
      // );
      return response;
    }catch(e){
      return Future.error(e.toString());
    }
  }
}
