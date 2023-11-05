class VideoModel {
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

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
  //  _data['call_to_action'] = callToAction.toJson();
    _data['duration'] = duration;
    _data['description'] = description;
    _data['datetime'] = datetime;
    _data['content'] = content.toJson();
    _data['type'] = type;
    return _data;
  }
}

class CallToAction {
  CallToAction({
    required this.url,
  });
  late final String url;
  
  CallToAction.fromJson(Map<String, dynamic> json){
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['url'] = url;
    return _data;
  }
}

class Content {
  Content({
    required this.id,
    required this.path,
    required this.skipAfter,
  });
  late final dynamic id;
  late final String path;
  late final dynamic skipAfter;
  
  Content.fromJson(Map<String, dynamic> json){
    id = json['id'];
    path = json['path'];
    skipAfter = json['skip_after'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['path'] = path;
    _data['skip_after'] = skipAfter;
    return _data;
  }
}