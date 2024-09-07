import 'dart:convert';
import 'package:flutter_application_1/base/base_page.dart';
import 'package:flutter_application_1/constants/message_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/json/hot_movie_bean.dart';
import 'package:flutter_application_1/http/api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_1/video_play.dart';
import 'package:http/http.dart' as http;

class HotMoviePage extends StatefulWidget {
  const HotMoviePage({super.key});

  @override
  State<HotMoviePage> createState() => _HotMoviePageState();
}

class _HotMoviePageState extends State<HotMoviePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchMovie(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Text("热门推荐"),
              ),
              body: CustomScrollView(
                slivers: [SliverSafeArea(sliver: buildMovieGrid(snap))],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  SliverGrid buildMovieGrid(AsyncSnapshot<MovieBean> snap) {
    return SliverGrid(
        delegate: SliverChildBuilderDelegate(
            childCount: snap.data!.subjects?.length, (context, index) {
          final movie = snap.data!.subjects![index];
          return GestureDetector(
  onTap: () {
    // 添加点击事件处理逻辑
    // 例如: 导航到详情页面
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlay(movie: movie),
      ),
    );
  },
  child: Card(
    elevation: 8.0,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: CachedNetworkImage(
              httpHeaders: const {
                'User-Agent': 'PostmanRuntime/7.37.0'
              },
              width: double.infinity,
              height: 800,
              imageUrl: movie.cover!,
              fit: BoxFit.cover,
              placeholder: (context, url) {
                debugPrint(url);
                return const Center(child: CircularProgressIndicator());
              },
              errorWidget: (context, url, error) => const Center(
                child: Icon(Icons.error),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              movie.title!,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    ),
  ),
);
        }),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, 
            crossAxisSpacing: 8.0, 
            mainAxisSpacing: 8.0,
            childAspectRatio: 9/16));
  }

  Future<MovieBean> _fetchMovie() async {
    try {
      final response = await http.get(Uri.parse(Api.URL_MOVIE_HOT));
      if (response.statusCode == 200) {
        final data = json.decode(response.body.toString());
        return MovieBean.fromJson(data);
      } else {
        throw Exception(MessageConstant.LOAD_FAILED);
      }
    } catch (e) {
      // 记录异常信息
      ShowSnackBar(context, MessageConstant.LOAD_FAILED);
      rethrow;
    }
  }
}
