import 'dart:typed_data';

import 'package:course_test_app/model/course_model.dart';
import 'package:course_test_app/model/curriculum.dart';
import 'package:course_test_app/model/model.dart';
import 'package:course_test_app/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'unit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ApiService>()])
void main() {
  group('ApiService test', () {
    test('receive data from api', () async {
      final mockApiService = MockApiService();
      when(mockApiService.getCourse()).thenAnswer((_) async {
        var course =
            CourseModel(courseName: 'Nama', progress: '40', curriculum: [
          Curriculum(
            key: 1,
            id: 1,
            type: Types.SECTION,
            title: 'Judul Section',
            duration: 240,
            content: '',
            meta: [],
            status: 0,
            onlineVideoLink: '',
            offlineVideoLink: '',
          ),
          Curriculum(
              key: 2,
              id: 2,
              type: Types.UNIT,
              title: 'Judul Unit',
              duration: 100,
              content: '',
              meta: [],
              status: 0,
              onlineVideoLink: '',
              offlineVideoLink: '')
        ]);
        return course;
      });
      final course = await mockApiService.getCourse();
      expect(course.courseName, 'Nama');
      expect(course.progress, '40');

      expect(course.curriculum[0].key, 1);
      expect(course.curriculum[0].id, 1);
      expect(course.curriculum[0].type, Types.SECTION);
      expect(course.curriculum[0].title, 'Judul Section');
      expect(course.curriculum[0].duration, 240);
      expect(course.curriculum[0].content, '');
      expect(course.curriculum[0].meta, []);
      expect(course.curriculum[0].status, 0);
      expect(course.curriculum[0].onlineVideoLink, '');
      expect(course.curriculum[0].offlineVideoLink, '');

      expect(course.curriculum[1].key, 2);
      expect(course.curriculum[1].id, 2);
      expect(course.curriculum[1].type, Types.UNIT);
      expect(course.curriculum[1].title, 'Judul Unit');
      expect(course.curriculum[1].duration, 100);
      expect(course.curriculum[1].content, '');
      expect(course.curriculum[1].meta, []);
      expect(course.curriculum[1].status, 0);
      expect(course.curriculum[1].onlineVideoLink, '');
      expect(course.curriculum[1].offlineVideoLink, '');
    });

    test('throw error on api hit', () async {
      final mockApiService = MockApiService();
      when(mockApiService.getCourse())
          .thenThrow(Exception('failed to get data'));
      expect(() async => await mockApiService.getCourse(), throwsException);
    });

    test('download video data', () async {
      final mockApiService = MockApiService();
      when(mockApiService.downloadVideo(null, 'link', 0))
          .thenAnswer((_) async => Uint8List(0));

      var result = await mockApiService.downloadVideo(null, 'link', 0);
      expect(result, Uint8List(0));
    });

    test('failed to download video data', () async {
      final mockApiService = MockApiService();
      when(mockApiService.downloadVideo(null, 'link', 0))
          .thenThrow(Exception('failed to download video'));

      expect(() async => await mockApiService.downloadVideo(null, 'link', 0),
          throwsException);
    });
  });
}
