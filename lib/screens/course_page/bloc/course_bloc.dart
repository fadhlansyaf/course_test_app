import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:course_test_app/services/api_service.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

import '../../../model/model.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  CourseBloc() : super(CourseInitial()) {
    on<CourseStarted>(onCourseStarted);
    on<CourseDownloadVideo>(onCourseDownload);
    on<CourseDeleteVideo>(onCourseDeleteVideo);
    on<CourseMock>(onCourseMock);
  }

  Future<void> onCourseStarted(CourseStarted event, Emitter<CourseState> emit) async {
    try{
      emit(CourseLoading());
      var course = await ApiService().getCourse();
      for(var e in course.curriculum){
        var dir = await getApplicationDocumentsDirectory();
        String fullPath = dir.path + '/${e.id}' + '.mp4';
        File file = File(fullPath);
        e.filePath = file.existsSync() ? fullPath : '';
      }
      emit(CourseLoaded(course));
    } catch (e){
      emit(CourseError());
    }
  }

  Future<void> onCourseDownload(CourseDownloadVideo event, Emitter<CourseState> emit) async {
    try{
      var downloaded = await ApiService().downloadVideo(emit, event.link, event.index);
      var dir = await getApplicationDocumentsDirectory();
      String fullPath = dir.path + '/${event.id}' + '.mp4';
      File file = File(fullPath);
      await file.writeAsBytes(downloaded, mode: FileMode.write);
      emit(CourseDownloaded(event.index, fullPath));
    } catch (e){
      emit(CourseError());
    }
  }

  void onCourseDeleteVideo(CourseDeleteVideo event, Emitter<CourseState> emit) {
    try{
      File file = File(event.path);
      file.deleteSync();
      emit(CourseDeleted(event.index));
    }catch(e){
      emit(CourseError());
    }
  }

  onCourseMock(CourseMock event, Emitter<CourseState> emit) {
    emit(CourseLoaded(CourseModel.fromJson({
      "course_name": "Akuntansi dasar",
      "progress": "38",
      "curriculum": [
        {
          "key": 0,
          "id": 0,
          "type": "section",
          "title": "PENGANTAR",
          "duration": 0,
          "content": "",
          "meta": []
        },
        {
          "key": 1,
          "id": "1989",
          "type": "unit",
          "title": "1 &#8211; Perkenalan",
          "duration": 240,
          "content": "",
          "status": 1,
          "meta": [],
          "online_video_link": "https://storage.googleapis.com/samplevid-bucket/offline_arsenal_westham.mp4",
          "offline_video_link": "https://storage.googleapis.com/samplevid-bucket/offline_leeds_arsenal.mp4"
        },
        {
          "key": 2,
          "id": 0,
          "type": "section",
          "title": "LEVEL 1",
          "duration": 240,
          "content": "",
          "meta": []
        },
        {
          "key": 3,
          "id": "1993",
          "type": "unit",
          "title": "2 &#8211; Marketing vs Sales",
          "duration": 240,
          "content": "",
          "status": 1,
          "meta": [],
          "online_video_link": "",
          "offline_video_link": "https://dlv.arkademi.com/Inbound/2.mp4"
        },
        {
          "key": 4,
          "id": "1995",
          "type": "unit",
          "title": "3 &#8211; Apa Itu Digital Marketing",
          "duration": 300,
          "content": "",
          "status": 1,
          "meta": [],
          "online_video_link": "https://storage.googleapis.com/samplevid-bucket/offline_liverpool_newcastle.mp4",
          "offline_video_link": "https://storage.googleapis.com/samplevid-bucket/offline_tottenham_liverpool.mp4"
        },
        {
          "key": 6,
          "id": 0,
          "type": "section",
          "title": "LEVEL 2",
          "duration": 600480,
          "content": "",
          "meta": []
        },
        {
          "key": 7,
          "id": "1997",
          "type": "unit",
          "title": "4 &#8211; Apa dan Mengapa Inbound Marketing",
          "duration": 360,
          "content": "",
          "status": 1,
          "meta": [],
          "online_video_link": "https://storage.googleapis.com/samplevid-bucket/online_chelsea_juventus.mp4",
          "offline_video_link": "https://storage.googleapis.com/samplevid-bucket/online_chelsea_leeds.mp4"
        },
        {
          "key": 8,
          "id": "1999",
          "type": "unit",
          "title": "5 &#8211; Fundamental Inbound Marketing (1)",
          "duration": 420,
          "content": "",
          "status": 1,
          "meta": [],
          "online_video_link": "https://storage.googleapis.com/samplevid-bucket/online_city_leeds.mp4",
          "offline_video_link": "https://storage.googleapis.com/samplevid-bucket/online_newcastle_city.mp4"
        },
        {
          "key": 9,
          "id": 0,
          "type": "section",
          "title": "PENUTUP",
          "duration": 601320,
          "content": "",
          "meta": []
        },
        {
          "key": 10,
          "id": "2404",
          "type": "unit",
          "title": "Penutup Inbound",
          "duration": 1,
          "content": "",
          "status": 1,
          "meta": [],
          "online_video_link": "",
          "offline_video_link": null
        }
      ]
    })));
  }
}
