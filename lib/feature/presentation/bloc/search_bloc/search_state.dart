import 'package:equatable/equatable.dart';
import 'package:flutter_rick_and_morty_app/feature/domain/entities/person_entity.dart';

abstract class PersonSearchState extends Equatable {
  const PersonSearchState();

  @override
  List<Object> get props => [];
}

class PersonSearchEmpty extends PersonSearchState {}

class PersonSearchLoading extends PersonSearchState {}

class PersonSearchLoaded extends PersonSearchState {
  final List<PersonEntity> persons;

  const PersonSearchLoaded({required this.persons});

  @override
  List<Object> get props => [persons];
}

class PersonSearchLoadingMore extends PersonSearchState {
  final List<PersonEntity> persons;

  const PersonSearchLoadingMore(this.persons);

  @override
  List<Object> get props => [persons];
}

class PersonSearchError extends PersonSearchState {
  final String message;

  const PersonSearchError({required this.message});

  @override
  List<Object> get props => [message];
}
