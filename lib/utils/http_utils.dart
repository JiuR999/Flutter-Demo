import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/base/base_page.dart';
import 'package:flutter_application_1/constants/message_constant.dart';
import 'package:http/http.dart' as http;

class HttpUtils{
  static Future<String> fetchData(BuildContext context,String url) async {
  final response = await http.get(Uri.parse(url));
  try {
    if (response.statusCode == 200) {
      return response.body.toString();
    } else {
      throw Exception(MessageConstant.LOAD_FAILED);
    }
  } catch (e) {
    // 记录异常信息
      ShowSnackBar(context, MessageConstant.LOAD_FAILED);
      rethrow;
  }
}
}
