import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rick_and_morty_app/core/error/failure.dart';
import 'package:flutter_rick_and_morty_app/feature/domain/entities/person_entity.dart';
import 'package:flutter_rick_and_morty_app/feature/domain/usecases/get_all_persons.dart';
import 'package:flutter_rick_and_morty_app/feature/domain/usecases/search_person.dart';
import 'package:flutter_rick_and_morty_app/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:flutter_rick_and_morty_app/feature/presentation/bloc/search_bloc/search_state.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHED_FAILURE_MESSAGE = 'Cache Failure';

class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
  final SearchPerson searchPerson;
  final GetAllPersons getAllPersons;
  int _currentPage = 1;
  bool _isFetching = false;

  PersonSearchBloc({required this.searchPerson, required this.getAllPersons})
      : super(PersonSearchEmpty()) {
    on<SearchPersons>(_onEvent);
    on<SearchAllPersons>(_onAllPersonsEvent);
  }

  FutureOr<void> _onEvent(
      SearchPersons event, Emitter<PersonSearchState> emit) async {
    print('Event triggered: ${event.runtimeType}'); // Debug log
    if (_isFetching) return;
    _isFetching = true;

    if (event.isNewQuery) {
      _currentPage = 1;
      emit(PersonSearchLoading());
    } else if (state is PersonSearchLoaded && event.isPaging) {
      emit(PersonSearchLoadingMore((state as PersonSearchLoaded).persons));
    }

    final failureOrPerson = await searchPerson(
        SearchPersonParams(query: event.personQuery, page: _currentPage));
    failureOrPerson.fold(
      (failure) {
        print('Failure: ${failure.runtimeType}'); // Debug log
        emit(PersonSearchError(message: _mapFailureToMessage(failure)));
      },
      (persons) {
        print('Persons loaded: ${persons.length}'); // Debug log
        if (state is PersonSearchLoaded && event.isPaging) {
          final currentState = state as PersonSearchLoaded;
          emit(PersonSearchLoaded(persons: currentState.persons + persons));
        } else {
          emit(PersonSearchLoaded(persons: persons));
        }
        _currentPage++;
      },
    );

    _isFetching = false;
  }

  void _onAllPersonsEvent(
      SearchAllPersons event, Emitter<PersonSearchState> emit) async {
    if (_isFetching) return;
    _isFetching = true;

    if (event.isNewQuery) {
      _currentPage = 1;
      emit(PersonSearchLoading());
    } else if (state is PersonSearchLoaded && event.isPaging) {
      emit(PersonSearchLoadingMore((state as PersonSearchLoaded).persons));
    }

    final failureOrPerson =
        await getAllPersons(PagePersonParams(page: _currentPage));
    failureOrPerson.fold(
      (failure) =>
          emit(PersonSearchError(message: _mapFailureToMessage(failure))),
      (persons) {
        if (state is PersonSearchLoaded && event.isPaging) {
          final currentState = state as PersonSearchLoaded;
          emit(PersonSearchLoaded(persons: currentState.persons + persons));
        } else {
          emit(PersonSearchLoaded(persons: persons));
        }
        _currentPage++;
      },
    );

    _isFetching = false;
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHED_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
