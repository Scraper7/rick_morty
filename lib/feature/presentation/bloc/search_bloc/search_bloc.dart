import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rick_and_morty_app/core/error/failure.dart';
import 'package:flutter_rick_and_morty_app/feature/domain/usecases/search_person.dart';
import 'package:flutter_rick_and_morty_app/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:flutter_rick_and_morty_app/feature/presentation/bloc/search_bloc/search_state.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHED_FAILURE_MESSAGE = 'Cache Failure';

class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
  final SearchPerson searchPerson;
  int currentPage = 1;
  bool isFetching = false;

  PersonSearchBloc({required this.searchPerson}) : super(PersonEmpty()) {
    on<SearchPersons>(_onSearchPersons);
    on<LoadMorePersons>(_onLoadMorePersons);
  }

  void _onSearchPersons(
      SearchPersons event, Emitter<PersonSearchState> emit) async {
    emit(PersonSearchLoading());
    currentPage = 1; // Reset to first page for new search

    final failureOrPerson = await searchPerson(
        SearchPersonParams(query: event.personQuery, page: currentPage));
    emit(failureOrPerson.fold(
      (failure) => PersonSearchError(message: _mapFailureToMessage(failure)),
      (person) => PersonSearchLoaded(persons: person),
    ));
  }

  void _onLoadMorePersons(
      LoadMorePersons event, Emitter<PersonSearchState> emit) async {
    final currentState = state;
    if (currentState is PersonSearchLoaded && !isFetching) {
      isFetching = true;
      emit(PersonSearchLoadingMore(currentState.persons));
      currentPage++;

      final failureOrPerson = await searchPerson(
          SearchPersonParams(query: event.query, page: currentPage));
      emit(failureOrPerson.fold(
        (failure) => PersonSearchError(message: _mapFailureToMessage(failure)),
        (person) => PersonSearchLoaded(persons: currentState.persons + person),
      ));
      isFetching = false;
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHED_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
