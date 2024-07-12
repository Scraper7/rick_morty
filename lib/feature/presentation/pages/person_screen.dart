import 'package:flutter/material.dart';
import 'package:flutter_rick_and_morty_app/feature/presentation/widgets/custom_search_delegate.dart';
import 'package:flutter_rick_and_morty_app/feature/presentation/widgets/persons_list_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Characters'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
            icon: Icon(Icons.search),
            color: Colors.white,
          ),
        ],
      ),
      body: PersonsList(),
    );
  }
}
