//this is a class for managing api response

import 'package:sbukBot/model/data/remote/response/status.dart';
class ApiResponse<T> {

  Status? status;
  T? data;
  String? message;

  ApiResponse(this.status,this.data,this.message);

  ApiResponse.notCalled() : status = Status.NOTCALLED;

  ApiResponse.loading() : status = Status.LOADING;

  ApiResponse.completed(this.data) : status = Status.COMPLETED;

  ApiResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}