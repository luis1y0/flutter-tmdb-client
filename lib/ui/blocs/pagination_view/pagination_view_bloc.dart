import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kueski_app/domain/entities/movie.dart';
import 'package:kueski_app/domain/repositories/movies_repository.dart';

sealed class PaginationEvent {}

class AddFirstPageEvent extends PaginationEvent {}

class NearPageEndEvent extends PaginationEvent {}

class RefreshPageEvent extends PaginationEvent {}

sealed class PaginationState {
  final List<Movie> movies;

  PaginationState(this.movies);
}

class LoadingPaginationState extends PaginationState {
  LoadingPaginationState(super.movies);
}

class ListPaginationState extends PaginationState {
  ListPaginationState(super.movies);
}

class FetchingPaginationState extends PaginationState {
  FetchingPaginationState(super.movies);
}

enum PageName { nowPlaying, popular, favorite }

class PaginationViewBloc extends Bloc<PaginationEvent, PaginationState> {
  final PageName pageName;
  final MoviesRepository _repository;
  final List<Movie> movies = [];
  int _currentPage = 1;
  double scrollPosition = 0.0;
  PaginationViewBloc(this._repository, {required this.pageName})
      : super(LoadingPaginationState([])) {
    on<AddFirstPageEvent>(_addFirstPage);
    on<NearPageEndEvent>(_nearEndOfPage);
    on<RefreshPageEvent>(_refreshPage);
    add(AddFirstPageEvent());
  }

  FutureOr<void> _addFirstPage(
      AddFirstPageEvent event, Emitter<PaginationState> emit) async {
    switch (pageName) {
      case PageName.nowPlaying:
        movies.addAll(await _repository.getNowPlayingMovies(_currentPage));
        break;
      case PageName.popular:
        movies.addAll(await _repository.getPopularMovies(_currentPage));
        break;
      case PageName.favorite:
        movies.addAll(await _repository.getFavorites());
        break;
    }
    emit(ListPaginationState(movies));
  }

  FutureOr<void> _nearEndOfPage(
      NearPageEndEvent event, Emitter<PaginationState> emit) async {
    if (state is FetchingPaginationState) {
      return;
    }
    emit(FetchingPaginationState(state.movies));
    _currentPage++;
    switch (pageName) {
      case PageName.nowPlaying:
        movies.addAll(await _repository.getNowPlayingMovies(_currentPage));
        break;
      case PageName.popular:
        movies.addAll(await _repository.getPopularMovies(_currentPage));
        break;
      case PageName.favorite:
        return;
    }
    emit(ListPaginationState(movies));
  }

  FutureOr<void> _refreshPage(
      RefreshPageEvent event, Emitter<PaginationState> emit) async {
    switch (pageName) {
      case PageName.nowPlaying:
        break;
      case PageName.popular:
        break;
      case PageName.favorite:
        movies.clear();
        movies.addAll(await _repository.getFavorites());
        break;
    }
    emit(ListPaginationState(movies));
  }
}
