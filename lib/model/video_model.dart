class VideoModel {
  
  VideoModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
  //  callToAction = CallToAction.fromJson(json['call_to_action']);
    duration = json['duration'];
    description = json['description'];
    datetime = json['datetime'];
    content = Content.fromJson(json['content']);
    type = json['type'];
  }
  VideoModel({
    required this.id,
    required this.title,
 //   required this.callToAction,
    required this.duration,
    required this.description,
    required this.datetime,
    required this.content,
    required this.type,
  });
  late final int id;
  late final String title;
 // late final CallToAction callToAction;
  late final dynamic duration;
  late final String description;
  late final String datetime;
  late final Content content;
  late final String type;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
  //  _data['call_to_action'] = callToAction.toJson();
    data['duration'] = duration;
    data['description'] = description;
    data['datetime'] = datetime;
    data['content'] = content.toJson();
    data['type'] = type;
    return data;
  }
}

class CallToAction {
  
  CallToAction.fromJson(Map<String, dynamic> json){
    url = json['url'];
  }
  CallToAction({
    required this.url,
  });
  late final String url;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['url'] = url;
    return data;
  }
}

class Content {
  
  Content.fromJson(Map<String, dynamic> json){
    id = json['id'];
    path = json['path'];
    skipAfter = json['skip_after'];
  }
  Content({
    required this.id,
    required this.path,
    required this.skipAfter,
  });
  late final dynamic id;
  late final String path;
  late final dynamic skipAfter;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['path'] = path;
    data['skip_after'] = skipAfter;
    return data;
  }
}