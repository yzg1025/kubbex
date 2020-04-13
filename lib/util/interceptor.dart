import 'package:dio/dio.dart';

class CustomLogInterceptor extends LogInterceptor {
  CustomLogInterceptor({
    request = true,
    requestHeader = true,
    requestBody = false,
    responseHeader = true,
    responseBody = false,
    error = true,
    logSize = 9999999,
  }) : super(
            request: request,
            requestHeader: requestHeader,
            requestBody: requestBody,
            responseHeader: responseHeader,
            responseBody: responseBody,
            error: error,);
}