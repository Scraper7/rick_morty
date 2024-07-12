import 'package:equatable/equatable.dart';

abstract class PersonSearchEvent extends Equatable {
  const PersonSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchPersons extends PersonSearchEvent {
  final String personQuery;

  const SearchPersons(this.personQuery);

  @override
  List<Object> get props => [personQuery];
}

class LoadMorePersons extends PersonSearchEvent {
  final String query;

  const LoadMorePersons({required this.query});

  @override
  List<Object> get props => [query];
}
