import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rick_and_morty_app/feature/domain/entities/person_entity.dart';
import 'package:flutter_rick_and_morty_app/feature/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:flutter_rick_and_morty_app/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:flutter_rick_and_morty_app/feature/presentation/bloc/search_bloc/search_state.dart';
import 'package:flutter_rick_and_morty_app/feature/presentation/widgets/search_result.dart';

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate() : super(searchFieldLabel: 'Search for characters...');

  final _suggestions = [
    'Rick',
    'Morty',
    'Summer',
    'Beth',
    'Jerry',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back_outlined),
        tooltip: 'Back',
        onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      BlocProvider.of<PersonSearchBloc>(context, listen: false)
          .add(SearchAllPersons(isNewQuery: true));
    } else {
      BlocProvider.of<PersonSearchBloc>(context, listen: false)
          .add(SearchPersons(query, isNewQuery: true));
    }

    return BlocBuilder<PersonSearchBloc, PersonSearchState>(
      builder: (context, state) {
        if (state is PersonSearchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PersonSearchLoaded) {
          final persons = state.persons;
          if (persons.isEmpty) {
            return _showErrorText('No Characters with that name found');
          }
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                if (query.isEmpty) {
                  BlocProvider.of<PersonSearchBloc>(context, listen: false)
                      .add(SearchAllPersons(isPaging: true));
                } else {
                  BlocProvider.of<PersonSearchBloc>(context, listen: false)
                      .add(SearchPersons(query, isPaging: true));
                }
              }
              return false;
            },
            child: ListView.builder(
              itemCount: persons.length + 1,
              itemBuilder: (context, int index) {
                if (index == persons.length) {
                  return state is PersonSearchLoadingMore
                      ? Center(child: CircularProgressIndicator())
                      : Container();
                }
                PersonEntity result = persons[index];
                return SearchResult(personResult: result);
              },
            ),
          );
        } else if (state is PersonSearchError) {
          return _showErrorText(state.message);
        } else {
          return const Center(
            child: Icon(Icons.now_wallpaper),
          );
        }
      },
    );
  }

  Widget _showErrorText(String errorMessage) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Text(
          errorMessage,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      return Container();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) {
        return Text(
          _suggestions[index],
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: _suggestions.length,
    );
  }
}
