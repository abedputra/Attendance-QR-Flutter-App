import 'dart:convert';

String attendanceToJson(Attendance data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Attendance {
  int? id;
  String? date;
  String? time;
  String? name;
  String? location;
  String? type;

  Attendance({
    this.id,
    this.date,
    this.time,
    this.name,
    this.location,
    this.type,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        id: int.parse(json["id"].toString()),
        date: json["date"].toString(),
        time: json["time"].toString(),
        name: json["name"].toString(),
        location: json["location"].toString(),
        type: json["type"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "time": time,
        "name": name,
        "location": location,
        "type": type,
      };
}
