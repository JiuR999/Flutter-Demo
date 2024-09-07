import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/json/course_table_bean.dart';
import 'package:flutter_application_1/http/api.dart';
import 'package:flutter_application_1/provider/theme_provider.dart';
import 'package:flutter_application_1/utils/http_utils.dart';
import 'package:http/http.dart' as http;
import 'package:material_color_utilities/palettes/core_palette.dart';
import 'package:provider/provider.dart';

class CourseTablePage extends StatefulWidget {
  const CourseTablePage({super.key});
  @override
  State<CourseTablePage> createState() => _CourseTablePageState();
}

Future<CourseTableBean> _fetchCourseTable(BuildContext context) async {
  final json = await HttpUtils.fetchData(context, Api.URL_COURSE_TABLE);
  return CourseTableBean.fromJson(jsonDecode(json));
}

class _CourseTablePageState extends State<CourseTablePage> {
  final List<Color> colors = [
    Colors.lightGreen,
    Colors.blueGrey,
    Color.fromARGB(255, 133, 83, 224),
    Color.fromARGB(255, 198, 28, 228),
    Colors.blue,
    Colors.teal,
    const Color.fromARGB(255, 219, 106, 144),
    Colors.cyan,
    Colors.lightBlue,
    Colors.purpleAccent,
    Colors.green
  ];
  final List<String> days = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"];
  final List<int> weeks = [14, 15, 16, 17, 18, 19, 20];
  int _currentWeek = 15;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("课程表"),
          actions: [
            IconButton(onPressed: (){
              setState(() {
                _currentWeek--;
              });
            },
            icon: Icon(Icons.arrow_left)),
            Text("${_currentWeek}周"),
            IconButton(onPressed: (){
              setState(() {
                _currentWeek++;
              });
            },
            icon: Icon(Icons.arrow_right)),
            /* ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: Text(
                      "${weeks[index]}周",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              },
              itemCount: weeks.length,
            ), */
          ],
        ),
        body: SafeArea(
            child: FutureBuilder(
                future: _fetchCourseTable(context),
                builder: (context, snap) {
                  return snap.connectionState == ConnectionState.done
                      ? Column(
                          children: [
                            /* Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 60,
                                  height: 60,
                                  child: ),
                            ), */
                            Table(
                              columnWidths: const {
                                0: FixedColumnWidth(40),
                                1: FlexColumnWidth(),
                                2: FlexColumnWidth(),
                                3: FlexColumnWidth(),
                                4: FlexColumnWidth(),
                                5: FlexColumnWidth(),
                                6: FlexColumnWidth(),
                                7: FlexColumnWidth(),
                              },
                              children: [
                                TableRow(
                                  children: [
                                    const Center(
                                      child: SizedBox(child: 
                                      Text("15周")),
                                    ),
                                    for (var day in days)
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(day),
                                        ),
                                      ),
                                  ],
                                ),
                                for (var i = 1; i <= 10; i += 2)
                                  TableRow(
                                    children: [
                                      Center(
                                          child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Container(
                                      
                                          child: Column(
                                            children: [
                                              SizedBox(height: 16),
                                              Text("${i}"),
                                              SizedBox(height: 24),
                                              Text("${i + 1}")
                                            ],
                                          ),
                                        ),
                                      )),
                                      for (var j = 0; j < 7; j++)
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: buildCourseItem(i, j, snap),
                                        ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        )
                      : Center(child: CircularProgressIndicator());
                })));
  }

  Container buildCourseItem(int i, int j, AsyncSnapshot<CourseTableBean> snap) {
    final courses = snap.data!.data!;
    int index = ((i ~/ 2) * 7) + j;
    final item = courses[index];
    final courseName = item.courseName ?? "None";
    final location = item.location ?? "None";
    final seedColor = Provider.of<ThemeNotifier>(context).seedColor;
    final tonalPalettes = CorePalette.contentOf(seedColor.value);
    if (courseName != "None") {
      return Container(
        decoration: BoxDecoration(
            color: getColor(), borderRadius: BorderRadius.circular(8.0)),
        height: 100,
        width: 80,
        child: getText(i, j, snap.data!.data!),
      );
    }
    return Container(
      height: 80,
    );
  }

  Widget getText(int i, int j, List<Data> courses) {
    int index = ((i ~/ 2) * 7) + j;
    final item = courses[index];
    final courseName = item.courseName ?? "None";
    final location = item.location ?? "None";
    return Text(
      "${courseName}\n${location}",
      style: Theme.of(context).textTheme.bodySmall,
      overflow: TextOverflow.fade,
      textAlign: TextAlign.center,
    );
  }

  Color getColor() {
    // Replace this with actual color logic
    final Random random = new Random();
    return colors[random.nextInt(colors.length)];
  }
}
