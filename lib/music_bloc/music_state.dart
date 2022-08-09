part of 'music_bloc.dart';

abstract class MusicState extends Equatable {
  const MusicState();

  @override
  List<Object> get props => [];
}

class MusicLoading extends MusicState {}

class MusicLoaded extends MusicState {
  final List<Track> tracks;

  const MusicLoaded({required this.tracks});

  @override
  List<Object> get props => [tracks];
}

class MusicError extends MusicState {
  final String error;

  const MusicError({required this.error});

  @override
  List<Object> get props => [error];
}
