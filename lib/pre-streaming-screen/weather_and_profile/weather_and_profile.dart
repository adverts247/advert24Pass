import 'dart:async';
import 'dart:developer';

import 'package:adverts247Pass/pre-streaming-screen/game/entertainment_page.dart';
import 'package:adverts247Pass/services/helpers.dart';
import 'package:adverts247Pass/services/image_assets.dart';
import 'package:adverts247Pass/services/video_service.dart';
import 'package:adverts247Pass/services/websocket.dart';
import 'package:adverts247Pass/services/wether_service/weather_service.dart';
import 'package:adverts247Pass/state/location_weather_state.dart';
import 'package:adverts247Pass/state/user_state.dart';
import 'package:adverts247Pass/themes.dart';
import 'package:adverts247Pass/ui/screen/rating.dart';
import 'package:adverts247Pass/ui/screen/thank_you_page.dart';
import 'package:adverts247Pass/ui/screen/waiting_Page.dart';
import 'package:adverts247Pass/widget/animated_widget_wrapper.dart';
import 'package:adverts247Pass/widget/image_carousel.dart';
import 'package:adverts247Pass/widget/loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

class ProfileWeatherView extends StatefulWidget {
  ProfileWeatherView({super.key, this.showWeather = true});
  bool showWeather;
  @override
  State<ProfileWeatherView> createState() => _ProfileWeatherViewState();
}

class _ProfileWeatherViewState extends State<ProfileWeatherView> {
  bool? isLoading = true;
  // Color borderColor = Themes().blue;

  Map<String, dynamic>? walletDetail;

  Map<String, dynamic>? weatherApiResult;
  Timer? _timer;
  Timer? _entTimer;
  Timer? _sportTimer;
  // Timer? _entTimer;

  var showEntertainmentView = false;
  bool isFirstColor = true;
  double? _volume = 0.3;
  late BuildContext myContext;
  bool? showVolumeSlider = false;
  double _brightness = 1;
  bool showBrightnessSlider = false;

  VideoPlayerController? _controller;

  Future<void> setBrightness() async {
    ScreenBrightness().setScreenBrightness(_brightness);
  }

  @override
  // take out logging
  void initState() {
    WeatherLocationState weatherLocationState =
        Provider.of<WeatherLocationState>(context, listen: false);
    getWalletBalance();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // WeatherService().getWeatherData(context);
    Future.delayed(Duration.zero, () => weatherLocationState.getWeather());
    // });
    setBrightness();
    super.initState();
    AppWebsocketService().broadcast();

    // _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
    //   setState(() {
    //     // showWeather = !showWeather;
    //     // Simply toggle between true and false
    //     isFirstColor = !isFirstColor;
    //     showWeather = !showWeather;
    //     print("############ ${showWeather.toString()}");
    //   });
    // });

    showWeatherView();
    // showEntView();

    // return;

    // Future.delayed(const Duration(seconds: 20), () {
    //   Get.to(
    //     const EntertainmentPage(),
    //     transition: Transition.fadeIn,
    //     curve: Curves.easeIn,
    //     duration: const Duration(seconds: 1),
    //   );
    // });
  }

  void showWeatherView() {
    Future.delayed(Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          widget.showWeather = !widget.showWeather;
        });
      }
      Future.delayed(Duration(seconds: 20), () => Get.off(()=>EntertainmentPage()));
    });
  }

  void showEntView() {
    _entTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (mounted) {
        setState(() {
          showEntertainmentView = showEntertainmentView;
        });
      }
    });
    // Future.delayed(Duration(seconds: 8));
    // setState(() {
    //   showEntertainmentView = true;
    // });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _entTimer?.cancel();
    _sportTimer?.cancel();
    super.dispose();
  }

  getWalletBalance() async {
    //  VideoService().getWallet(context);
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    walletDetail =
        await Provider.of<UserState>(context, listen: false).userDetails;
    if (kDebugMode) {
      print("Wallet details:: ${walletDetail}");
    }

    // // get weather from state
    // weatherApiResult =
    //     await Provider.of<WeatherLocationState>(context, listen: false)
    //         .weatherApiResult;
    // print("weather:: $weatherApiResult");
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Consumer<WeatherLocationState>(
            builder: (context, weatherState, child) {
          if (weatherState.isLoading) {
            return LoadingWidget();
            // return const Center(child: CircularProgressIndicator());
          }

          if (weatherState.error != null) {
            return Center(child: Text(weatherState.error!));
          }

          weatherApiResult = weatherState.weatherApiResult;
          log("WeatherApi================$weatherApiResult");
          if (weatherApiResult == null) {
            return const Center(child: Text('No weather data available'));
          }
          return AnimatedContainer(
            duration: Duration(milliseconds: 700),
            child:
                // isLoading!
                //     ? Container(
                //         color: Colors.black,
                //         child: const Center(
                //           child: CircularProgressIndicator(),
                //         ),
                //       )
                // :
                Stack(
              children: [
                // if ready show entertainment view

                // showEntertainmentView
                //     ? EntertainmentView(controller: _controller)
                //     :
                widget.showWeather
                    ? Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: MediaQuery.of(context).size.width * .6,
                              height: MediaQuery.of(context).size.height,
                              decoration:
                                  const BoxDecoration(color: Colors.black),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                        vertical: screenHeight < 450 ? 0 : 50)
                                    .copyWith(left: 28),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: isLoading!
                                      ? []
                                      : [
                                          Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: isFirstColor
                                                        ? Themes().blue
                                                        : Themes().pink,
                                                    width: 4,
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7000),
                                                  child: Image.network(
                                                    walletDetail == null
                                                        ? ' '
                                                        : 'https://central.adverts247.xyz/${walletDetail!['image']}',
                                                    height: screenHeight < 450
                                                        ? 110
                                                        : 180,
                                                    width: screenHeight < 450
                                                        ? 110
                                                        : 180,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              // Image.asset(
                                              //   ImageAssets.appLogo,
                                              //   height: screenHeight < 450 ? 80 : 200,
                                              //   width: screenHeight < 450 ? 80 : 200,
                                              // ),
                                              SizedBox(
                                                width: 10.sp,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    //'ugyg',
                                                    'You are riding with',
                                                    style: TextStyles()
                                                        .whiteTextStyle()
                                                        .copyWith(
                                                            fontSize:
                                                                screenHeight <
                                                                        450
                                                                    ? 20
                                                                    : 24),
                                                  ),
                                                  Text(
                                                    //'ugyg',
                                                    '${walletDetail == null ? 'Advert24' : walletDetail!['firstname']}',
                                                    style: TextStyles()
                                                        .whiteTextStyle()
                                                        .copyWith(
                                                            fontSize:
                                                                screenHeight <
                                                                        450
                                                                    ? 22
                                                                    : 24,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SingleChildScrollView(
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  AboutCard(
                                                    screenHeight: screenHeight,
                                                    title: "Favorite Food",
                                                    answer: "Jollof Rice",
                                                    imagUrl:
                                                        ImageAssets.aboutFrame,
                                                  ),
                                                  AboutCard(
                                                    screenHeight: screenHeight,
                                                    title: "Favorite Hobby",
                                                    answer: "Sport",
                                                    imagUrl:
                                                        ImageAssets.aboutFrame2,
                                                  ),
                                                  AboutCard(
                                                    screenHeight: screenHeight,
                                                    title: "Ask Me",
                                                    answer: "Politics",
                                                    imagUrl:
                                                        ImageAssets.aboutFrame3,
                                                  ),
                                                  AboutCard(
                                                    screenHeight: screenHeight,
                                                    title: "Vacation Spot",
                                                    answer: "Paris",
                                                    imagUrl:
                                                        ImageAssets.aboutFrame4,
                                                  ),
                                                ]),
                                          ),
                                          SizedBox(
                                            height: 25,
                                          ),
                                        ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              width: MediaQuery.of(context).size.width * .4,
                              height: MediaQuery.of(context).size.height,
                              padding: EdgeInsets.only(bottom: 45),
                              decoration:
                                  const BoxDecoration(color: Color(0xffE0135E)),
                              child: AnimatedSwitcher(
                                  duration: const Duration(seconds: 4),
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                  child:
                                      // showWeather
                                      //     ?
                                      weatherWidget()),
                            ),
                          ),
                        ],
                      )
                    :
                    // Driver profile  view
                    DriverProfileView(
                        screenHeight: screenHeight, walletDetail: walletDetail),

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
                                  .copyWith(fontSize: 24, color: Colors.red),
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
                                  .copyWith(fontSize: 24, color: Colors.red),
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
                                    onPressed: () {
                                      Get.off(EntertainmentPage());
                                    },
                                    icon: Text(
                                      'Entertainment',
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
                                      setState(() {
                                        widget.showWeather = true;
                                        showEntertainmentView == false;
                                      });
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
                                      setState(() {
                                        showEntertainmentView == true;
                                        widget.showWeather = false;
                                      });
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
                                        showVolumeSlider = !showVolumeSlider!;
                                        showBrightnessSlider = false;
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
          );
        }),
      ),
    );
  }

  aboutMeCard(String firstText, SecondText) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset('assets/images/Group 48095515.svg'),
            const SizedBox(
              width: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firstText,
                  style: TextStyles().whiteTextStyle().copyWith(
                      fontSize: screenHeight < 450 ? 10 : 14,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  walletDetail == null ? 'Loading...' : SecondText ?? "",
                  style: TextStyles().whiteTextStyle().copyWith(
                      fontSize: screenHeight < 400 ? 15 : 24,
                      fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
        SizedBox(
          height: screenHeight < 450 ? 5 : 15,
        ),
        const Divider(
          height: 0.1,
          color: Color(0xffD6DDEB),
        ),
        SizedBox(
          height: screenHeight < 450 ? 5 : 15,
        ),
      ],
    );
  }

  leftAboutMeCard(String firstText, SecondText) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset(
              'assets/images/Group 48095515.svg',
              height: screenHeight < 450 ? 35 : 50,
            ),
            const SizedBox(
              width: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firstText,
                  style: TextStyles().whiteTextStyle().copyWith(
                      fontSize: screenHeight < 450 ? 10 : 14,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  walletDetail == null ? 'Loading...' : SecondText ?? "",
                  style: TextStyles().whiteTextStyle().copyWith(
                      fontSize: screenHeight < 450 ? 14 : 24,
                      fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
        SizedBox(
          height: screenHeight < 450 ? 2 : 15,
        ),
        const Divider(
          height: 0.1,
          color: Color(0xffD6DDEB),
        ),
        SizedBox(
          height: screenHeight < 450 ? 2 : 15,
        ),
      ],
    );
  }

  weatherWidget() {
    var now = DateTime.now();
    var formatter = DateFormat('EEEE, MMMM d, y');
    String formattedDate = formatter.format(now);

    final List<String> images = [
      'assets/images/head_icon.png',
      'assets/images/fishes.png',
      'assets/images/lion.png',
      'assets/images/two_head.png',
      'assets/images/curved_unicorn.png',
      'assets/images/bull.png',
    ];
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(formattedDate,
                    style: TextStyles()
                        .whiteTextStyle()
                        .copyWith(fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Image.asset(
                      ImageAssets.cloud,
                      height: 80,
                      width: 90,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(
                        weatherApiResult == null
                            ? "0°C"
                            : (weatherApiResult!['main']['temp'] - 273.15)
                                    .toStringAsFixed(2) +
                                '°C',
                        style: TextStyles().whiteTextStyle().copyWith(
                            fontSize: 22, fontWeight: FontWeight.w800))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    weatherApiResult == null
                        ? SizedBox()
                        : squareBox(
                            'HIGH/LOW',
                            (weatherApiResult!['main']['temp_max'] - 273)
                                    .toStringAsFixed(1) +
                                '/' +
                                (weatherApiResult!['main']['temp_min'] - 273.1)
                                    .toStringAsFixed(1),
                          ),
                    const SizedBox(
                      width: 20,
                    ),
                    weatherApiResult == null
                        ? SizedBox()
                        : squareBox(
                            'WIND',
                            weatherApiResult!['wind']['speed'].toString() +
                                'm/s')
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    squareBox('RAIN CHANCE', 'Rain Chance'),
                    const SizedBox(
                      width: 20,
                    ),
                    weatherApiResult == null
                        ? SizedBox()
                        : squareBox(
                            'HUMIDITY',
                            weatherApiResult!['main']['humidity'].toString() +
                                '%')
                  ],
                ),
              ],
            ),
          ),
          Positioned(
              top: 30,
              right: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var image in images)
                    Padding(
                      padding: EdgeInsets.only(
                          right:
                              image == 'assets/images/bull.png' ? 0.0 : 10.0),
                      child: Stack(
                        children: [
                          Image.asset(image,
                              height: 60,
                              color: Color(0xFF3F3F3F).withOpacity(0.7)),
                          // Positioned.fill(
                          //   child: Container(
                          //       height: 60,
                          //       color: Colors.black.withOpacity(0.7)),
                          // )
                        ],
                      ),
                    ),
                ],
              ))
        ],
      ),
    );
  }

  squareBox(String topText, bottomText) {
    var height = MediaQuery.of(context).size.height;
    return Container(
        color:
            //Colors.black,
            Colors.white,
        height: height < 500 ? 80 : 130,
        width: height < 500 ? 140 : 180,
        child: Padding(
          padding: EdgeInsets.all(height < 500 ? 10.0 : 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(topText,
                  style: TextStyles()
                      .defaultText(
                          height < 500 ? 10 : 15, FontWeight.w600, Colors.black)
                      .copyWith(
                          fontSize: height < 500 ? 10 : 15,
                          fontWeight: FontWeight.w600)),
              const SizedBox(
                height: 10,
              ),
              Text(bottomText,
                  style: TextStyles()
                      .defaultText(
                          height < 500 ? 15 : 23, FontWeight.w600, Colors.black)
                      .copyWith(
                          fontSize: height < 500 ? 16 : 23,
                          fontWeight: FontWeight.w700))
            ],
          ),
        ));
  }
}

class DriverProfileView extends StatelessWidget {
  const DriverProfileView({
    super.key,
    required this.screenHeight,
    required this.walletDetail,
  });

  final double screenHeight;
  final Map<String, dynamic>? walletDetail;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 0),
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                color: Colors.black,
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width / 1.7,
                    decoration: BoxDecoration(
                        // color: Colors.blueAccent,
                        // image: DecorationImage(
                        //   fit: BoxFit.contain,
                        //   image: AssetImage(
                        //     ImageAssets.blackHorse1,
                        //   ),
                        // ),
                        ),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width.sp,
                        height: MediaQuery.of(context).size.height,
                        child: Stack(
                          children: [
                            Center(
                              child: Transform.scale(
                                // scale: 1.0,
                                scaleY: 1.45,
                                child: Image.asset(
                                  ImageAssets.blackHorse1,
                                  // height: 400,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 30,
                              top: MediaQuery.of(context).size.height / 4.1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "'Have a nice day'",
                                    style:
                                        TextStyles().whiteTextStyle().copyWith(
                                            fontSize: 12.sp,
                                            // color: Colors.black,
                                            fontWeight: FontWeight.w900),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  // ListTile(
                                  //   leading:
                                  Row(
                                    children: [
                                      Image.asset(
                                          height: 24,
                                          width: 24,
                                          color: Colors.white,
                                          ImageAssets.house),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "From Ikeja, Lagos State",
                                        style: TextStyles()
                                            .whiteTextStyle()
                                            .copyWith(
                                                fontSize: 7.sp,
                                                // color: Colors.black,
                                                fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 13,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                          height: 24,
                                          width: 24,
                                          color: Colors.white,
                                          ImageAssets.house),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Speaks english and Yoruba",
                                        style: TextStyles()
                                            .whiteTextStyle()
                                            .copyWith(
                                                fontSize: 7.sp,
                                                // color: Colors.black,
                                                fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Text(
                                      ' Vacation Spot - Paris',
                                      style: TextStyles()
                                          .whiteTextStyle()
                                          .copyWith(
                                              fontSize: 7.sp,
                                              // color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width / 2.5,
                    // color: Colors.black,
                    padding: EdgeInsets.only(left: 40),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Container(
                          //   height: 130,
                          //   width: 300,
                          //   decoration: BoxDecoration(
                          //     // color: Colors.redAccent,
                          //     image: DecorationImage(
                          //       image:
                          AnimatedWidgetWrapper(
                            animationType: AnimationType.slideFromRight,
                            delay: 500,
                            child: AboutCardReversed(
                              screenHeight: screenHeight,
                              title: "Favorite Food",
                              answer: "Jollof Rice",
                              imagUrl: ImageAssets.horseMan,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          AnimatedWidgetWrapper(
                            animationType: AnimationType.slideFromRight,
                            delay: 700,
                            child: AboutCardReversed(
                              screenHeight: screenHeight,
                              title: "Favorite Hobby",
                              answer: "Sport",
                              imagUrl: ImageAssets.unicornHorse,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          AnimatedWidgetWrapper(
                            animationType: AnimationType.slideFromRight,
                            delay: 900,
                            child: AboutCardReversed(
                              screenHeight: screenHeight,
                              title: "Ask Me",
                              answer: "Politics",
                              imagUrl: ImageAssets.horseCurve,
                            ),
                          ),

                          //     ),
                        ]),
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          top: 25,
          left: 40,
          right: 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: Themes().pink,
                        width: 4,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7000),
                      child: Image.network(
                        walletDetail == null
                            ? ' '
                            : 'https://central.adverts247.xyz/${walletDetail!['image']}',
                        height: screenHeight < 450 ? 150 : 220,
                        width: screenHeight < 450 ? 150 : 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'You are riding with',
                        style: TextStyles().whiteTextStyle().copyWith(
                            fontSize: 10.sp, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 0,
                      ),
                      Text(
                        walletDetail?['firstname'] ?? "",
                        style: TextStyles().whiteTextStyle().copyWith(
                            fontSize: 15.sp, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ],
              ),
              ImageCarousel(),
            ],
          ),
        ),
      ],
    );
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
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 0),
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 15, right: 10, left: 30),
                height: MediaQuery.of(context).size.height / 7,
                color: Themes().blue,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Choose your entertainment during rides',
                      style: TextStyles()
                          .whiteTextStyle(fontWeight: FontWeight.w800)
                          .copyWith(
                              fontSize: 13.sp, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 75, child: ImageCarousel()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 35.0,
                ).copyWith(top: 15, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // SizedBox(
                    //   height: 20,
                    // ),
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      // color: Colors.redAccent,
                      child: VideoPlayer(_controller!),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        // for (var i = 0; i <= 3; i++)
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                              right: 5,
                            ),
                            height: 370,
                            width: 400,
                            color: Colors.blueAccent,
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
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 370,
                            width: 400,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class AboutCardReversed extends StatelessWidget {
  const AboutCardReversed(
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
    return Stack(
      children: [
        Image.asset(imagUrl),
        Positioned(
          top: 58,
          left: 104,
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
    );
  }
}

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
