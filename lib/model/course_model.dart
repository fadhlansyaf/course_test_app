import 'curriculum.dart';
import 'model.dart';

class CourseModel {
  final String courseName;
  final String progress;
  final List<Curriculum> curriculum;

  CourseModel({
    required this.courseName,
    required this.progress,
    required this.curriculum,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
    courseName: json["course_name"] ?? '',
    progress: json["progress"] ?? '',
    curriculum: json["curriculum"] != null ? List<Curriculum>.from(json["curriculum"].map((x) => Curriculum.fromJson(x))) : [],
  );
}