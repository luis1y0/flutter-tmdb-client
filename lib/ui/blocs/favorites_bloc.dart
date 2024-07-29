import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kueski_app/domain/entities/movie.dart';
import 'package:kueski_app/domain/repositories/movies_repository.dart';

sealed class FavoriteEvent {}

class LoadFavoritesEvent extends FavoriteEvent {}

class LikeEvent extends FavoriteEvent {
  final Movie movie;

  LikeEvent(this.movie);
}

class DislikeEvent extends FavoriteEvent {
  final Movie movie;

  DislikeEvent(this.movie);
}

sealed class FavoriteState {
  final List<Movie> movies;

  FavoriteState(this.movies);
}

class ListFavoriteState extends FavoriteState {
  ListFavoriteState(super.movies);
}

class FavoritesBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final MoviesRepository _repository;
  FavoritesBloc(this._repository) : super(ListFavoriteState([])) {
    on<LikeEvent>(_likeDislike);
    on<DislikeEvent>(_likeDislike);
    on<LoadFavoritesEvent>(_loadFavorites);
    add(LoadFavoritesEvent());
  }

  FutureOr<void> _loadFavorites(_, Emitter<FavoriteState> emit) async {
    List<Movie> movies = await _repository.getFavorites();
    emit(ListFavoriteState(movies));
  }

  FutureOr<void> _likeDislike(
      FavoriteEvent event, Emitter<FavoriteState> emit) async {
    List<Movie> movies = [];
    if (event is LikeEvent) {
      movies.addAll(await _repository.setFavorite(event.movie, true));
    } else if (event is DislikeEvent) {
      movies.addAll(await _repository.setFavorite(event.movie, false));
    }
    emit(ListFavoriteState(movies));
  }
}
