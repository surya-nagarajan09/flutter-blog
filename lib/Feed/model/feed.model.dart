// To parse this JSON data, do
//
//     final blogFeed = blogFeedFromJson(jsonString);

import 'dart:convert';

List<BlogFeed> blogFeedFromJson(String str) =>
    List<BlogFeed>.from(json.decode(str).map((x) => BlogFeed.fromJson(x)));

String blogFeedToJson(List<BlogFeed> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BlogFeed {
  BlogFeed({
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

  factory BlogFeed.fromJson(Map<String, dynamic> json) => BlogFeed(
        id: json["id"],
        blogTitle: json["blog_title"],
        blogSubtitle: json["blog_subtitle"],
        story: json["story"],
        postedTime: DateTime.parse(json["posted_time"]),
        postedBy: json["posted_by"],
        userId: json["user_id"],
        likes: json["likes"],
        image: json["image"],
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
        "image": image,
      };
}
