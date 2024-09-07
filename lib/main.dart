import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/course/course_table.dart';
import 'package:flutter_application_1/pages/course/grade.dart';
import 'package:flutter_application_1/pages/palette/select_theme.dart';
import 'package:flutter_application_1/pages/user_profile.dart';
import 'package:flutter_application_1/provider/theme_provider.dart';
import './pages/MainPage.dart';

import 'package:provider/provider.dart';


void main() {

  runApp(ChangeNotifierProvider(create: (_)=>ThemeNotifier(brightness: Brightness.light),
  child: const MainApp(),));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(builder:(context, value, child) {
      return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: value.themeData,
      
      initialRoute: "/",
      routes: {
        "/":(context)=>const MainPage(),
        "/select_theme":(context)=>const SelectThemePage(),
        "/course/grade":(context)=>const GradePage(),
        "/course/table":(context)=>const CourseTablePage(),
        "/about":(context)=>const UserProfilePage(),
      },
    );
    });
  }
}
