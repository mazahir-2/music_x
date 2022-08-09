import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music_x/models/track.dart';
import 'package:http/http.dart' as http;
import 'package:music_x/secrets.dart';

part 'music_event.dart';
part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  MusicBloc() : super(MusicLoading()) {
    on<FetchTracks>((event, emit) async {
      emit(MusicLoading());
      final res = await http.get(Uri.parse(
          'https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=$apiKey'));
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body)['message'];
        if (json['header']['status_code'] == 200) {
          final List<Track> list = (json['body']['track_list'] as List)
              .map((e) => Track.fromJson(e['track']))
              .toList();
          emit(MusicLoaded(tracks: list));
        } else {
          emit(const MusicError(
              error: "Something went wrong, Please try again later"));
        }
      } else {
        emit(const MusicError(error: "Something went wrong"));
      }
    });
  }
}
