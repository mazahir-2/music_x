import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_x/music_bloc/music_bloc.dart';
import 'package:music_x/screens/track_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (_) {
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Popular Tracks"),
      ),
      body: BlocBuilder<MusicBloc, MusicState>(
        builder: (context, state) {
          if (_connectionStatus == ConnectivityResult.ethernet ||
              _connectionStatus == ConnectivityResult.mobile ||
              _connectionStatus == ConnectivityResult.wifi) {
            if (state is MusicLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<MusicBloc>().add(FetchTracks());
                },
                child: ListView.builder(
                  itemCount: state.tracks.length,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.music_note),
                      title: Text(state.tracks[index].trackName),
                      subtitle: Text(state.tracks[index].artistName),
                      trailing: const Icon(Icons.chevron_right_sharp),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailsScreen(track: state.tracks[index]),
                          )),
                    ),
                  ),
                ),
              );
            } else if (state is MusicLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MusicError) {
              return Center(
                child: Text(
                  state.error,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              );
            } else {
              return Center(
                child: Text(
                  "Something is went wrong",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              );
            }
          } else {
            return Center(
              child: Text(
                "No Internet",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          }
        },
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
