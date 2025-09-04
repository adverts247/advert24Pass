import 'dart:io';

import 'package:adverts247Pass/pre-streaming-screen/profile_display/profile_image_display.dart';
import 'package:adverts247Pass/pre-streaming-screen/welcome_onbaording/welcome_onbaording_viewmodel.dart';
import 'package:adverts247Pass/themes.dart';
import 'package:adverts247Pass/services/websocket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class PreStreamingWelcomePage extends StatefulWidget {
  const PreStreamingWelcomePage({super.key});

  @override
  State<PreStreamingWelcomePage> createState() =>
      _PreStreamingWelcomePageState();
}

class _PreStreamingWelcomePageState extends State<PreStreamingWelcomePage> {
  VideoPlayerController? _controller;

  void initIntroVideo() {
    _controller = VideoPlayerController.asset("assets/video/Intro_app.mp4")
      ..initialize().then((_) {
        _controller!.play();
        setState(() {});
      });
  }

  @override
  void initState() {
    super.initState();
    initIntroVideo();
    AppWebsocketService().determinePosition();

    Future.delayed(Duration(seconds: 9), () {
      print("Video player done");
    return;
      Get.to(
        ProfileImage(),
        transition: Transition.fadeIn,
        curve: Curves.easeIn,
        duration: Duration(seconds: 1),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => WelcomeOnboarding(),
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SizedBox(
                height: screenSize.height,
                width: screenSize.width,
                child: VideoPlayer(_controller!)),
          );
        });
  }
}
