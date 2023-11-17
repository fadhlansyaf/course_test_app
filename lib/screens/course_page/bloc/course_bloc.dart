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
}
