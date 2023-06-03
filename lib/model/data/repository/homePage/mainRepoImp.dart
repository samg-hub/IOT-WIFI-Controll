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
      return response;
    }catch(e){
      return Future.error(e.toString());
    }
  }

  @override
  Future<dynamic> getImage() async {
    try{
      final response = await _apiService.getResponse(ApiEndPoints().espImage);
      return response;
    }catch(e){
      return Future.error(e.toString());
    }
  }
  
  @override
  Future<dynamic> testConn() async{
    try{
      final response = await _apiService.getResponse(ApiEndPoints().espCheckConn);
      return response;
    }catch(e){
      return Future.error(e.toString());
    }
  }
}
