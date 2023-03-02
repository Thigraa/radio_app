import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:radio_app/src/models/radio_response.dart';
import 'package:radio_app/src/models/search_response.dart';
import 'package:radio_player/radio_player.dart';

import '../helpers/debouncer.dart';

import 'package:http/http.dart' as http;

class RadioProvider extends ChangeNotifier {
  final String _apiKey = '65ca2b1fc8mshe50c2b580463909p1af063jsnb1144158a6ab';
  final String _baseUrl = 'radio-world-75-000-worldwide-fm-radio-stations.p.rapidapi.com';

  late AnimationController _controller;

  //? RADIO PLAYER
  RadioPlayer _radioPlayer = new RadioPlayer();
  Station _selectedStation = Station(radioId: 0, radioName: 'radioName', radioImage: '', radioUrl: '', genre: '', countryId: 51);
  bool _isPlaying = false;

  //*RADIO SERVICE
  List<Station> radioStations = [];
  int _page = 0;

  final debouncer = Debouncer(duration: Duration(milliseconds: 500));

  final StreamController<List<Station>> _suggestionStreamController = new StreamController.broadcast();
  Stream<List<Station>> get suggestionStream => this._suggestionStreamController.stream;

  RadioProvider() {
    print('RadioProvider Started');
    this.getStations();
  }

  //*DEFAULT METHOD (Get spanish stations) --> Adds page when reaching the end of list
  getStations() async {
    _page++;
    final response = await http.get(
      Uri.parse('https://$_baseUrl/api.php?id=51&count=20&page=${_page.toString()}&category_detail'),
      headers: {'X-RapidAPI-Key': _apiKey, 'X-Rapidapi-Host': _baseUrl},
    );
    final radioStationsParse = RadioResponse.fromJson(json.decode(response.body));
    radioStations = [...radioStations, ...radioStationsParse.stations]; //ADD THE NEW STATIONS TO THE CURRENT LIST
    notifyListeners();
  }

  //*SEARCH METHOD (Can search +75.000 radio stations)
  Future<List<Station>> searchStations(String query) async {
    final response = await http.get(
      Uri.parse('https://radio-world-75-000-worldwide-fm-radio-stations.p.rapidapi.com/api.php?search=$query&count=20&page=1'),
      headers: {'X-RapidAPI-Key': _apiKey, 'X-Rapidapi-Host': _baseUrl},
    );
    final searchResponse = searchResponseFromJson(response.body);
    return searchResponse.stations;
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await this.searchStations(value);
      this._suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
  //*END SEARCH METHOD

  set selectedStation(Station station) {
    _selectedStation = station;
    _isPlaying = false; //TO PREVENT CRASHING THE RADIO PLAYER WE HAVE TO STOP THE SERVICE AND CHANGE THE CHANNEL
    _radioPlayer.stop();
    _radioPlayer.setChannel(title: station.radioName, url: station.radioUrl);
  }

  ///--------------------///
  ///GETTERS AND SETTERS///
  ///-------------------///

  Station get selectedStation {
    return _selectedStation;
  }

  set isPlaying(bool playing) {
    _isPlaying = playing;
  }

  bool get isPlaying {
    return _isPlaying;
  }

  set radioPlayer(RadioPlayer player) {
    _radioPlayer = player;
  }

  RadioPlayer get radioPlayer {
    return _radioPlayer;
  }

  set controller(AnimationController value) {
    _controller = value;
  }

  AnimationController get controller => _controller;
}
