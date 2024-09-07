import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/json/hot_movie_bean.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:video_player/video_player.dart';

class VideoPlay extends StatelessWidget {
  final Subjects movie;
  const VideoPlay({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return VideoPlayerScreen(movie: movie);
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final Subjects movie;
  const VideoPlayerScreen({super.key, required this.movie});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState(movie: movie);
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  final Subjects movie;
  late String t;
  _VideoPlayerScreenState({required this.movie});
  @override
  void initState() {
    super.initState();
    t = movie.title??"北海";
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://v26-web.douyinvod.com/ff413cddaa9c56269f53df0f5d56889d/6652180c/video/tos/cn/tos-cn-ve-15/oMCaAGfnJXin7BAFgMQMKw8gRefQAjMXBEczI7/?a=6383&ch=0&cr=0&dr=0&er=0&cd=0%7C0%7C0%7C0&cv=1&br=550&bt=550&cs=0&ds=6&ft=rVWEerwwZRdfsCPo7PDS6kFgAX1tGNPqAf9eFCPhGLr12nzXT&mime_type=video_mp4&qs=12&rc=ZTw5Zzw7aWUzZDM2Z2Q3aUBpMzo5cHM5cngzczMzNGkzM0AzLi9eYy00NjExNTRhY2AwYSNwL2tfMmRjNTRgLS1kLS9zcw%3D%3D&btag=80000e00038000&cquery=100b&dy_q=1716651201&feature_id=46a7bb47b4fd1280f3d3825bf2b29388&l=202405252333210CD37BB8E02A72D13CC1',
      ),
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(t),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.
              child: VideoPlayer(_controller),
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
          setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // If the video is paused, play it.
              _controller.play();
            }
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}