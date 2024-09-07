class CourseTableBean {
  String? msg;
  int? code;
  List<Data>? data;

  CourseTableBean({this.msg, this.code, this.data});

  CourseTableBean.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    code = json['code'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? courseName;
  String? teacherName;
  int? beginWeek;
  int? endWeek;
  String? location;
  String? startGetDay;
  String? startGetTime;

  Data(
      {this.courseName,
      this.teacherName,
      this.beginWeek,
      this.endWeek,
      this.location,
      this.startGetDay,
      this.startGetTime});

  Data.fromJson(Map<String, dynamic> json) {
    courseName = json['courseName'];
    teacherName = json['teacherName'];
    beginWeek = json['beginWeek'];
    endWeek = json['endWeek'];
    location = json['location'];
    startGetDay = json['startGetDay'];
    startGetTime = json['startGetTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courseName'] = this.courseName;
    data['teacherName'] = this.teacherName;
    data['beginWeek'] = this.beginWeek;
    data['endWeek'] = this.endWeek;
    data['location'] = this.location;
    data['startGetDay'] = this.startGetDay;
    data['startGetTime'] = this.startGetTime;
    return data;
  }
}