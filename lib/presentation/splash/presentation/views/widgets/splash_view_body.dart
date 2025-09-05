import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:islamy/app/resources/color_manager.dart';
import 'package:islamy/presentation/home/view/home_view.dart';
import 'package:islamy/presentation/splash/presentation/views/widgets/gif_image_splash_view.dart';


class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody> with TickerProviderStateMixin {
  late final GifController _controller;
  @override
  void initState() {
    super.initState();
    navigateToHome();
    _controller = GifController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GifImageSplashView(
        controller: _controller,
      ),
      backgroundColor: ColorManager.lightPrimary,
    );
  }

  void navigateToHome() {
    Future.delayed(const Duration(seconds: 3), () {
      // ignore: use_build_context_synchronously
      Navigator.of(
        // ignore: use_build_context_synchronously
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => HomeView()));
    });
  }
}
