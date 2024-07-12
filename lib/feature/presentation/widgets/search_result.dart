import 'package:flutter/material.dart';
import 'package:flutter_rick_and_morty_app/common/app_colors.dart';
import 'package:flutter_rick_and_morty_app/feature/domain/entities/person_entity.dart';
import 'package:flutter_rick_and_morty_app/feature/presentation/pages/person_detail_screen.dart';
import 'package:flutter_rick_and_morty_app/feature/presentation/widgets/person_cache_image_widget.dart';

class SearchResult extends StatelessWidget {
  final PersonEntity personResult;

  SearchResult({required this.personResult});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PersonDetailPage(person: personResult),
            ));
      },
      child: Card(
        color: AppColors.cellBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Container(
                child: PersonCacheImage(
                  imageUrl: personResult.image!,
                  width: 0,
                  height: 0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                personResult.name!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                personResult.location!.name,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
