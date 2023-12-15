import 'dart:async';
import 'dart:io';


import 'package:adverts247Pass/model/video_model.dart';

import 'package:adverts247Pass/services/video_service.dart';
import 'package:adverts247Pass/state/user_state.dart';
import 'package:adverts247Pass/themes.dart';
import 'package:adverts247Pass/services/websocket.dart';
import 'package:adverts247Pass/ui/screen/about_me.dart';
import 'package:adverts247Pass/ui/screen/rating.dart';

import 'package:adverts247Pass/widget/button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
//import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:screen_brightness/screen_brightness.dart';

import 'package:wakelock_plus/wakelock_plus.dart';

class VideoPlayerApp extends StatefulWidget {
  const VideoPlayerApp({super.key});

  @override
  _VideoPlayerAppState createState() => _VideoPlayerAppState();
}

class _VideoPlayerAppState extends State<VideoPlayerApp>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller;
  int _currentIndex = 0;
  VideoModel? currentAds;
  List<VideoModel>? videoModelList;
  void data;
  bool? isPhoto = false;
  Future<Uint8List>? futureValue;
  var video;
  bool? isLoading = true;
  double? _volume = 0.3;
  late BuildContext myContext;
  bool? showVolumeSlider = false;
  final double _brightness = 1;
  int chuncksPlayed = 0;
  //VlcPlayerController? vlcController;
  AnimationController? likeController;
  AnimationController? disLikeController;
  bool _isLarge = false;
  var _isdisLikeLarge = false;
  late Timer _timer;
  bool? rating = false;
  bool? userdidntTaptheScreen = false;
  bool? next = false;
  int secondss = 10;
  var walletDetail;
  var _isMuted = false;
  var displayWelcome = true;
  bool? showBrightnessSlider = false;

  @override
  void initState() {
    getVideoList();
    getWalletBalance();
    setBrightness();
    WakelockPlus.toggle(enable: true);

    //send driver location
    Timer.periodic(const Duration(seconds: 1), (timer) {
      AppWebsocketService().checkLocation(context);
    });

    super.initState();
    likeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  //get profile because of profile picture
  getWalletBalance() async {
    setState(() {
      isLoading = true;
    });
    walletDetail =
        await Provider.of<UserState>(context, listen: false).userDetails;
    print(walletDetail);

    // setState(() {
    //   isLoading = false;
    // });
  }

  Future<void> setBrightness() async {
    ScreenBrightness().setScreenBrightness(_brightness);
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller!.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  //listen to exit app

  Future<void> getVideoList() async {
    //final mode = await getKioskMode().then((value) => print('started'));

    //startKioskMode();
    //   getVideourl('3');
    videoModelList = await VideoService().getVideo(context);
    print(videoModelList);
    currentAds = videoModelList![0];
    ifIsVideo();
  }

  List<Widget> actionWidget = [
    //QuestionPage(),
    // BarcodeDisplayWidget(url : currentAds!.callToAction.url),
    // AdsFormPage()
  ];

  //Check if the next ads is a video or photo

  Future<void> ifIsVideo() async {
    setState(() {
      isLoading = true;
      displayWelcome = false;
    });
    print(currentAds!.id);
    print(currentAds!.type.toString());

    if (currentAds!.type.toString() == 'photo') {
      setState(() {
        isPhoto = true;

        futureValue = VideoService()
            .fetchData(currentAds!.content.path.toString(), context);
      });
    } else {
      setState(() {
        isPhoto = false;
      });

      video = await VideoService()
          .fetchVideo(currentAds!.content.path.toString(), context);
      // video = 'assets/images/pexels-media-dung-9716407 (1080p).mp4';
      var size = Provider.of<UserState>(context, listen: false).size;

      if (video.toString().endsWith('mkv')) {
        // vlcController = VlcPlayerController.network(
        //   video,
        //   hwAcc: HwAcc.full,
        //   autoPlay: true,
        //   options: VlcPlayerOptions(),
        // );
      } else {
        _controller = VideoPlayerController.file(File(video))
          ..initialize().then((_) {
            _controller!.play();
            setState(() {});
          });

        _controller!.addListener(() async {
          print(_controller!.value.errorDescription);
          print(_controller!.value.position);

          print(' buffering ${_controller!.value.hasError}');
          if (_controller!.value.isCompleted || _controller!.value.hasError) {
            if (_currentIndex < videoModelList!.length - 1) {
              nextAds();

              _controller!.dispose();
            } else {
              setState(() {
                _currentIndex = -1;
              });
              print('dsdsd $_currentIndex');
              nextAds();
              _controller!.dispose();
            }
          }
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    _timer.cancel();
    super.dispose();
  }

  nextAds() {
    Future.delayed(Duration(seconds: isPhoto! ? 10 : 0), () {
      //   Navigator.pop(context);

      setState(() {
        rating = true;
      });

      // After 5 sec turn rating value to false : This allows the rating wiget to leave the screen

      //  Future.delayed(Duration(seconds: 5), () {
      // setState(() {
      //   rating = false;
      //   //delete video from storage
      //   if (isPhoto!) {
      //   } else {
      //     // tools.deleteFile(video);
      //   }

      //   //
      //   displayWelcome = true;
      // });

      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          rating = false;

          _currentIndex++;

          currentAds = videoModelList![_currentIndex];
        });

        ifIsVideo();
      });
    });
  }

  void test() {
    Navigator.pop(context);

    setState(() {
      rating = true;
    });

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        rating = false;

        setState(() {
          _currentIndex++;

          currentAds = videoModelList![_currentIndex];
        });

        ifIsVideo();
      });
    });
  }

  previousAds() {
    _controller!.dispose();
    setState(() {
      rating = false;

      if (currentAds!.type.toString() == 'video') {
        _controller!.pause();
      }

      setState(() {
        _currentIndex--;

        currentAds = videoModelList![_currentIndex];
      });

      ifIsVideo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          body:
              //  displayWelcome
              //     ? WelcomePage()
              //     :
              rating!
                  ? const RatingPage()
                  : isLoading!
                      ? const AboutMePage()
                      : !isPhoto!
                          ? video.toString().endsWith('mkv')
                              ? const Column(
                                  children: [
                                    // Expanded(
                                    //   child: VlcPlayer(
                                    //     controller: vlcController!,
                                    //     aspectRatio: 16 / 9,
                                    //     placeholder: Center(
                                    //         child: CircularProgressIndicator()),
                                    //   ),
                                    // ),
                                    // Slider(
                                    //   value: vlcController!
                                    //       .value.position.inMilliseconds
                                    //       .toDouble(),
                                    //   min: 0.0,
                                    //   max: vlcController!
                                    //       .value.duration.inMilliseconds
                                    //       .toDouble(),
                                    //   onChanged: (value) {
                                    //     //   vlcController!.value. .setTime(value.toInt());
                                    //   },
                                    // ),
                                    // bottomWidget()
                                  ],
                                )
                              : _controller!.value.isInitialized
                                  ? Column(
                                      children: [
                                        Expanded(
                                          child: Stack(
                                            children: [
                                              InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      showVolumeSlider = false;
                                                      showBrightnessSlider =
                                                          false;
                                                    });
                                                  },
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    child: VideoPlayer(
                                                        _controller!),
                                                  )),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  // volume slider  widget
                                                  showVolumeSlider!
                                                      ? Column(
                                                          children: [
                                                            Text(
                                                              ' Volume ${_volume! * 100}',
                                                              style: TextStyles()
                                                                  .blackTextStyle700()
                                                                  .copyWith(
                                                                      fontSize:
                                                                          24,
                                                                      color: Colors
                                                                          .red),
                                                            ),
                                                            Slider(
                                                              value: _volume!,
                                                              activeColor:
                                                                  Colors.red,
                                                              inactiveColor:
                                                                  Colors.black,
                                                              onChanged:
                                                                  (newVolume) {
                                                                setState(() {
                                                                  _volume =
                                                                      newVolume;
                                                                  _controller!
                                                                      .setVolume(
                                                                          _volume!);
                                                                });
                                                              },
                                                              min: 0.0,
                                                              max: 1.0,
                                                              divisions: 10,
                                                              label:
                                                                  ' Volumne ${_volume! * 100}',
                                                            ),
                                                          ],
                                                        )
                                                      : Container(),

                                                  //Brightness Slider

                                                  //           showBrightnessSlider!
                                                  //               ? Column(
                                                  //                   children: [
                                                  //                     Text(
                                                  //                       "Brightness ${_brightness * 100}",
                                                  //                       style: TextStyles()
                                                  //                           .blackTextStyle700()
                                                  //                           .copyWith(
                                                  //                               fontSize:
                                                  //                                   24,
                                                  //                               color: Colors
                                                  //                                   .red),
                                                  //                     ),
                                                  //                     Slider(
                                                  //                       value:
                                                  //                           _brightness,
                                                  //                       label:
                                                  //                           "Brightness ${_brightness * 100}",
                                                  //                       onChanged:
                                                  //                           (value) {
                                                  //                         setState(() {
                                                  //                           _brightness =
                                                  //                               value;
                                                  //                           setBrightness();
                                                  //                         });
                                                  //                       },
                                                  //                       divisions: 10,
                                                  //                       activeColor:
                                                  //                           Colors.red,
                                                  //                       inactiveColor:
                                                  //                           Colors.black,
                                                  //                     ),
                                                  //                   ],
                                                  //                 )
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.symmetric(
                                                            vertical: 20),
                                                  ),

                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20,
                                                        vertical: 10),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: const Color.fromARGB(
                                                              138, 45, 45, 45),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20.0),
                                                        child: Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  if (_controller!
                                                                      .value
                                                                      .isPlaying) {
                                                                    _controller!
                                                                        .pause();
                                                                  } else {
                                                                    _controller!
                                                                        .play();
                                                                  }
                                                                });
                                                              },
                                                              child: Icon(
                                                                _controller!
                                                                        .value
                                                                        .isPlaying
                                                                    ? Icons
                                                                        .pause
                                                                    : Icons
                                                                        .play_arrow,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  // Text(
                                                                  //   _controller!
                                                                  //       .value.position
                                                                  //       .toString(),
                                                                  //   style: TextStyles()
                                                                  //       .whiteTextStyle()
                                                                  //       .copyWith(
                                                                  //           fontWeight:
                                                                  //               FontWeight
                                                                  //                   .w300,
                                                                  //           fontSize: 13),
                                                                  // ),
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              10),
                                                                      child: VideoProgressIndicator(
                                                                          colors: const VideoProgressColors(
                                                                              playedColor: Colors.white,
                                                                              bufferedColor: Colors.red,
                                                                              backgroundColor: Colors.white30),
                                                                          _controller!,
                                                                          allowScrubbing: true),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    _controller!
                                                                        .value
                                                                        .duration
                                                                        .toString(),
                                                                    style: TextStyles().whiteTextStyle().copyWith(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w300,
                                                                        fontSize:
                                                                            13),
                                                                  ),
                                                                ],
                                                              ),
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
                                        bottomWidget(),
                                        bottomBottomWidget()
                                      ],
                                    )
                                  : const AboutMePage()
                          : FutureBuilder<Uint8List>(
                              future: futureValue,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const AboutMePage();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  final imageBytes = snapshot.data;

                                  if (imageBytes != null) {
                                    Future.delayed(const Duration(seconds: 5), () {
                                      nextAds();
                                    });
                                    return Column(
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Image.memory(
                                              imageBytes,

                                              fit: BoxFit
                                                  .cover, // Adjust this to your needs
                                            ),
                                          ),
                                        ),
                                        bottomWidget(),
                                        bottomBottomWidget()
                                      ],
                                    );
                                  } else {
                                    return const Text('No image data received');
                                  }
                                }
                              },
                            )),
    );
  }

  Container bottomWidget() {
    var height = MediaQuery.of(context).size.height;
    return Container(
      //height: 85,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 40,
                ),
                InkWell(
                  splashColor: Colors.black,
                  hoverColor: Colors.black,
                  highlightColor: Colors.black,
                  enableFeedback: false,
                  onTap: () async {
                    setState(() {
                      _isLarge = !_isLarge;
                      if (_isLarge) {
                        likeController!.forward();

                        Future.delayed(const Duration(milliseconds: 110), () {
                          setState(() {
                            _isLarge = !_isLarge;
                          });
                        });
                      } else {
                        likeController!.reverse();
                      }
                    });

                    var sessionId =
                        Provider.of<UserState>(context, listen: false)
                            .sessionId;
                    var body = {'sessionId': sessionId};
                    VideoService()
                        .likeVideo(context, body, currentAds!.content.path);
                  },
                  child: SizedBox(
                    height: height < 500 ? 30 : 40,
                    width: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 210),
                          child: Icon(
                            MdiIcons.thumbUpOutline,
                            color: Colors.blue,
                            size: _isLarge ? 35.0 : 25.0,
                          ),
                        ),
                        // Container(
                        //   child:_isLarge ? Container():

                        //    Text(
                        //     'Like',
                        //     style: TextStyles()
                        //         .greyTextStyle400()
                        //         .copyWith(fontSize: 16, color: Colors.blue),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                InkWell(
                  splashColor: Colors.black,
                  hoverColor: Colors.black,
                  highlightColor: Colors.black,
                  enableFeedback: false,
                  onTap: () async {
                    setState(() {
                      _isdisLikeLarge = !_isdisLikeLarge;
                      if (_isdisLikeLarge) {
                        likeController!.forward();

                        Future.delayed(const Duration(milliseconds: 110), () {
                          setState(() {
                            _isdisLikeLarge = !_isdisLikeLarge;
                          });
                        });
                      } else {
                        likeController!.reverse();
                      }
                    });

                    var sessionId =
                        Provider.of<UserState>(context, listen: false)
                            .sessionId;
                    var body = {'sessionId': sessionId};
                    VideoService()
                        .disLikeVideo(context, body, currentAds!.content.path);
                  },
                  child: SizedBox(
                    height: height < 500 ? 30 : 40,
                    width: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.thumbDownOutline,
                          color: Colors.red,
                          size: _isdisLikeLarge ? 35.0 : 25.0,
                        ),
                        // Text(
                        //   'DisLike',
                        //   style: TextStyles()
                        //       .greyTextStyle400()
                        //       .copyWith(fontSize: 16, color: Colors.red),
                        // )
                      ],
                    ),
                  ),
                )
              ],
            ),
            // Image.asset(
            //   'assets/images/Group (6).png',
            //   height: 40,
            //   width: 200,
            // ),
            Row(
              children: [
                SizedBox(
                    width: 70,
                    child: SecondaryButton(
                      text: 'Prev',
                      onPressed: () {
                        _controller!.dispose();

                        previousAds();
                      },
                    )),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                    width: 70,
                    child: MyButton(
                      text: 'Next',
                      onPressed: () {
                        _controller!.dispose();

                        nextAds();
                      },
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container bottomBottomWidget() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(20)),
      //  height: 85,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/Group (6).png',
                  height: 40,
                  width: 200,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          showBrightnessSlider = true;
                        });
                        showBrightnessSlider = true;
                      },
                      child: Column(
                        children: [
                          Icon(MdiIcons.brightness4, color: Colors.white),
                          Text(
                            //'ugyg',
                            'Brightness',
                            style: TextStyles()
                                .whiteTextStyle()
                                .copyWith(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    InkWell(
                      onTap: () {
                        _toggleMute();
                        print(_isMuted);
                      },
                      child: Column(
                        children: [
                          const Icon(Icons.volume_off, color: Colors.white),
                          Text(
                            //'ugyg',
                            'Mute',
                            style: TextStyles()
                                .whiteTextStyle()
                                .copyWith(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              showVolumeSlider = !showVolumeSlider!;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              MdiIcons.volumeHigh,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          //'ugyg',
                          'Volume',
                          style: TextStyles()
                              .whiteTextStyle()
                              .copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(7000),
                      child: Image.network(
                        walletDetail == null
                            ? ' '
                            : 'https://ads247-center.lazynerdstudios.com/${walletDetail!['image']}',
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
