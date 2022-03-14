class JobFeed {
  final int id;
  final String jobrole;
  final String jobdescription;
  final String postedtime;
  final String companyname;
  final String skills;

  const JobFeed(
      {required this.id,
      required this.jobrole,
      required this.jobdescription,
      required this.postedtime,
      required this.companyname,
      required this.skills});

  factory JobFeed.fromJson(Map<String, dynamic> json) {
    return JobFeed(
      id: json['id'] as int,
      jobrole: json['jobrole'] as String,
      jobdescription: json['title'] as String,
      postedtime: json['url'] as String,
      companyname: json['companyname'] as String,
      skills: json["skills"] as String,
    );
  }
}
