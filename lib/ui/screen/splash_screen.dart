//

import 'package:adverts247Pass/services/update_app.dart';
import 'package:adverts247Pass/services/video_service.dart';
import 'package:adverts247Pass/themes.dart';
import 'package:adverts247Pass/services/websocket.dart';
import 'package:adverts247Pass/ui/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adverts247Pass/tools.dart' as tools;
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VideoPlayerController? _controller;

  void initIntroVideo() {
    _controller = VideoPlayerController.asset("assets/video/Intro_app.mp4")
      ..initialize().then((_) async {
        _controller!.play();
        setState(() {});
        // Wait for video duration before moving to next page
        await Future.delayed(Duration(
            milliseconds:
                (_controller!.value.duration.inMilliseconds).toInt()));
        moveToNextPage();
      });
  }

  @override
  void initState() {
    super.initState();
    initIntroVideo();
    OtaService().checkifUpdateIsNeeded(context);
    // AppWebsocketService().determinePosition();
    // Future.delayed(Duration(seconds: 9));
    // moveToNextPage();
  }

  Future<void> moveToNextPage() async {
    var data = await tools.getFromStore('accessToken');
    if (data == null) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.push(
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

      VideoService().login(context, body);
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
