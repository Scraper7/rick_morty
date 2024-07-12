import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_rick_and_morty_app/core/error/failure.dart';
import 'package:flutter_rick_and_morty_app/core/usecases/usecase.dart';
import 'package:flutter_rick_and_morty_app/feature/domain/entities/person_entity.dart';
import 'package:flutter_rick_and_morty_app/feature/domain/repositories/person_repository.dart';

class SearchPerson extends UseCase<List<PersonEntity>, SearchPersonParams> {
  final PersonRepository personRepository;

  SearchPerson(this.personRepository);

  Future<Either<Failure, List<PersonEntity>>> call(
      SearchPersonParams params) async {
    return await personRepository.searchPerson(params.query, params.page);
  }
}

class SearchPersonParams extends Equatable {
  final String query;
  final int page;

  SearchPersonParams({required this.query, required this.page});

  @override
  List<Object> get props => [query];
}
