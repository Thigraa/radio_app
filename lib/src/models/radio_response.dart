import 'dart:convert';

RadioResponse radioResponseFromJson(String str) => RadioResponse.fromJson(json.decode(str));

class RadioResponse {
  RadioResponse({
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

  factory RadioResponse.fromJson(Map<String, dynamic> json) => RadioResponse(
        status: json["status"] ?? '',
        count: json["count"],
        countTotal: json["count_total"],
        pages: json["pages"],
        stations: List<Station>.from(json["stations"].map((x) => Station.fromJson(x))),
      );
}

class Station {
  Station({
    required this.radioId,
    required this.radioName,
    required this.radioImage,
    required this.radioUrl,
    required this.genre,
    required this.countryId,
  });

  int radioId;
  String radioName;
  String radioImage;
  String radioUrl;
  String genre;
  int countryId;
  String? _heroId;

  factory Station.fromJson(Map<String, dynamic> json) => Station(
        radioId: json["radio_id"],
        radioName: json["radio_name"],
        radioImage: json["radio_image"],
        radioUrl: json["radio_url"],
        genre: json["genre"],
        countryId: json["country_id"],
      );

  set heroId(String heroId) {
    _heroId = heroId;
  }

  String get heroId {
    return _heroId ?? '';
  }
}
