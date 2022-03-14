import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutterx/homePage/model/home_model.dart';
import 'package:flutterx/network/network.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'dart:convert';

class JobFeedController extends GetxController {
  var jobs = [].obs;

  Future<List<JobFeed>> fetchPhotos() async {
    final response = await dio.get('/get-all-jobs');

    // Use the compute function to run parsePhotos in a separate isolate.
    return compute(parsePhotos, response.data);
  }

  List<JobFeed> parsePhotos(responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    print(parsed);

    return parsed.map<JobFeed>((json) => JobFeed.fromJson(json)).toList();
  }

  static void fetchJobs() {}

  // Future getJobs() async {
  //   var response = await dio.get('/get-all-jobs');

  //   if (response.statusCode == 200) {
  //     var jobsJson = response.data;
  //     for (var jobJson in jobsJson) {
  //       jobs.add(JobFeed.fromJson(jobJson));
  //     }
  //   }
  //   print(jobs);
  //   return jobs;
  // }
}
