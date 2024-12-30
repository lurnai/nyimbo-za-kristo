import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/song_model.dart';

Future<List<Song>> loadSongs() async {
  final String jsonString = await rootBundle.loadString('assets/songs.json');
  final List<dynamic> jsonResponse = json.decode(jsonString);
  return jsonResponse.map((song) => Song.fromJson(song)).toList();
}
