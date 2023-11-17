
import 'package:course_test_app/model/type.dart';

class Curriculum {
  final int key;
  final int id;
  final Types type;
  final String title;
  final int duration;
  final String content;
  final List<dynamic> meta;
  final int status;
  final String onlineVideoLink;
  final String offlineVideoLink;
  String filePath;

  Curriculum({
    required this.key,
    required this.id,
    required this.type,
    required this.title,
    required this.duration,
    required this.content,
    required this.meta,
    required this.status,
    required this.onlineVideoLink,
    required this.offlineVideoLink,
    this.filePath = ''
  });

  factory Curriculum.fromJson(Map<String, dynamic> json){
    Types types;
    String title = '';
    if(json["type"] == Types.SECTION.name){
      types = Types.SECTION;
      title = json["title"] ?? '';
    }else if(json["type"] == Types.UNIT.name){
      types = Types.UNIT;
      if(json["title"] != null) {
        title = json["title"].split('&#8211; ').last;
      }else{
        title = '';
      }
    }else{
      types = Types.ERROR;
    }
    return Curriculum(
      key: json["key"] ?? '',
      id: json["id"] != null ? int.parse(json["id"].toString()) : 0,
      type: types,
      title: title,
      duration: json["duration"] ?? 0,
      content: json["content"] ?? '',
      meta: json["meta"] != null ? List<dynamic>.from(json["meta"].map((x) => x)) : [],
      status: json["status"] ?? 0,
      onlineVideoLink: json["online_video_link"] ?? '',
      offlineVideoLink: json["offline_video_link"] ?? '',
    );
  }
}