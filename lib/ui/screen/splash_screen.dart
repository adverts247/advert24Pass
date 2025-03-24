//

import 'dart:developer';

import 'package:adverts247Pass/pre-streaming-screen/profile_display/profile_image_display.dart';
import 'package:adverts247Pass/services/update_app.dart';
import 'package:adverts247Pass/services/video_service.dart';
import 'package:adverts247Pass/state/location_weather_state.dart';
import 'package:adverts247Pass/state/login_state.dart';
import 'package:adverts247Pass/themes.dart';
import 'package:adverts247Pass/services/websocket.dart';
import 'package:adverts247Pass/ui/screen/login.dart';
import 'package:adverts247Pass/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adverts247Pass/tools.dart' as tools;
import 'package:provider/provider.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart' as getx;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VideoPlayerController? _controller;

  void initIntroVideo() {
    // try{
    _controller = VideoPlayerController.asset("assets/video/Intro_app.mp4")
      ..initialize().then((_) async {
        setState(() {});
        _controller!.play();

        // Wait for video duration before moving to next page
        await Future.delayed(Duration(
            milliseconds:
                (_controller!.value.duration.inMilliseconds).toInt()));
        // Future.delayed(Duration.zero, () => moveToNextPage());
        moveToNextPage();
      }).catchError((error) {
        Future.delayed(Duration.zero, () => moveToNextPage());
      });
    // }
  }

  @override
  void initState() {
    super.initState();
     OtaService().checkForUpdates();
    initIntroVideo();
   
    // AppWebsocketService().determinePosition();
    // Future.delayed(Duration(seconds: 9));
    // moveToNextPage();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  Future<void> moveToNextPage() async {
    VideoState videoState = Provider.of<VideoState>(context, listen: false);
    WeatherLocationState weatherLocationState =
        Provider.of<WeatherLocationState>(context, listen: false);
    var data = await tools.getFromStore('accessToken');
    if (data == null) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
    } else {
      var storedEmail = await tools.getFromStore('email');
      var storedPassword = await tools.getFromStore('password');

      var body = {
        'email': storedEmail,
        'password': storedPassword

        // 'email': 'tested@test.com',
        // 'password': '12345678'
      };
      final response = await videoState.login(context: context, body: body);
      if (response.error) {
        // log('error========================${response.message}');
        // Navigator.pop(context);
        return;
      }
      final weatherResponse = await weatherLocationState.getWeather();
      if (weatherResponse.error) return;
      getx.Get.offAll(
        // PreStreamingWelcomePage(),
        () => ProfileImage(),
        transition: getx.Transition.fadeIn,
        curve: Curves.easeInOut,
        duration: Duration(seconds: 1),
      );

      // Future.delayed(Duration.zero,()=>VideoService().login(context, body));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
          height: screenSize.height,
          width: screenSize.width,
          child: VideoPlayer(_controller!)
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Container(
          //       width: MediaQuery.of(context).size.width * .4,
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.end,
          //         children: [
          //           Image.asset(ImageAssets.appLogo),
          //           SizedBox(height: 5),
          //           Text(
          //             '...reach your true target',
          //             textAlign: TextAlign.right,
          //             style:
          //                 TextStyles().whiteTextStyle().copyWith(fontSize: 17),
          //           ),
          //         ],
          //       ),
          //     ),
          //     // SizedBox(
          //     //   height: 20,
          //     // ),
          //     // Text(
          //     //   'WELCOME ONBOARD',
          //     //   style: TextStyles().whiteTextStyle().copyWith(fontSize: 20),
          //     // )
          //   ],
          // ),
          ),
    );
  }
}
