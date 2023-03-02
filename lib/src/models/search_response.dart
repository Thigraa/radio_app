import 'dart:convert';

import 'package:radio_app/src/models/radio_response.dart';

SearchResponse searchResponseFromJson(String str) => SearchResponse.fromJson(json.decode(str));

class SearchResponse {
  SearchResponse({
    required this.status,
    required this.count,
    required this.countTotal,
    required this.pages,
    required this.stations,
  });

  String status;
  int count;
  int countTotal;
  int pages;
  List<Station> stations;

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        status: json["status"],
        count: json["count"],
        countTotal: json["count_total"],
        pages: json["pages"],
        stations: List<Station>.from(json["stations"].map((x) => Station.fromJson(x))),
      );
}
