import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:music_x/models/track.dart';
import 'package:http/http.dart' as http;
import 'package:music_x/secrets.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key, required this.track}) : super(key: key);
  final Track track;
  @override
  Widget build(BuildContext context) {
    final textStyle =
        Theme.of(context).textTheme.apply(displayColor: Colors.black);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Tile(
              textStyle: textStyle,
              subTitle: track.trackName,
              title: "Name",
            ),
            Tile(
              textStyle: textStyle,
              subTitle: track.artistName,
              title: "Artist",
            ),
            Tile(
              textStyle: textStyle,
              subTitle: track.albumName,
              title: "Album",
            ),
            Tile(
              textStyle: textStyle,
              subTitle: track.trackRating.toString(),
              title: "Ratings",
            ),
            Tile(
              textStyle: textStyle,
              subTitle: track.explicit.toString(),
              title: "Explicit",
            ),
            const SizedBox(height: 10),
            Text(
              'Lyrics',
              style: textStyle.titleLarge,
            ),
            const Divider(),
            const SizedBox(height: 5),
            FutureBuilder<String>(
              future: Future((() async {
                final res = await http.get(Uri.parse(
                    'https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=${track.trackId}&apikey=$apiKey'));
                if (res.statusCode == 200) {
                  final json = jsonDecode(res.body)['message'];
                  if (json['header']['status_code'] == 200) {
                    return json['body']['lyrics']['lyrics_body'].toString();
                  } else {
                    return Future.error("Something went wrong");
                  }
                } else {
                  return Future.error("Something went wrong");
                }
              })),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.textStyle,
    required this.subTitle,
    required this.title,
  }) : super(key: key);

  final TextTheme textStyle;
  final String subTitle;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textStyle.titleLarge,
          ),
          Text(
            subTitle,
            style: textStyle.bodyLarge,
          ),
        ],
      ),
    );
  }
}
