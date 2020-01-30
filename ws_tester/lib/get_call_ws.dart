import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'exception.dart';

Future<dynamic> get(String url) async {
  var responseBody;
  try {
    final response = await http.get(url);
    responseBody = _returnResponse(response);
  } on SocketException {
    throw FetchDataException('No Internet connection');
  }
  return responseBody;
}

dynamic _returnResponse(http.Response response) {
  String _contentType;
  var responseBody;
  _contentType = response.headers['content-type'];
  switch (response.statusCode) {
    case 200:
      if (_contentType.contains("application/json")) {
        responseBody = json.decode(response.body.toString())['items'] as List;
      } else {
        responseBody = response.body;
      }
      return responseBody;
    case 400:
      throw BadRequestException(response.body.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  }
}
