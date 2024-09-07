import 'package:flutter/material.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    ColorScheme colorScheme = themeData.colorScheme;
    return ListView(
      children: [
          ListTile(
            leading: Icon(Icons.dataset_linked_outlined,
            color: colorScheme.primary,),
            title: Text("课程表"),
            onTap: () {
              Navigator.of(context).pushNamed("/course/table");
            },
          )
      ],
    );
  }
}