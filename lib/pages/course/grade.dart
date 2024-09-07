import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GradePage extends StatefulWidget {
  const GradePage({super.key});

  @override
  State<GradePage> createState() => _GradePageState();
}

Future<List<Map<String, dynamic>>> _readJsonFromFile(String filePath) async {
  try {
    final file = File(filePath);
    //final jsonString = await file.readAsString();
    String jsonString = await rootBundle.loadString('assets/grade.json');
    final jsonData = jsonDecode(jsonString);
    final courses = (jsonData['data'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .toList();
    return courses;
  } catch (e) {
    print('Error reading JSON file: $e');
    rethrow;
  }
}

class _GradePageState extends State<GradePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _readJsonFromFile("assets/grade.json"),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text('课程成绩'),
            ),
            body: snapshot.connectionState == ConnectionState.done
                ? Container(
                    padding: EdgeInsets.all(16.0),
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color:
                            Theme.of(context).colorScheme.secondaryContainer),
                    child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final grade = snapshot.data![index];
                          final themeData = Theme.of(context);
                          return Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(grade['courseNum']),
                                    Text(grade['courseType'],
                                        style: themeData.textTheme.titleSmall),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(ommitText(grade['courseName'], 11),
                                        style: themeData.textTheme.titleMedium),
                                    Container(
                                      width: 48,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                      
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        color: themeData
                                            .colorScheme.primaryContainer,
                                      ),
                                      child: Text(grade['courseGrade'],
                                      style: TextStyle(
                                        color: Colors.grey
                                      ),),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
                  )
                : CircularProgressIndicator(),
          );
        });
  }

  String ommitText(String text, int maxLength) {
    return text.length > maxLength
        ? text.substring(0, maxLength-3) + '...'
        : text;
  }
}
