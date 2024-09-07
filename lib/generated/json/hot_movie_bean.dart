class MovieBean {
  List<Subjects>? subjects;

  MovieBean({this.subjects});

  MovieBean.fromJson(Map<String, dynamic> json) {
    if (json['subjects'] != null) {
      subjects = <Subjects>[];
      json['subjects'].forEach((v) {
        subjects!.add(new Subjects.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.subjects != null) {
      data['subjects'] = this.subjects!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subjects {
  String? episodesInfo;
  String? rate;
  int? coverX;
  String? title;
  String? url;
  bool? playable;
  String? cover;
  String? id;
  int? coverY;
  bool? isNew;

  Subjects(
      {this.episodesInfo,
      this.rate,
      this.coverX,
      this.title,
      this.url,
      this.playable,
      this.cover,
      this.id,
      this.coverY,
      this.isNew});

  Subjects.fromJson(Map<String, dynamic> json) {
    episodesInfo = json['episodes_info'];
    rate = json['rate'];
    coverX = json['cover_x'];
    title = json['title'];
    url = json['url'];
    playable = json['playable'];
    cover = json['cover'];
    id = json['id'];
    coverY = json['cover_y'];
    isNew = json['is_new'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['episodes_info'] = this.episodesInfo;
    data['rate'] = this.rate;
    data['cover_x'] = this.coverX;
    data['title'] = this.title;
    data['url'] = this.url;
    data['playable'] = this.playable;
    data['cover'] = this.cover;
    data['id'] = this.id;
    data['cover_y'] = this.coverY;
    data['is_new'] = this.isNew;
    return data;
  }
}