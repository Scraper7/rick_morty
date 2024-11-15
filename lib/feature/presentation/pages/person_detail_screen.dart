import 'package:flutter/material.dart';
import 'package:flutter_rick_and_morty_app/common/app_colors.dart';
import 'package:flutter_rick_and_morty_app/feature/domain/entities/person_entity.dart';
import 'package:flutter_rick_and_morty_app/feature/presentation/widgets/person_cache_image_widget.dart';

class PersonDetailPage extends StatelessWidget {
  final PersonEntity person;

  const PersonDetailPage({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Character'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Text(
              person.name!,
              style: TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              child: PersonCacheImage(
                imageUrl: person.image!,
                width: 260,
                height: 260,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                      color:
                          person.status == 'Alive' ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(8)),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  person.status!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            if (person.type!.isNotEmpty) ...buildText('Type:', person.type!),
            ...buildText('Gender:', person.gender!),
            ...buildText(
                'Number of episodes:', person.episode!.length.toString()),
            ...buildText('Species:', person.species!),
            ...buildText('Last knows location:', person.location!.name),
            ...buildText('Origin:', person.origin!.name),
            ...buildText('Was created:', person.created.toString()),
          ],
        ),
      ),
    );
  }

  List<Widget> buildText(String text, String value) {
    return [
      Text(
        text,
        style: TextStyle(
          color: AppColors.greyColor,
        ),
      ),
      SizedBox(
        height: 4,
      ),
      Text(
        value,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      SizedBox(
        height: 16,
      ),
    ];
  }
}
