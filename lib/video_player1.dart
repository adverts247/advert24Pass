import 'dart:io';
import 'dart:math';

import 'package:advert24pass/about_me.dart';
import 'package:advert24pass/after_ads_display/radio_button_question.dart';
import 'package:advert24pass/login.dart';
import 'package:advert24pass/model/video_model.dart';
import 'package:advert24pass/rating.dart';
import 'package:advert24pass/services/video_service.dart';
import 'package:advert24pass/state/user_state.dart';
import 'package:advert24pass/themes.dart';
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
import 'package:animated_icon/animated_icon.dart';

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

  bool? isPhoto = false;

  Future<Uint8List>? futureValue;

  var video;

  bool? isLoading = true;

  double? _volume = 0.3;

  bool? showVolumeSlider = false;
  double _sliderValue = 0.0;

  int chuncksPlayed = 0;
  VlcPlayerController? vlcController;

  AnimationController? likeController;
  AnimationController? disLikeController;
  bool _isLarge = false;

  var _isdisLikeLarge = false;

  bool? rating = false;

  @override
  void initState() {
    getVideoList();
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

  Future<void> getVideoList() async {
    final mode = await getKioskMode().then((value) => print('started'));

    startKioskMode();
    //   getVideourl('3');
    videoModelList = await VideoService().getVideo(context);
    print(videoModelList);
    currentAds = videoModelList![0];
    ifIsVideo();

    // _controller = VideoPlayerController.network(videoUrls[_currentIndex])
    //   ..initialize().then((_) {
    //     // Ensure the first video is displayed as a preview image
    //     setState(() {});
    //   })
    //   ..addListener(() {
    //     if (_controller!.value.position >= _controller!.value.duration) {
    //       // Video has finished playing
    //       // You can add your logic here
    //       print('Video ${_currentIndex} has finished playing');
    //       if (_currentIndex < 1) {
    //         _playNextVideo();
    //       }
    //     }
    //   });
  }

  List<Widget> actionWidget = [
    //QuestionPage(),
    // BarcodeDisplayWidget(url : currentAds!.callToAction.url),
    // AdsFormPage()
  ];

  Future<void> ifIsVideo() async {
    setState(() {
      isLoading = true;
    });
    print(currentAds!.id);
    print(currentAds!.type.toString());

    if (currentAds!.type.toString() == 'photo') {
      setState(() {
        isPhoto = true;

        futureValue =
            VideoService().fetchData(currentAds!.content.path.toString());
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
    super.dispose();
  }

  nextAds() {
    // Trigger the modal when a barcode is scanned
    var actionIdex = Random().nextInt(3);

    if (currentAds!.callToAction.url.toString() == 'null') {
    } else {
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        //  isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return BarcodeDisplayWidget(url: currentAds!.callToAction.url);
          // BarcodeDisplayWidget();
        },
      );
    }

    Future.delayed(Duration(seconds: 10), () {
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

  // void _playPreviousVideo() {
  //   setState(() {
  //     if (_currentIndex > 0) {
  //       _currentIndex--;
  //       _controller = VideoPlayerController.network(videoUrls[_currentIndex],
  //           videoPlayerOptions: VideoPlayerOptions())
  //         ..initialize().then((_) {
  //           setState(() {});
  //         })
  //         ..addListener(() {
  //           if (_controller!.value.isCompleted) {
  //             // Video has finished playing
  //             // You can add your logic here
  //             print('Video ${_currentIndex} has finished playing');
  //           }
  //         });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     setState(() {
          //       if (_controller!.value.isPlaying) {
          //         _controller!.pause();
          //       } else {
          //         _controller!.play();
          //       }
          //     });
          //   },
          //   child: Icon(
          //     _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
          //   ),
          // ),
          body: rating!
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
                                                child:
                                                    VideoPlayer(_controller!)),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                showVolumeSlider!
                                                    ? Slider(
                                                        value: _volume!,
                                                        activeColor: Colors.red,
                                                        inactiveColor:
                                                            Colors.black,
                                                        onChanged: (newVolume) {
                                                          setState(() {
                                                            _volume = newVolume;
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
                                                      )
                                                    : Container(),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Color.fromARGB(
                                                            138, 45, 45, 45),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20.0),
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
                                                              _controller!.value
                                                                      .isPlaying
                                                                  ? Icons.pause
                                                                  : Icons
                                                                      .play_arrow,
                                                              color:
                                                                  Colors.white,
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
                                                                        colors: VideoProgressColors(
                                                                            playedColor: Colors
                                                                                .white,
                                                                            bufferedColor: Colors
                                                                                .red,
                                                                            backgroundColor: Colors
                                                                                .white30),
                                                                        _controller!,
                                                                        allowScrubbing:
                                                                            true),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  _controller!
                                                                      .value
                                                                      .duration
                                                                      .toString(),
                                                                  style: TextStyles()
                                                                      .whiteTextStyle()
                                                                      .copyWith(
                                                                          fontWeight: FontWeight
                                                                              .w300,
                                                                          fontSize:
                                                                              13),
                                                                ),

                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      showVolumeSlider =
                                                                          !showVolumeSlider!;
                                                                    });
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            10),
                                                                    child: Icon(
                                                                      MdiIcons
                                                                          .volumeHigh,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
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
                                    bottomWidget()
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
                                    bottomWidget()
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
                  splashColor: Colors.white,
                  hoverColor: Colors.white,
                  highlightColor: Colors.white,
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
                  splashColor: Colors.white,
                  hoverColor: Colors.white,
                  highlightColor: Colors.white,
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
}
