import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:islamy/app/resources/color_manager.dart';

class GifImageSplashView extends StatelessWidget {
  const GifImageSplashView({super.key, required GifController controller})
      : _controller = controller;

  final GifController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.lightPrimary,
      body: Gif(
        height: double.maxFinite,
        width: double.maxFinite,
        duration: const Duration(seconds: 2),
        image: const AssetImage('assets/images/logoSplash.gif'),
        controller: _controller,
        autostart: Autostart.no,
        onFetchCompleted: () {
          _controller.reset();
          _controller.forward();
        },
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:islamyapp/resources/color_manager.dart';
// import 'package:video_player/video_player.dart';
// class VideoSplashView extends StatefulWidget {
//   const VideoSplashView({super.key});

//   @override
//   State<VideoSplashView> createState() => _VideoSplashViewState();
// }

// class _VideoSplashViewState extends State<VideoSplashView> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.asset("assets/images/logoSplash.mp4");
//     _initializeVideoPlayerFuture = _controller.initialize().then((_) {
//       // خلي الفيديو يشتغل تلقائي
//       _controller.play();
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorManager.lightPrimary,
//       body: FutureBuilder(
//         future: _initializeVideoPlayerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return SizedBox.expand(
//               child: FittedBox(
//                 fit: BoxFit.cover,
//                 child: SizedBox(
//                   width: _controller.value.size.width,
//                   height: _controller.value.size.height,
//                   child: VideoPlayer(_controller),
//                 ),
//               ),
//             );
//           } else {
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }
