import 'package:http/http.dart' as http;
import '../../../../constant/constants.dart';
import '../../remote/network/apiEndPoints.dart';
import '../../remote/network/baseApiService.dart';
import '../../remote/network/networkApiService.dart';
import 'mainRepo.dart';

class MainRepoImp implements MainRepo {
  final BaseApiService _apiService = NetworkApiService();

  @override
  Future<String?> sendInputRepo(String input) async {
    try{
      dynamic response = await _apiService.postResponse(
        ApiEndPoints().espInput,
        {"input" : input}
      );
      print("sended ${response.toString()}");
      return response;
    }catch(e){
      return Future.error(e.toString());
    }
  }

  @override
  Future<dynamic> getImage() async {
    try{
      final response = await http.get(Uri.parse("${ipAddress}showImage?"));
      return response;
    }catch(e){
      return Future.error(e.toString());
    }
  }
}
