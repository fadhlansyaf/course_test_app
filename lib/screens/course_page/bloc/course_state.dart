part of 'course_bloc.dart';

@immutable
abstract class CourseState {}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseLoaded extends CourseState {
  final CourseModel courseModel;

  CourseLoaded(this.courseModel);
}

class CourseDownloading extends CourseState {
  final double progress;
  final int downloadingIndex;

  CourseDownloading(this.progress, this.downloadingIndex);
}

class CourseDownloaded extends CourseState {
  final int index;
  final String savedPath;

  CourseDownloaded(this.index, this.savedPath);
}

class CourseError extends CourseState {}

