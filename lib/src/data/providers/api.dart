import 'dart:async';
import 'package:dio/dio.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';

String getParams(Map body) =>
    body.keys.map((key) => '$key=${body[key]}').toList().join("&");

var TokenStatic =
    "\$2a\$10\$Pc5OVzcYF37.X9y8bH5pwubfTwqnfZC8UfxtR3QXBtlTttMUiWMz.";

Future<Dio> dio() async {
  return Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {
        "Authorization": 'Bearer ${TokenStatic}'
        // "Authorization": 'Bearer ${}'
      },
    ),
  );
}

class ApiErrorRepsonse {
  late bool status;
  late String? code;
  late Object? template;
  late String message;

  ApiErrorRepsonse({
    this.template,
    this.code,
    this.message = "",
    this.status = false,
  });
}

class Api {
  static Future<dynamic> get(
    String url, {
    Map? body,
  }) async {
    try {
      var response = await (await dio()).get('$url${getParams(body ?? {})}');
      // print(response);
      return response;
    } catch (error) {
      print('error');
      print(error);
    }
  }
}
