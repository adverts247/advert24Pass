import 'dart:async';

import 'package:adverts247Pass/pre-streaming-screen/game/game_dashboard.dart';
import 'package:adverts247Pass/ui/screen/thank_you_page.dart';
import 'package:adverts247Pass/webview/webview_wdget.dart';
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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart ';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:video_player/video_player.dart';

class EntertainmentPage extends StatefulWidget {
  const EntertainmentPage({super.key});

  @override
  State<EntertainmentPage> createState() => _EntertainmentPageState();
}

class _EntertainmentPageState extends State<EntertainmentPage> {
  bool? isLoading = true;
  // Color borderColor = Themes().blue;

  Map<String, dynamic>? walletDetail;

  var weatherApiResult;
  Timer? _timer;
  Timer? _entTimer;
  Timer? _sportTimer;
  // Timer? _entTimer;
  var showWeather = true;
  var showEntertainmentView = false;
  bool isFirstColor = true;
  bool _isInitialized = false;
  double? _volume = 0.3;
  late BuildContext myContext;
  bool? showVolumeSlider = false;
  double _brightness = 1;
  bool showBrightnessSlider = false;

  VideoPlayerController? _controller;
  VideoPlayerController? _sportVidController;
  VideoPlayerController? _musicVidController;
  VideoPlayerController? _vidController;
  bool _isDisposed = false;

  void playVideo() {
    _controller = VideoPlayerController.asset(
        "assets/video/reward_video_ads_and_scan.mp4")
      ..initialize().then((_) async {
        // Set video to loop
        // _controller!.setLooping(true);
        _controller!.play();
        setState(() {});
        // Wait for video duration before moving to next page
        await Future.delayed(Duration(
            milliseconds:
                (_controller!.value.duration.inMilliseconds).toInt()));
      });
    _sportVidController = VideoPlayerController.asset(
        "assets/video/sport_ad_video_without_text.mp4")
      ..initialize().then((_) async {
        // Set video to loop
        // _sportVidController!.setLooping(true);
        _sportVidController!.play();
      });
    _musicVidController = VideoPlayerController.asset(
        "assets/video/Music_ad_Video_without_text.mp4")
      ..initialize().then((_) async {
        // Set video to loop
        // _sportVidController!.setLooping(true);
        _musicVidController!.play();
      });
    _vidController = VideoPlayerController.asset(
        "assets/video/Music_ad_Video_without_text.mp4")
      ..initialize().then((_) async {
        // Set video to loop
        // _sportVidController!.setLooping(true);
        _vidController!.play();
      });
  }

  Future<void> _initializeVideos() async {
    try {
      // // Initialize main video controller
      // _controller = VideoPlayerController.asset("assets/video/Intro_app.mp4");
      // await _controller!.initialize();

      // // Initialize sports video controller
      // _sportVidController = VideoPlayerController.asset(
      //     "assets/video/sport_ad_video_without_text.mp4");
      // await _sportVidController!.initialize();

      // // Initialize sports video controller
      // _musicVidController = VideoPlayerController.asset(
      //     "assets/video/Music_ad_Video_without_text.mp4");
      // await _musicVidController!.initialize();

      // // Initialize video video controller
      // _vidController = VideoPlayerController.asset(
      //     "assets/video/video_ad_video_without_text.mp4");
      // await _vidController!.initialize();

      // Initialize all controllers first
      _controller =
          VideoPlayerController.asset("assets/video/reward_ads_scan_video.mp4");
      _sportVidController = VideoPlayerController.asset(
          "assets/video/sport_ad_video_without_text.mp4");
      _musicVidController = VideoPlayerController.asset(
          "assets/video/Music_ad_Video_without_text.mp4");
      _vidController = VideoPlayerController.asset(
          "assets/video/video_ad_video_without_text.mp4");

      // Wait for all initializations to complete
      await Future.wait([
        _controller!.initialize(),
        _sportVidController!.initialize(),
        _musicVidController!.initialize(),
        _vidController!.initialize(),
      ]);

      if (!_isDisposed) {
        // Mark as initialized
        setState(() {
          _isInitialized = true;
        });

        // Start playing both videos
        await Future.wait([
          _controller!.play(),
          _sportVidController!.play(),
          _musicVidController!.play(),
          _vidController!.play(),
        ]);

        if (_sportVidController?.value != null) {
          setState(() {});
        }

        // Optional: Set videos to loop to prevent ending
        _controller!.setLooping(true);
        // _sportVidController!.setLooping(true);
      }
    } catch (e) {
      print("Error initializing videos: $e");
      if (!_isDisposed) {
        setState(() {
          _isInitialized = false;
        });
      }
    }
  }

  final List<String> imageUrls = [
    ImageAssets.blackHorse1,
    'assets/images/play_games_text1.png',
    'assets/images/video_ad_video_text.png',
    'assets/images/sport_ad_video_text.png',
    'assets/images/music_ad_video_text.png',
    'assets/images/coming_soon.png',
    'assets/images/classic_triva.png',
    'assets/images/picture_triva.png',
    'assets/images/head_icon.png',
  ];

  Future<void> setBrightness() async {
    ScreenBrightness().setScreenBrightness(_brightness);
  }

  @override
  // take out logging
  void initState() {
    getWalletBalance();
    setBrightness();
    // playVideo();
    // _initializeVideos();

    super.initState();
    // playVideo();

    _timer = Timer.periodic(const Duration(seconds: 8), (timer) {
      // playVideo();
      // setState(() {
      //   // showWeather = !showWeather;
      //   // Simply toggle between true and false
      //   isFirstColor = !isFirstColor;
      // });
    });

    // showWeatherView();
    // showEntView();

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

  void showWeatherView() {
    Future.delayed(Duration(seconds: 5));
    setState(() {
      showWeather = !showWeather;
    });
  }

  void showEntView() {
    _entTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      setState(() {
        showEntertainmentView = showEntertainmentView;
      });
    });
    // Future.delayed(Duration(seconds: 8));
    // setState(() {
    //   showEntertainmentView = true;
    // });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _entTimer?.cancel();
    _sportTimer?.cancel();
    _controller?.dispose();
    _sportVidController?.dispose();
    _musicVidController?.dispose();
    _vidController?.dispose();
    super.dispose();
  }

  getWalletBalance() async {
    //  VideoService().getWallet(context);

    setState(() {
      isLoading = true;
    });
    walletDetail =
        await Provider.of<UserState>(context, listen: false).userDetails;
    print(walletDetail);

    // get g from state
    weatherApiResult =
        await Provider.of<WeatherLocationState>(context, listen: false)
            .weatherApiResult;
    print(weatherApiResult);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    for (var url in imageUrls) {
      precacheImage(
        AssetImage(url),
        context,
        onError: (error, stackTrace) {
          if (kDebugMode) {
            print('Image failed to load: $error');
          }
          // Handle the error, e.g., display a placeholder image
        },
      );
    }
    return SafeArea(
      child: Scaffold(
        body: AnimatedContainer(
          duration: Duration(milliseconds: 700),
          child: isLoading!
              ? Container(
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Stack(
                  children: [
                    // if ready show entertainment view
                    // EntertainmentView(controller: _controller),
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 0),
                          decoration: BoxDecoration(color: Colors.white),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    top: 15, right: 10, left: 30),
                                height: MediaQuery.of(context).size.height / 7,
                                color: Themes().blue,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Choose your entertainment during rides',
                                      style: TextStyles()
                                          .whiteTextStyle(
                                              fontWeight: FontWeight.w800)
                                          .copyWith(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w800),
                                    ),
                                    SizedBox(
                                        height: 75, child: ImageCarousel()),
                                  ],
                                ),
                              ),
                              // _sportVidController?.value == null
                              //     ? CircularProgressIndicator(
                              //         color: Colors.red,
                              //       )
                              //     :
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                ).copyWith(top: 15, bottom: 0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                        // margin: EdgeInsets.only(top: 12),
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.25,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        // color: Colors.redAccent,
                                        // child: VideoPlayer(_controller!),
                                        child: Image.asset("assets/images/ads_then_qr_code1.gif")),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          // for (var i = 0; i <= 3; i++)
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute<void>(
                                                      builder: (BuildContext
                                                              context) =>
                                                          WebviewPage(),
                                                    ));
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  right: 5,
                                                ),
                                                height: 370,
                                                width: 400,
                                                // color: Colors.blueAccent,
                                                child: Stack(
                                                  children: [
                                                    SizedBox(
                                                      // margin: EdgeInsets.only(top: 12),
                                                      // height:
                                                      //     MediaQuery.of(context)
                                                      //             .size
                                                      //             .height *
                                                      //         0.25,
                                                      height: 370,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      // color: Colors.redAccent,
                                                      // child: VideoPlayer(_controller!),
                                                      child: Image.asset(
                                                        ImageAssets
                                                            .sportUpdateGif,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      right: 5,
                                                      top: 3,
                                                      child: Image.asset(
                                                          height: 60,
                                                          width: 80,
                                                          ImageAssets
                                                              .sportAdText),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute<void>(
                                                      builder: (BuildContext
                                                              context) =>
                                                          const GameDashboard(),
                                                    ));
                                              },
                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                    right: 5,
                                                  ),
                                                  height: 370,
                                                  width: 400,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blueAccent,
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                        ImageAssets
                                                            .classicTrivia,
                                                      ),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      // Image.asset(
                                                      //   ImageAssets
                                                      //       .classicTrivia,
                                                      //   fit: BoxFit
                                                      //       .fitWidth,
                                                      // ),
                                                      Container(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                      ),
                                                      Positioned(
                                                        right: 5,
                                                        top: 16,
                                                        child: Image.asset(
                                                            height: 40,
                                                            width: 80,
                                                            // ImageAssets
                                                            //     .playGamesText),
                                                            "assets/images/play_games_text1.png"),
                                                        // child: Column(
                                                        //   children: [
                                                        //     Text(
                                                        //       'Play',
                                                        //       style: GoogleFonts
                                                        //           .manrope(
                                                        //         fontSize:
                                                        //             15.sp,
                                                        //         fontWeight:
                                                        //             FontWeight
                                                        //                 .w700,
                                                        //         color: Colors
                                                        //             .white,
                                                        //       ),
                                                        //     ),
                                                        //     Text(
                                                        //       'games',
                                                        //       style: GoogleFonts
                                                        //           .manrope(
                                                        //         fontSize:
                                                        //             8.sp,
                                                        //         fontWeight:
                                                        //             FontWeight
                                                        //                 .w600,
                                                        //         wordSpacing:
                                                        //             0.6,
                                                        //         color: Colors
                                                        //             .white,
                                                        //       ),
                                                        //     ),
                                                        //   ],
                                                        // ),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                  right: 5,
                                                ),
                                                height: 370,
                                                width: 400,
                                                color: Colors.blueAccent,
                                                child: Stack(
                                                  children: [
                                                    SizedBox(
                                                      height: 370,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Image.asset(
                                                        "assets/images/Listen_Music_.gif",
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      right: 5,
                                                      top: 0,
                                                      child: Image.asset(
                                                          height: 60,
                                                          width: 80,
                                                          ImageAssets
                                                              .musicAdText),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                          Expanded(
                                            child: Container(
                                                height: 370,
                                                width: 400,
                                                color: Colors.blueAccent,
                                                child: Stack(
                                                  children: [
                                                    SizedBox(
                                                      height: 370,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Image.asset(
                                                        "assets/images/Watch_Videos_GIF.gif",
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      right: 5,
                                                      top: 0,
                                                      child: Image.asset(
                                                          height: 60,
                                                          width: 80,
                                                          ImageAssets
                                                              .vidoeAdText),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),

                    // volume slider  widget
                    showVolumeSlider!
                        ? Positioned(
                            bottom: 80,
                            left: 20,
                            right: 20,
                            child: Column(
                              children: [
                                Text(
                                  " Volume ${_volume! * 100}",
                                  style: TextStyles()
                                      .blackTextStyle700()
                                      .copyWith(
                                          fontSize: 24, color: Colors.red),
                                ),
                                Slider(
                                  value: _volume!,
                                  activeColor: Colors.red,
                                  inactiveColor: Colors.black,
                                  onChanged: (newVolume) {
                                    setState(() {
                                      _volume = newVolume;
                                      _controller!.setVolume(_volume!);
                                    });
                                  },
                                  min: 0.0,
                                  max: 1.0,
                                  divisions: 10,
                                  label: " Volumne ${_volume! * 100}",
                                ),
                              ],
                            ),
                          )
                        : Container(),

                    //Brightness Slider

                    showBrightnessSlider!
                        ? Positioned(
                            bottom: 80,
                            left: 20,
                            right: 20,
                            child: Column(
                              children: [
                                Text(
                                  "Brightness ${_brightness * 100}",
                                  style: TextStyles()
                                      .blackTextStyle700()
                                      .copyWith(
                                          fontSize: 24, color: Colors.red),
                                ),
                                Slider(
                                  value: _brightness,
                                  label: "Brightness ${_brightness * 100}",
                                  onChanged: (value) {
                                    setState(() {
                                      _brightness = value;
                                      setBrightness();
                                    });
                                  },
                                  divisions: 10,
                                  activeColor: Colors.red,
                                  inactiveColor: Colors.black,
                                ),
                              ],
                            ),
                          )
                        : Container(),

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
                          padding:
                              const EdgeInsets.all(5.0).copyWith(right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        ImageAssets.appLogo,
                                        height: 40,
                                        width: 200,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          // Navigator.push(context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) {
                                          //   return ThankYouPage();
                                          // }));
                                        },
                                        icon: Text(
                                          'Map',
                                          style: GoogleFonts.manrope(
                                            color: Themes().whiteColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 6.sp,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: Text(
                                          'Weather',
                                          style: GoogleFonts.manrope(
                                            color: Themes().whiteColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 6.sp,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        icon: Text(
                                          'Driver',
                                          style: GoogleFonts.manrope(
                                            color: Themes().whiteColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 6.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          // setState(() {
                                          //   // showVolumeSlider = !showVolumeSlider!;
                                          // });

                                          setState(() {
                                            showBrightnessSlider =
                                                !showBrightnessSlider;
                                            showVolumeSlider = false!;
                                          });
                                          // showBrightnessSlider = true;
                                        },
                                        icon: Image.asset(
                                          ImageAssets.brightness1,
                                          color: Colors.white,
                                          height: 30,
                                        ),
                                      ),

                                      SizedBox(
                                        width: 5,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            // showVolumeSlider = !showVolumeSlider!;
                                          });
                                        },
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0),
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
                                        padding:
                                            const EdgeInsets.only(bottom: 3),
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
}

// class EntertainmentView extends StatelessWidget {
//   const EntertainmentView({
//     super.key,
//     required VideoPlayerController? controller,
//   }) : _controller = controller;

//   final VideoPlayerController? _controller;
//   final VideoPlayerController? _sportVidController;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           padding: EdgeInsets.only(bottom: 0),
//           decoration: BoxDecoration(color: Colors.white),
//           child: Column(
//             children: [
//               Container(
//                 padding: EdgeInsets.only(top: 15, right: 10, left: 30),
//                 height: MediaQuery.of(context).size.height / 7,
//                 color: Themes().blue,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Choose your entertainment during rides',
//                       style: TextStyles()
//                           .whiteTextStyle(fontWeight: FontWeight.w800)
//                           .copyWith(
//                               fontSize: 13.sp, fontWeight: FontWeight.w800),
//                     ),
//                     SizedBox(height: 75, child: ImageCarousel()),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 35.0,
//                 ).copyWith(top: 15, bottom: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     // SizedBox(
//                     //   height: 20,
//                     // ),
//                     Container(
//                       height: 200,
//                       width: MediaQuery.of(context).size.width,
//                       // color: Colors.redAccent,
//                       child: VideoPlayer(_controller!),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Row(
//                       children: [
//                         // for (var i = 0; i <= 3; i++)
//                         Expanded(
//                           child: InkWell(
//                             onTap: () {
//                               Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute<void>(
//                                     builder: (BuildContext context) =>
//                                         const GameDashboard(),
//                                   ));
//                             },
//                             child: Container(
//                               margin: EdgeInsets.only(
//                                 right: 5,
//                               ),
//                               height: 370,
//                               width: 400,
//                               color: Colors.blueAccent,
//                               child: VideoPlayer(_controller!)
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Container(
//                             margin: EdgeInsets.only(
//                               right: 5,
//                             ),
//                             height: 370,
//                             width: 400,
//                             color: Colors.blueAccent,
//                           ),
//                         ),
//                         Expanded(
//                           child: Container(
//                             height: 370,
//                             width: 400,
//                             color: Colors.blueAccent,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

class AboutCard extends StatelessWidget {
  const AboutCard(
      {super.key,
      required this.screenHeight,
      required this.title,
      required this.answer,
      required this.imagUrl});

  final double screenHeight;
  final String title;
  final String answer;
  final String imagUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.sp,
      width: 300.sp,
      child: Stack(
        children: [
          Image.asset(
            imagUrl,
            // width: 200.sp,
            // height: 100.sp,
          ),
          Positioned(
            top: 45,
            left: 34,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles().whiteTextStyle().copyWith(
                      fontSize: screenHeight < 400 ? 14 : 22,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  answer,
                  style: TextStyles().whiteTextStyle().copyWith(
                      fontSize: screenHeight < 400 ? 15 : 26,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
