part of 'course_bloc.dart';

@immutable
abstract class CourseEvent {}

class CourseStarted extends CourseEvent {}

class CourseDownloadVideo extends CourseEvent {
  final int index;
  final String link;
  final int id;

  CourseDownloadVideo(this.index, this.link, this.id);
}

class CourseDeleteVideo extends CourseEvent {
  final String path;
  final int index;

  CourseDeleteVideo(this.path, this.index);
}

class CourseMock extends CourseEvent {

}