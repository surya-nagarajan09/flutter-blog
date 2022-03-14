import 'dart:convert';

List<JobFeed> jobFeedFromJson(String str) =>
    List<JobFeed>.from(json.decode(str).map((x) => JobFeed.fromJson(x)));

String jobFeedToJson(List<JobFeed> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JobFeed {
  JobFeed({
    required this.id,
    required this.jobrole,
    required this.jobdescription,
    required this.postedtime,
    required this.companyname,
    required this.skills,
  });

  int id;
  String jobrole;
  String jobdescription;
  DateTime postedtime;
  String companyname;
  String skills;

  factory JobFeed.fromJson(Map<String, dynamic> json) => JobFeed(
        id: json["id"],
        jobrole: json["jobrole"],
        jobdescription: json["jobdescription"],
        postedtime: DateTime.parse(json["postedtime"]),
        companyname: json["companyname"],
        skills: json["skills"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "jobrole": jobrole,
        "jobdescription": jobdescription,
        "postedtime": postedtime.toIso8601String(),
        "companyname": companyname,
        "skills": skills,
      };
}
