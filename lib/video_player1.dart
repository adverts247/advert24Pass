import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:advert24pass/tools.dart' as tools;
import 'package:advert24pass/about_me.dart';
import 'package:advert24pass/after_ads_display/radio_button_question.dart';
import 'package:advert24pass/login.dart';
import 'package:advert24pass/model/video_model.dart';
import 'package:advert24pass/rating.dart';
import 'package:advert24pass/services/video_service.dart';
import 'package:advert24pass/splash_screen.dart';
import 'package:advert24pass/state/user_state.dart';
import 'package:advert24pass/themes.dart';
import 'package:advert24pass/weather.dart';
import 'package:advert24pass/websocket.dart';
import 'package:advert24pass/welcome_onboard.dart';
import 'package:advert24pass/widget/ads_form.dart';
import 'package:advert24pass/widget/barcode.dart';
import 'package:advert24pass/widget/button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kiosk_mode/kiosk_mode.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class VideoPlayerApp extends StatefulWidget {
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
  bool? isPhoto = true;
  Future<Uint8List>? futureValue;
  var video;
  bool? isLoading = true;
  double? _volume = 0.3;
  late BuildContext myContext;
  bool? showVolumeSlider = false;

  int chuncksPlayed = 0;
  VlcPlayerController? vlcController;

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

  var displayWelcome = false;

  @override
  void initState() {

    getVideoList();
    getWalletBalance();

    //send driver location
    Timer.periodic(Duration(seconds: 1), (timer) {
      LocationWesocket().checkLocation(context);
      //print('yes');
    });

    super.initState();
    likeController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    // disLikeController = AnimationController(
    //   vsync: this,
    //   duration: Duration(seconds: 2),
    // );
  }

  //get profile because of profile picture
  getWalletBalance() async {
    setState(() {
      isLoading = true;
    });
    walletDetail =
        await Provider.of<UserState>(context, listen: false).userDetails;
    print(walletDetail);

    setState(() {
      isLoading = false;
    });
  }
  

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller!.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  //listen to exit app
  void connectToDriverChannel(String userId) {
    IO.Socket socket =
        IO.io('wss://streamer.lazynerdstudios.com', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) {
      print('Connected');
      socket.emit('watch driver', [userId]);
    });

    socket.on('stop-stream', (data) async {
      // Handle stop-stream event
      print('Received stop-stream event');
      final mode = await getKioskMode().then((value) => print('ended'));

      stopKioskMode();
      if (isPhoto!) {
      } else {
        _controller!.pause();
        _controller!.dispose();
      }
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => WaitingPage()));
    });

    socket.on('start-stream', (data) {
      // Handle start-stream event
      print('Received start-stream event');
    });
  }

  Future<void> getVideoList() async {
    final mode = await getKioskMode().then((value) => print('started'));

    startKioskMode();
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
      var size = Provider.of<UserState>(context, listen: false).size;

      if (video.toString().endsWith('mkv')) {
        vlcController = VlcPlayerController.network(
          video,
          hwAcc: HwAcc.full,
          autoPlay: true,
          options: VlcPlayerOptions(),
        );
      } else {
        _controller = VideoPlayerController.file(File(video))
          ..initialize().then((_) {
            _controller!.play();
            setState(() {});
          });

        _controller!.addListener(() async {
          print(_controller!.value.errorDescription);
          print(_controller!.value.position);

          print(" buffering ${_controller!.value.hasError}");
          if (_controller!.value.isCompleted || _controller!.value.hasError) {
            if (_currentIndex < videoModelList!.length - 1) {
              nextAds();

              _controller!.dispose();
            } else {
              setState(() {
                _currentIndex = -1;
              });
              print('dsdsd ${_currentIndex}');
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

//   int _counter = 10;

//   void _startTimer() {
//     setState(() {
//       _counter = 10;
//     });

//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       _counter = 10;
//       if (_counter > 0) {
//         _counter--;
//       } else {
//         Navigator.pop(context);
//         _timer.cancel(); // Cancel the timer when the counter reaches 0
//         setState(() {
//           rating = true;
//         });
//         Future.delayed(Duration(seconds: 5), () {
//           setState(() {
//             rating = false;
//             _currentIndex++;
//             currentAds = videoModelList![_currentIndex];
//           });
//           ifIsVideo();
//         });
//       }
//     });
//     // });
//   }

//   void _handleTap() {
//     setState(() {
//       _counter = 10; // Reset the counter when the screen is tapped
//     });
//   }

// // Update the nextAds function
//   void nextAds() {
//     var actionIdex = Random().nextInt(3);
//     if (currentAds!.callToAction.url.toString() == 'null') {
//     } else {
//      // _startTimer();
//       showModalBottomSheet(
//         context: context,
//         isDismissible: false,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             topRight: Radius.circular(20),
//             topLeft: Radius.circular(20),
//           ),
//         ),
//         builder: (BuildContext context) {
//           return GestureDetector(
//             onTap: () {
//               _handleTap();
//             },
//             child: BarcodeDisplayWidget(url: currentAds!.callToAction.url),
//           );
//         },
//       );
//     }
//   }

  // timer to pop if user didnt touch the screen
  // _startTimer() {
  //   _timer = Timer.periodic(Duration(seconds: 10), (timer) {
  //     // Perform your function here when no tap is detected within 10 seconds
  //     test();
  //   });
  // }

  // void ede() {
  //   setState(() {
  //     next = true;
  //   });
  // }

  // void _handleTap() {
  //   // Restart the timer when a tap is detected
  //   _timer.cancel();
  //   print('keep tapping');
  //   _startTimer();
  // }

  void addToTheSecond() {
    setState(() {
      secondss = 10;
    });
  }

  nextAds() {
    // Trigger the modal when a barcode is scanned
    // var actionIdex = Random().nextInt(3);

    // if (currentAds!.callToAction.url.toString() == 'null') {
    // } else {
    //   //_startTimer();
    //   showModalBottomSheet(
    //     context: context,
    //     isDismissible: false,
    //     //  isScrollControlled: true,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.only(
    //         topRight: Radius.circular(20),
    //         topLeft: Radius.circular(20),
    //       ),
    //     ),
    //     builder: (BuildContext context) {
    //       return StatefulBuilder(
    //         builder: (BuildContext context, StateSetter setState) {
    //           return GestureDetector(
    //             onTap: () {
    //               // secondss = 10;
    //               // print(secondss);
    //               // addToTheSecond();
    //             },
    //             child: BarcodeDisplayWidget(url: currentAds!.callToAction.url),
    //           );
    //         },
    //       );
    //     },
    //   );
    // }

    Future.delayed(Duration(seconds: isPhoto! ? 10 : 1), () {
      //   Navigator.pop(context);

      setState(() {
        rating = true;
      });

      // After 5 sec turn rating value to false : This allows the rating wiget to leave the screen

      Future.delayed(Duration(seconds: 5), () {
        setState(() {
          rating = false;

          //tools.deleteFile(filePath)
          //
          displayWelcome = true;
        });

        Future.delayed(Duration(seconds: 10), () {
          setState(() {
                    displayWelcome = false;

            _currentIndex++;

            currentAds = videoModelList![_currentIndex];
          });

          ifIsVideo();
        });
      });
    });
  }

  void test() {
    Navigator.pop(context);

    setState(() {
      rating = true;
    });

    Future.delayed(Duration(seconds: 5), () {
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
    connectToDriverChannel('26');
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: displayWelcome
              ? WelcomePage()
              : rating!
                  ? RatingPage()
                  : isLoading!
                      ? AboutMePage()
                      : !isPhoto!
                          ? video.toString().endsWith('mkv')
                              ? Column(
                                  children: [
                                    Expanded(
                                      child: VlcPlayer(
                                        controller: vlcController!,
                                        aspectRatio: 16 / 9,
                                        placeholder: Center(
                                            child: CircularProgressIndicator()),
                                      ),
                                    ),
                                    Slider(
                                      value: vlcController!
                                          .value.position.inMilliseconds
                                          .toDouble(),
                                      min: 0.0,
                                      max: vlcController!
                                          .value.duration.inMilliseconds
                                          .toDouble(),
                                      onChanged: (value) {
                                        //   vlcController!.value. .setTime(value.toInt());
                                      },
                                    ),
                                    bottomWidget()
                                  ],
                                )
                              : _controller!.value.isInitialized
                                  ? Column(
                                      children: [
                                        Expanded(
                                          child: AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: Stack(
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        showVolumeSlider =
                                                            !showVolumeSlider!;
                                                      });
                                                    },
                                                    child: VideoPlayer(
                                                        _controller!)),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    showVolumeSlider!
                                                        ? Column(
                                                            children: [
                                                              Text(
                                                                "${_volume! * 100}",
                                                                style: TextStyles()
                                                                    .blackTextStyle700()
                                                                    .copyWith(
                                                                        fontSize:
                                                                            24),
                                                              ),
                                                              Slider(
                                                                value: _volume!,
                                                                activeColor:
                                                                    Colors.red,
                                                                inactiveColor:
                                                                    Colors
                                                                        .black,
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
                                                                    "${_volume! * 100}",
                                                              ),
                                                            ],
                                                          )
                                                        : Container(),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20,
                                                          vertical: 10),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    138,
                                                                    45,
                                                                    45,
                                                                    45),
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
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 10),
                                                                        child: VideoProgressIndicator(
                                                                            colors: VideoProgressColors(
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
                                                                          fontWeight: FontWeight
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
                                        ),
                                        bottomWidget(),
                                        bottomBottomWidget()
                                      ],
                                    )
                                  : AboutMePage()
                          : FutureBuilder<Uint8List>(
                              future: futureValue,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return AboutMePage();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  final imageBytes = snapshot.data;

                                  if (imageBytes != null) {
                                    Future.delayed(Duration(seconds: 5), () {
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
                                    return Text('No image data received');
                                  }
                                }
                              },
                            )),
    );
  }

  bottomWidget() {
    return Container(
      height: 85,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
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

                        Future.delayed(Duration(milliseconds: 110), () {
                          setState(() {
                            _isLarge = !_isLarge;
                          });
                        });
                      } else {
                        likeController!.reverse();
                      }
                    });

                    var sessionId =
                        await Provider.of<UserState>(context, listen: false)
                            .sessionId;
                    var body = {"sessionId": sessionId};
                    VideoService()
                        .likeVideo(context, body, currentAds!.content.path);
                  },
                  child: Container(
                    height: 50,
                    width: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 210),
                          child: Icon(
                            MdiIcons.thumbUpOutline,
                            color: Colors.blue,
                            size: _isLarge ? 40.0 : 30.0,
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
                SizedBox(
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

                        Future.delayed(Duration(milliseconds: 110), () {
                          setState(() {
                            _isdisLikeLarge = !_isdisLikeLarge;
                          });
                        });
                      } else {
                        likeController!.reverse();
                      }
                    });

                    var sessionId =
                        await Provider.of<UserState>(context, listen: false)
                            .sessionId;
                    var body = {"sessionId": sessionId};
                    VideoService()
                        .disLikeVideo(context, body, currentAds!.content.path);
                  },
                  child: Container(
                    height: 50,
                    width: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.thumbDownOutline,
                          color: Colors.red,
                          size: _isdisLikeLarge ? 40.0 : 30.0,
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
                Container(
                    width: 70,
                    child: SecondaryButton(
                      text: 'Prev',
                      onPressed: () {
                        previousAds();
                      },
                    )),
                SizedBox(
                  width: 20,
                ),
                Container(
                    width: 70,
                    child: MyButton(
                      text: 'Next',
                      onPressed: () {
                        //  nextVideo();
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

  bottomBottomWidget() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(20)),
      height: 85,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
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
                    Column(
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
                    SizedBox(
                      width: 30,
                    ),
                    InkWell(
                      onTap: () {
                        _toggleMute();
                        print(_isMuted);
                      },
                      child: Column(
                        children: [
                          Icon(Icons.volume_off, color: Colors.white),
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
                    SizedBox(
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
                    SizedBox(
                      width: 40,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(7000),
                      child: Image.network(
                        walletDetail == null
                            ? ' '
                            : 'https://ads24.lazynerdstudios.com/${walletDetail!['image']}',
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
