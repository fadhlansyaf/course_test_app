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