import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/layout_constant.dart';
import 'package:flutter_application_1/pages/course/course_table.dart';

import 'package:flutter_application_1/pages/home/home_page.dart';
import 'package:flutter_application_1/pages/more_page.dart';
import 'package:flutter_application_1/pages/user_profile.dart';
import 'package:flutter_application_1/base/base_page.dart';
import 'package:flutter_application_1/pages/movie/hot_movie_page.dart';
import 'package:flutter_application_1/provider/theme_provider.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:provider/provider.dart';
import '../model/article.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainPage> {
  int _currentSelectedIndex = 0;
  bool _isDark = false;
  var widgets = <Widget>[
    const HomePage(),
    const MorePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("云鹤工具箱", style: Theme.of(context).textTheme.titleMedium
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: <Widget>[
          IconButton(
            onPressed: () => {},
            icon: Icon(Icons.search),
            tooltip: "Search",
          )
        ],
      ),
      body: widgets[_currentSelectedIndex],
      drawer: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16.0),
                bottomRight: Radius.circular(16.0)),
            color: Theme.of(context).colorScheme.surfaceContainer),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: buildNavigationDrawer(context)),
      ),
      bottomNavigationBar: NavigationBar(
          onDestinationSelected: (index) {
            setState(() {
              _currentSelectedIndex = index;
            });
          },
          selectedIndex: _currentSelectedIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: "我的",
              selectedIcon: Icon(Icons.home),
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outlined),
              label: "更多",
              selectedIcon: Icon(Icons.person),
            )
          ]),
    );
  }

  NavigationDrawer buildNavigationDrawer(BuildContext context) {
    final ThemeData = Theme.of(context);
    return NavigationDrawer(
      children: <Widget>[
        UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Layout.RADIUS_12,
                    topRight: Layout.RADIUS_12),
                color: ThemeData.colorScheme.primary),
            accountName: const Text("JIUR",
                style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text("2041357138@qq.com"),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage(
                  "http://q.qlogo.cn/headimg_dl?dst_uin=2041357138&spec=640&img_type=jpg"),
            )),
        ListTile(
          leading: Icon(Icons.share,
          color: _isDark?ThemeData.primaryColorDark:ThemeData.primaryColor),
          title: Text("分享应用"),
          onTap: (){
            Navigator.of(context).pushNamed("/course/grade");
          },
        ),
        ListTile(
          leading: Icon(Icons.contrast_outlined,
          color: _isDark?ThemeData.primaryColorDark:ThemeData.primaryColor),
          title: Text("切换主题"),
          onTap: () {
            Navigator.of(context).pushNamed("/select_theme");
          },
        ),
        SwitchListTile(
          value: _isDark,
          onChanged: (value) {
            setState(() {
              _isDark = value;
            });
            Provider.of<ThemeNotifier>(context, listen: false)
                .changeStyle(_isDark ? Brightness.dark:Brightness.light);
          },
          title: const Text("夜间模式"),
          secondary:
              Icon(_isDark?Icons.brightness_4_outlined:Icons.brightness_7_outlined,
              color: _isDark?ThemeData.primaryColorDark:ThemeData.primaryColor),
        ),
        ListTile(
          leading:
              Icon(Icons.movie_filter_outlined, color: _isDark?ThemeData.primaryColorDark:ThemeData.primaryColor),
          title: Text("影视推荐"),
          onTap: () => {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return HotMoviePage();
            }))
          },
        ),
        ListTile(
          leading: Icon(Icons.update, color: _isDark?ThemeData.primaryColorDark:ThemeData.primaryColor),
          title: Text("检查更新"),
        ),
        ListTile(
          leading: Icon(Icons.settings, color: _isDark?ThemeData.primaryColorDark:ThemeData.primaryColor),
          title: Text("关于我们"),
          onTap: () {
            Navigator.of(context).pushNamed("/about");
            //ShowSnackBar(context, "关于我们");
          },
        ),
      ],
    );
  }

  ListView buildListView() {
    return ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: Offset(3, 5),
                  blurRadius: 7.0,
                  spreadRadius: 7.0)
            ], borderRadius: BorderRadius.circular(16.0)),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  article.title ?? "None",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  article.author ?? "None",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8.0),
                RadiusImage(imgUrl: article.imageUrl),
              ],
            ),
          );
        });
  }
}
