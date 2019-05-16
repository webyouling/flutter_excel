import 'dart:convert';

/// 用于传递创建下载任务的必要信息
/*
{  
       "title":"text",
       "weburl":"text",
       "videourl":"text"
}
*/

InfoData videoInfoFromJson(String str) {
  final jsonData = json.decode(str);
  return InfoData.fromJson(jsonData);
}

String videoInfoToJson(InfoData data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class InfoData {
  String type;
  String content;
  String time;

  InfoData({
    this.type,
    this.content,
    this.time,
  });

  factory InfoData.fromJson(Map<String, dynamic> json) => new InfoData(
        type: json["type"],
        content: json["content"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "content": content,
        "time": time,
      };
}