import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import 'package:flutter/widgets.dart';
class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.only(bottom: 16), child: Icon(Icons.book)),
          Text("无数据")
        ],
      ),
    );
  }
}

// 显示胶囊式 SnackBar
void ShowSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      margin: EdgeInsets.only(bottom: 32, left: 64, right: 64),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      duration: Duration(seconds: 1),
    ),
  );
}

Future<Uint8List> _loadImageFromUrl(String imageUrl) async {
  final dio = Dio();
    var response = await dio.get(imageUrl,
        options: Options(headers: {
          'User-Agent': 'PostmanRuntime/7.37.0',
        }, responseType: ResponseType.bytes));
    return response.data;
  }
// class RadiusNetWorkImage extends StatelessWidget {
//   final String imgUrl;
//   final double radius;

//   const RadiusNetWorkImage({
//     Key? key,
//     required this.imgUrl,
//     required this.radius,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(radius),
//       child: FutureBuilder<Uint8List>(
//         future: _loadImageFromUrl(imgUrl),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
            
//             return Image(
//               image: MemoryImage(snapshot.data),
//               fit: BoxFit.cover,
//             );
//           } else if (snapshot.hasError) {
//             return const Icon(Icons.error, color: Colors.red);
//           } else {
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }

// }

/**
 * 圆角图片
 * 
 */
class RadiusImage extends StatelessWidget {
  final String? imgUrl;
  final double? radius;

  const RadiusImage({super.key, this.imgUrl, this.radius});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 16.0),
      child: Image.network(
        imgUrl!,
        fit: BoxFit.cover,
      ),
    );
  }
}