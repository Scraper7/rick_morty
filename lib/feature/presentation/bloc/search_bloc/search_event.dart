import 'package:equatable/equatable.dart';

abstract class PersonSearchEvent extends Equatable {
  const PersonSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchPersons extends PersonSearchEvent {
  final String personQuery;
  final bool isPaging;
  final bool isNewQuery;

  const SearchPersons(this.personQuery,
      {this.isPaging = false, this.isNewQuery = false});
}

class SearchAllPersons extends PersonSearchEvent {
  final bool isPaging;
  final bool isNewQuery;

  const SearchAllPersons({this.isPaging = false, this.isNewQuery = false});
}
