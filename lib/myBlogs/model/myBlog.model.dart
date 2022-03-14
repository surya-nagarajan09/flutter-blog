// To parse this JSON data, do
//
//     final myblogFeed = myblogFeedFromJson(jsonString);

import 'dart:convert';

List<MyblogFeed> myblogFeedFromJson(String str) =>
    List<MyblogFeed>.from(json.decode(str).map((x) => MyblogFeed.fromJson(x)));

String myblogFeedToJson(List<MyblogFeed> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyblogFeed {
  MyblogFeed({
    required this.id,
    required this.blogTitle,
    required this.blogSubtitle,
    required this.story,
    required this.postedTime,
    required this.postedBy,
    required this.userId,
    required this.likes,
    required this.image,
  });

  int id;
  String blogTitle;
  String blogSubtitle;
  String story;
  DateTime postedTime;
  String postedBy;
  int userId;
  int likes;
  String image;

  factory MyblogFeed.fromJson(Map<String, dynamic> json) => MyblogFeed(
        id: json["id"],
        blogTitle: json["blog_title"],
        blogSubtitle: json["blog_subtitle"],
        story: json["story"],
        postedTime: DateTime.parse(json["posted_time"]),
        postedBy: json["posted_by"],
        userId: json["user_id"],
        likes: json["likes"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "blog_title": blogTitle,
        "blog_subtitle": blogSubtitle,
        "story": story,
        "posted_time": postedTime.toIso8601String(),
        "posted_by": postedBy,
        "user_id": userId,
        "likes": likes,
        "image": image == null ? null : image,
      };
}
