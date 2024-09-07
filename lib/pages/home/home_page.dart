import 'package:flutter_application_1/base/base_page.dart';
import 'package:flutter_application_1/generated/json/article_bean.dart';
import 'package:flutter_application_1/generated/json/banner_bean.dart';
import 'package:flutter_application_1/http/api.dart';
import 'package:flutter_application_1/model/theme.dart';
import 'package:flutter_application_1/pages/article_detail_page.dart';
import 'package:flutter_application_1/pages/movie/hot_movie_page.dart';
import 'package:easy_refresh/easy_refresh.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => __BannerPageState();
}

class __BannerPageState extends State<HomePage> {
  final _easyRefreshController = EasyRefreshController();
  bool _noMoreData = false;
  BannerBean? _banners;
  ArticleBean? _articles;
  int curpage = 1;
  final EasyRefreshController _refreshController = EasyRefreshController(
      controlFinishRefresh: true, controlFinishLoad: true);
  @override
  void initState() {
    _fetchBannerData();
    _fetchArticleData(curpage);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildHome(),
    );
  }

  NavigationDrawer buildNavigationDrawer(BuildContext context) {
    final ThemeData = Theme.of(context);
    return NavigationDrawer(
      children: <Widget>[
        UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0)),
                color: ThemeData.colorScheme.primary),
            accountName:
                Text("JIUR", style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text("2041357138@qq.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  "http://q.qlogo.cn/headimg_dl?dst_uin=2041357138&spec=640&img_type=jpg"),
            )),
        ListTile(
          leading: Icon(Icons.share, color: ThemeData.primaryColor),
          title: Text("分享应用"),
          onTap: (){
          ShowSnackBar(context, "关于我们");
            // Provider.of<ThemeNotifier>(context,listen: false).toggleTheme();
            debugPrint("切换主题");
          },
        ),
        ListTile(
          leading: Icon(Icons.contrast_outlined, color: ThemeData.primaryColor),
          title: Text("切换主题"),
          onTap: (){
          ShowSnackBar(context, "关于我们");
            // Provider.of<ThemeNotifier>(context,listen: false).toggleTheme();
            debugPrint("切换主题");
          },
        ),
        ListTile(
          leading:
              Icon(Icons.movie_filter_outlined, color: ThemeData.primaryColor),
          title: Text("影视推荐"),
          onTap: () => {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return HotMoviePage();
            }))
          },
        ),
        ListTile(
          leading: Icon(Icons.update, color: ThemeData.primaryColor),
          title: Text("检查更新"),
        ),
        ListTile(
          leading: Icon(Icons.settings, color: ThemeData.primaryColor),
          title: Text("关于我们"),
          onTap: () {
            
            //ShowSnackBar(context, "关于我们");
            debugPrint("切换主题");
          },
        ),
      ],
    );
  }

  RenderObjectWidget buildHome() {
    return _articles != null
        ? Column(
            children: [
              SizedBox(height: 220, child: buildBanner2()),
              Expanded(
                  child: Stack(
                children: [
                  EasyRefresh(
                    controller: _easyRefreshController,
                    header: ClassicHeader(),
                    footer: ClassicFooter(),
                    onRefresh: () async {
                      curpage = 1;
                      // 执行刷新操作
                      await _fetchArticleData(curpage);
                      _easyRefreshController.finishRefresh();
                    },
                    onLoad: () async {
                      // 执行加载更多操作
                      await _loadMoreArticleData();
                      _easyRefreshController.finishLoad();
                    },
                    child: buildArticleListView(),
                  ),
                ],
              ))
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }

  ListView buildArticleListView() {
    return ListView.builder(
      itemCount: _articles!.data?.datas?.length,
      itemBuilder: (context, index) {
        final article = _articles!.data?.datas?[index];
        return Container(
            margin:
                EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(3, 5),
                      blurRadius: 7.0,
                      spreadRadius: 7.0,
                      color: Colors.grey.withOpacity(0.5))
                ]),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          article!.author != ""
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    //Colors.grey[200]
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(article.author ?? "匿名",
                                      style:
                                          const TextStyle(color: Colors.white)))
                              : SizedBox(height: 16.0),
                          Text(article.niceShareDate!),
                        ]),
                    SizedBox(height: 8.0),
                    Text(
                      article.title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      article.superChapterName!,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                Positioned.fill(
                    child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      splashColor: Colors.white.withOpacity(0.3),
                      highlightColor: Colors.white.withOpacity(0.1),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ArticleDetailPage(
                                article.link!, article.title!)));
                      }),
                )),
              ],
            ));
      },
    );
  }

  CarouselSlider buildBanner2() {
    return CarouselSlider(
        items: _banners!.data!.map((url) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  image: DecorationImage(
                    image: NetworkImage(url.imagePath!),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        }).toList(),
        options: CarouselOptions());
  }

  PageView buildBanner() {
    return PageView.builder(
      controller: PageController(
          initialPage: 1, keepPage: false, viewportFraction: 0.8),
      itemCount: _banners!.data!.length,
      itemBuilder: (context, index) {
        final banner = _banners!.data![index];
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  banner.imagePath!,
                  fit: BoxFit.cover,
                  height: 180,
                  width: 320,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _fetchBannerData() async {
    final response = await http.get(Uri.parse(Api.URL_BANNER));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _banners = BannerBean.fromJson(data);
        debugPrint(_banners.toString());
      });
    } else {
      // 处理错误情况
    }
  }

  Future<void> _fetchArticleData(int page) async {
    final response = await http.get(Uri.parse(Api.URL_ARTICLE + "/$page/json"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _articles = ArticleBean.fromJson(data);
        debugPrint(data.toString());
      });
    } else {
      // 处理错误情况
      debugPrint("Error");
    }
  }

//加载更多
  Future<void> _loadMoreArticleData() async {
    curpage += 1;
    final response = await http.get(
        Uri.parse("https://www.wanandroid.com/article/list/$curpage/json"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        ArticleBean more = ArticleBean.fromJson(data);
        _articles!.data!.datas!.addAll(more.data!.datas!);
      });
    } else {
      // 处理错误情况
      debugPrint("Error");
    }
  }
}
