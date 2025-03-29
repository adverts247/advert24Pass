import 'dart:async';

import 'package:adverts247Pass/pre-streaming-screen/game/classic_trivia_game.dart';
import 'package:adverts247Pass/pre-streaming-screen/game/picture_trivia_game.dart';
import 'package:adverts247Pass/services/helpers.dart';
import 'package:adverts247Pass/services/image_assets.dart';
import 'package:adverts247Pass/services/video_service.dart';
import 'package:adverts247Pass/state/location_weather_state.dart';
import 'package:adverts247Pass/state/user_state.dart';
import 'package:adverts247Pass/themes.dart';
import 'package:adverts247Pass/ui/screen/waiting_Page.dart';
import 'package:adverts247Pass/widget/animated_widget_wrapper.dart';
import 'package:adverts247Pass/widget/image_carousel.dart';
import 'package:adverts247Pass/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class GameDashboard extends StatefulWidget {
  const GameDashboard({super.key});

  @override
  State<GameDashboard> createState() => _GameDashboardState();
}

class _GameDashboardState extends State<GameDashboard> {
  bool? isLoading = true;
  // Color borderColor = Themes().blue;

  Map<String, dynamic>? walletDetail;

  var weatherApiResult;
  Timer? _timer;
  Timer? _routeTimer;
  Timer? _entTimer;
  Timer? _sportTimer;
  // Timer? _entTimer;
  var showWeather = true;
  var showEntertainmentView = false;
  bool isFirstColor = true;

  VideoPlayerController? _controller;

  int _totalTimeLeft = 50;

  @override
  // take out logging
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        // showWeather = !showWeather;
        // Simply toggle between true and false
        isFirstColor = !isFirstColor;
      });
    });

    setState(() {
      _routeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_totalTimeLeft > 0) {
          _totalTimeLeft--;
        } else {
          Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const PictureTrivia(),
              ));
        }
      });
    });

    return;

    Future.delayed(const Duration(seconds: 8), () {
      Get.to(
        WaitingPage(),
        transition: Transition.fadeIn,
        curve: Curves.easeIn,
        duration: const Duration(seconds: 1),
      );
    });
  }

  void dispose() {
    _timer?.cancel();
    _entTimer?.cancel();
    _sportTimer?.cancel();
    _routeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: AnimatedContainer(
          duration: Duration(milliseconds: 700),
          child:
              //  isLoading!
              //     ? Container(
              //         color: Colors.black,
              //         child: const Center(
              //           child: CircularProgressIndicator(),
              //         ),
              //       )
              //     :

              Stack(
            children: [
              // if ready show entertainment view
              // EntertainmentView(controller: _controller),
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 0),
                    decoration: BoxDecoration(color: Colors.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.only(top: 15, right: 20, left: 30),
                          height: MediaQuery.of(context).size.height / 4,
                          color: Themes().blue,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AnimatedWidgetWrapper(
                                    animationType: AnimationType.slideFromRight,
                                    delay: 500,
                                    child: Text(
                                      'Welcome,',
                                      style: TextStyles()
                                          .whiteTextStyle(
                                              fontWeight: FontWeight.w800)
                                          .copyWith(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      AnimatedWidgetWrapper(
                                        animationType:
                                            AnimationType.slideFromRight,
                                        delay: 700,
                                        child: Text(
                                          'Pick',
                                          style: TextStyles()
                                              .whiteTextStyle(
                                                  fontWeight: FontWeight.w800)
                                              .copyWith(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                      AnimatedWidgetWrapper(
                                        animationType:
                                            AnimationType.slideFromRight,
                                        delay: 800,
                                        child: Text(
                                          ' A Game!',
                                          style: TextStyles()
                                              .whiteTextStyle(
                                                  fontWeight: FontWeight.w800)
                                              .copyWith(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  AnimatedWidgetWrapper(
                                    animationType: AnimationType.fadeIn,
                                    delay: 700,
                                    child: Text(
                                      'Over\n#1,000,000',
                                      textAlign: TextAlign.right,
                                      style: TextStyles()
                                          .whiteTextStyle(
                                              fontWeight: FontWeight.w800)
                                          .copyWith(
                                              height: 1,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  AnimatedWidgetWrapper(
                                    animationType: AnimationType.fadeIn,
                                    delay: 700,
                                    child: Text(
                                      'in prizes won!',
                                      textAlign: TextAlign.right,
                                      style: TextStyles()
                                          .whiteTextStyle(
                                              fontWeight: FontWeight.w800)
                                          .copyWith(
                                              height: 1,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 35.0,
                          ).copyWith(top: 15, bottom: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute<void>(
                                        //       builder: (BuildContext context) =>
                                        //           const PictureTrivia(),
                                        //     ));
                                      },
                                      child: AnimatedWidgetWrapper(
                                        animationType: AnimationType.fadeIn,
                                        delay: 700,
                                        child: Text(
                                          'Free to play!',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              height: 1,
                                              fontSize: 9.sp,
                                              fontWeight: FontWeight.w700,
                                              color: Themes()
                                                  .pink
                                                  .withOpacity(0.7)),
                                        ),
                                      ),
                                    ),
                                    AnimatedWidgetWrapper(
                                      animationType: AnimationType.fadeIn,
                                      delay: 900,
                                      child: Text(
                                        'Auto start in ${formatCountTime(_totalTimeLeft)}secs...',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            height: 1,
                                            fontSize: 9.sp,
                                            fontWeight: FontWeight.w700,
                                            color:
                                                Themes().pink.withOpacity(0.7)),
                                      ),
                                    ),
                                  ]),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  // for (var i = 0; i <= 3; i++)
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) =>
                                                  const PictureTrivia(),
                                            ));
                                      },
                                      child: AnimatedWidgetWrapper(
                                        animationType:
                                            AnimationType.slideFromLeft,
                                        delay: 750,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            right: 10,
                                          ),
                                          height: 360,
                                          width: 400,
                                          // color: Colors.blueAccent,
                                          child: Image.asset(
                                            ImageAssets.pictureTrivia,
                                            // height: 360,
                                            // width: 400,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) =>
                                                        ClassicTrivia()));
                                      },
                                      child: AnimatedWidgetWrapper(
                                        animationType:
                                            AnimationType.slideFromLeft,
                                        delay: 800,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            right: 5,
                                          ),
                                          height: 360,
                                          width: 400,
                                          // color: Colors.blueAccent,
                                          child: Image.asset(
                                            ImageAssets.classicTrivia,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: AnimatedWidgetWrapper(
                                      animationType:
                                          AnimationType.slideFromLeft,
                                      delay: 850,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          right: 5,
                                        ),
                                        height: 360,
                                        width: 400,
                                        // color: Colors.blueAccent,
                                        child: Stack(
                                          children: [
                                            Image.asset(
                                              ImageAssets.comingSoon,
                                              fit: BoxFit.fill,
                                            ),
                                            Container(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: AnimatedWidgetWrapper(
                                      animationType:
                                          AnimationType.slideFromLeft,
                                      delay: 900,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          right: 5,
                                        ),
                                        height: 360,
                                        width: 400,
                                        // color: Colors.blueAccent,
                                        child: Stack(
                                          children: [
                                            Image.asset(
                                              ImageAssets.comingSoon,
                                              fit: BoxFit.fill,
                                            ),
                                            Container(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: AnimatedWidgetWrapper(
                                      animationType:
                                          AnimationType.slideFromLeft,
                                      delay: 950,
                                      child: Container(
                                        height: 360,
                                        width: 400,
                                        // color: Colors.blueAccent,
                                        child: Stack(
                                          children: [
                                            Image.asset(
                                              ImageAssets.comingSoon,
                                              fit: BoxFit.fill,
                                            ),
                                            Container(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        )
                      ],
                    ),
                  ),
                ],
              ),

              // bottom nav-bar widget
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Themes().pink,
                    // border: Border.all(color: Colors.white),
                    // borderRadius: BorderRadius.circular(20)
                  ),
                  //  height: 85,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0).copyWith(right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  ImageAssets.appLogo,
                                  height: 40,
                                  width: 200,
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Text('Map',
                                      style: GoogleFonts.manrope(
                                        color: Themes().whiteColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 6.sp,
                                      )),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Text('Weather',
                                      style: GoogleFonts.manrope(
                                        color: Themes().whiteColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 6.sp,
                                      )),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Text('Driver',
                                      style: GoogleFonts.manrope(
                                        color: Themes().whiteColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 6.sp,
                                      )),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      // showVolumeSlider = !showVolumeSlider!;
                                    });
                                  },
                                  icon: Image.asset(
                                    ImageAssets.brightness1,
                                    color: Colors.white,
                                    height: 30,
                                  ),
                                ),
                                // SizedBox(
                                //   width: 30,
                                // ),
                                // InkWell(
                                //   onTap: () {
                                //     // _toggleMute();
                                //     // print(_isMuted);
                                //   },
                                //   child: Column(
                                //     children: [
                                //       Icon(Icons.volume_off,
                                //           color: Colors.white),
                                //       Text(
                                //         //'ugyg',
                                //         'Mute',
                                //         style: TextStyles()
                                //             .whiteTextStyle()
                                //             .copyWith(fontSize: 13),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                SizedBox(
                                  width: 5,
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      // showVolumeSlider = !showVolumeSlider!;
                                    });
                                  },
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  icon: Icon(
                                    MdiIcons.volumeHigh,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),

                                IconButton(
                                    onPressed: () {},
                                    icon: Image.asset(
                                        height: 30,
                                        color: Colors.white,
                                        ImageAssets.powerButton)),
                                SizedBox(
                                  width: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: Text(
                                    formatTime(DateTime.now()),
                                    style: TextStyles()
                                        .whiteTextStyle()
                                        .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                  ),
                                ),
                                // ClipRRect(
                                //   borderRadius: BorderRadius.circular(7000),
                                //   child: Image.network(
                                //     walletDetail == null
                                //         ? ' '
                                //         : 'https://central.adverts247.xyz/${walletDetail!['image']}',
                                //     height: 50,
                                //     width: 50,
                                //     fit: BoxFit.cover,
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatCountTime(int seconds) {
    return '${(seconds % 60).toString().padLeft(2, '0')}';
  }
}

class EntertainmentView extends StatelessWidget {
  const EntertainmentView({
    super.key,
    required VideoPlayerController? controller,
  }) : _controller = controller;

  final VideoPlayerController? _controller;

  @override
  Widget build(BuildContext context) {
    int _totalTimeLeft = 50;
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 0),
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(top: 15, right: 20, left: 30),
                height: MediaQuery.of(context).size.height / 4,
                color: Themes().blue,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedWidgetWrapper(
                          animationType: AnimationType.slideFromRight,
                          delay: 500,
                          child: Text(
                            'Welcome,',
                            style: TextStyles()
                                .whiteTextStyle(fontWeight: FontWeight.w800)
                                .copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w800),
                          ),
                        ),
                        Row(
                          children: [
                            AnimatedWidgetWrapper(
                              animationType: AnimationType.slideFromRight,
                              delay: 700,
                              child: Text(
                                'Pick',
                                style: TextStyles()
                                    .whiteTextStyle(fontWeight: FontWeight.w800)
                                    .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w800),
                              ),
                            ),
                            AnimatedWidgetWrapper(
                              animationType: AnimationType.slideFromRight,
                              delay: 800,
                              child: Text(
                                ' A Game!',
                                style: TextStyles()
                                    .whiteTextStyle(fontWeight: FontWeight.w800)
                                    .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        AnimatedWidgetWrapper(
                          animationType: AnimationType.fadeIn,
                          delay: 700,
                          child: Text(
                            'Over\n#1,000,000',
                            textAlign: TextAlign.right,
                            style: TextStyles()
                                .whiteTextStyle(fontWeight: FontWeight.w800)
                                .copyWith(
                                    height: 1,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w900),
                          ),
                        ),
                        AnimatedWidgetWrapper(
                          animationType: AnimationType.fadeIn,
                          delay: 700,
                          child: Text(
                            'in prizes won!',
                            textAlign: TextAlign.right,
                            style: TextStyles()
                                .whiteTextStyle(fontWeight: FontWeight.w800)
                                .copyWith(
                                    height: 1,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 35.0,
                ).copyWith(top: 15, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute<void>(
                              //       builder: (BuildContext context) =>
                              //           const PictureTrivia(),
                              //     ));
                            },
                            child: AnimatedWidgetWrapper(
                              animationType: AnimationType.fadeIn,
                              delay: 700,
                              child: Text(
                                'Free to play!',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    height: 1,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Themes().pink.withOpacity(0.7)),
                              ),
                            ),
                          ),
                          AnimatedWidgetWrapper(
                            animationType: AnimationType.fadeIn,
                            delay: 900,
                            child: Text(
                              'Auto start in ${formatCountTime(_totalTimeLeft)}...',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  height: 1,
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Themes().pink.withOpacity(0.7)),
                            ),
                          ),
                        ]),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        // for (var i = 0; i <= 3; i++)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        const PictureTrivia(),
                                  ));
                            },
                            child: AnimatedWidgetWrapper(
                              animationType: AnimationType.slideFromLeft,
                              delay: 750,
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: 10,
                                ),
                                height: 360,
                                width: 400,
                                // color: Colors.blueAccent,
                                child: Image.asset(
                                  ImageAssets.pictureTrivia,
                                  // height: 360,
                                  // width: 400,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          ClassicTrivia()));
                            },
                            child: AnimatedWidgetWrapper(
                              animationType: AnimationType.slideFromLeft,
                              delay: 800,
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: 5,
                                ),
                                height: 360,
                                width: 400,
                                // color: Colors.blueAccent,
                                child: Image.asset(
                                  ImageAssets.classicTrivia,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: AnimatedWidgetWrapper(
                            animationType: AnimationType.slideFromLeft,
                            delay: 850,
                            child: Container(
                              margin: EdgeInsets.only(
                                right: 5,
                              ),
                              height: 360,
                              width: 400,
                              // color: Colors.blueAccent,
                              child: Stack(
                                children: [
                                  Image.asset(
                                    ImageAssets.comingSoon,
                                    fit: BoxFit.fill,
                                  ),
                                  Container(
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: AnimatedWidgetWrapper(
                            animationType: AnimationType.slideFromLeft,
                            delay: 900,
                            child: Container(
                              margin: EdgeInsets.only(
                                right: 5,
                              ),
                              height: 360,
                              width: 400,
                              // color: Colors.blueAccent,
                              child: Stack(
                                children: [
                                  Image.asset(
                                    ImageAssets.comingSoon,
                                    fit: BoxFit.fill,
                                  ),
                                  Container(
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: AnimatedWidgetWrapper(
                            animationType: AnimationType.slideFromLeft,
                            delay: 950,
                            child: Container(
                              height: 360,
                              width: 400,
                              // color: Colors.blueAccent,
                              child: Stack(
                                children: [
                                  Image.asset(
                                    ImageAssets.comingSoon,
                                    fit: BoxFit.fill,
                                  ),
                                  Container(
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ],
    );
  }

  String formatCountTime(int seconds) {
    return '${(seconds % 60).toString().padLeft(2, '0')}';
  }
}
