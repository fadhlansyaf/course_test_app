import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/model.dart';
import '../screens/course_page/bloc/course_bloc.dart';

class ApiService {
  static const _baseUrl = 'https://engineer-test-eight.vercel.app/';

  ///Setup dio
  Dio getDio() {
    Dio dio = Dio();
    dio.options.contentType = Headers.jsonContentType;
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return dio;
  }

  Future<CourseModel> getCourse() async {
    try {
      final response = await getDio().get('${_baseUrl}course-status.json');
      return CourseModel.fromJson(response.data);
    } catch (e) {
      return CourseModel.fromJson({});
    }
  }

  Future<Uint8List> downloadVideo(Emitter<CourseState> emit, String link, int index) async {
    try {
      final response = await getDio().get(
        link,
        onReceiveProgress: (count, total) {
          emit(CourseDownloading(count / total, index));
        },
        options: Options(responseType: ResponseType.bytes)
      );
      return response.data;
    } catch (e) {
      print(e);
      return Uint8List(0);
    }
  }
}
