import 'package:equatable/equatable.dart';

class Track extends Equatable {
  final String trackId;
  final String trackName;
  final int trackRating;
  final String albumName;
  final bool hasLyrics;
  final String artistName;
  final bool explicit;

  const Track(this.trackId, this.trackName, this.trackRating, this.albumName,
      this.hasLyrics, this.artistName, this.explicit);

  @override
  bool get stringify => true;

  Track.fromJson(Map<String, dynamic> json)
      : trackId = json['track_id'].toString(),
        trackName = json['track_name'].toString(),
        trackRating = int.tryParse(json['track_rating'].toString()) ?? 0,
        albumName = json['album_name'].toString(),
        hasLyrics =
            int.tryParse(json['has_lyrics'].toString()) == 0 ? false : true,
        artistName = json['artist_name'].toString(),
        explicit =
            int.tryParse(json['explicit'].toString()) == 0 ? false : true;

  @override
  List<Object?> get props => [
        trackId,
        trackName,
        trackRating,
        albumName,
        hasLyrics,
        artistName,
        explicit
      ];
}
