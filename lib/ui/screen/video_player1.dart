import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:adverts247Pass/pre-streaming-screen/game/entertainment_page.dart';
import 'package:adverts247Pass/pre-streaming-screen/weather_and_profile/weather_and_profile.dart';
import 'package:adverts247Pass/services/image_assets.dart';
import 'package:adverts247Pass/tools.dart' as tools;
import 'package:adverts247Pass/after_ads_display/radio_button_question.dart';
import 'package:adverts247Pass/model/video_model.dart';
import 'package:adverts247Pass/services/video_service.dart';
import 'package:adverts247Pass/state/user_state.dart';
import 'package:adverts247Pass/themes.dart';
import 'package:adverts247Pass/services/websocket.dart';
import 'package:adverts247Pass/ui/screen/about_me.dart';
import 'package:adverts247Pass/ui/screen/rating.dart';
import 'package:adverts247Pass/widget/ads_form.dart';
import 'package:adverts247Pass/widget/barcode.dart';
import 'package:adverts247Pass/widget/button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class VideoPlayerApp extends StatefulWidget {
  @override
  _VideoPlayerAppState createState() => _VideoPlayerAppState();
}

class _VideoPlayerAppState extends State<VideoPlayerApp>
    with SingleTickerProviderStateMixin {
  // Video player state
  VideoPlayerController? _controller;
  bool _isControllerInitialized = false;

  // Playlist management
  List<VideoModel> videoModelList = [];
  int _currentIndex = 0;
  VideoModel? currentAds;

  // UI state
  bool isLoading = true;
  bool isPhoto = false;
  bool showEndWidget = false;
  bool rating = false;
  bool displayWelcome = true;

  // Player controls
  double _volume = 0.3;
  bool _isMuted = false;
  bool showVolumeSlider = false;
  bool showBrightnessSlider = false;
  double _brightness = 1;

  // Animations
  AnimationController? likeController;
  bool _isLikeLarge = false;
  bool _isDislikeLarge = false;

  // Timers
  Timer? _endWidgetTimer;
  Timer? _locationTimer;

  // Services
  final VideoService videoService = VideoService();
  var walletDetail;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize wakelock and brightness
      await WakelockPlus.toggle(enable: true);
      await _setBrightness();

      // Start location updates
      _startLocationUpdates();

      // Initialize animation controller
      likeController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 2),
      );

      // Load initial data
      await _loadInitialData();
    } catch (e) {
      _handleError('Initialization error', e);
    }
  }

  void _startLocationUpdates() {
    _locationTimer?.cancel();
    _locationTimer = Timer.periodic(Duration(seconds: 1), (timer) async{
      try {
        await AppWebsocketService().requestLocationPermission();
        await AppWebsocketService().checkLocationServices();

        AppWebsocketService().checkLocation();
      } catch (e) {
        _handleError('Location update error', e);
      }
    });
  }

  Future<void> _loadInitialData() async {
    try {
      await _getWalletBalance();
      await _getVideoList();
    } catch (e) {
      _handleError('Data loading error', e);
    }
  }

  Future<void> _getWalletBalance() async {
    setState(() => isLoading = true);
    try {
      walletDetail =
          await Provider.of<UserState>(context, listen: false).userDetails;
    } catch (e) {
      _handleError('Wallet balance error', e);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _setBrightness() async {
    try {
      await ScreenBrightness().setScreenBrightness(_brightness);
    } catch (e) {
      _handleError('Brightness setting error', e);
    }
  }

  Future<void> _getVideoList() async {
    try {
      videoModelList = await videoService.getVideo(context);
      if (videoModelList.isNotEmpty) {
        currentAds = videoModelList[0];
        await _initializeCurrentAd();
      }
    } catch (e) {
      _handleError('Video list loading error', e);
    }
  }

  Future<void> _initializeCurrentAd() async {
    if (currentAds == null) return;

    try {
      setState(() {
        isLoading = true;
        displayWelcome = false;
        _isControllerInitialized = false;
      });

      if (currentAds!.type == 'photo') {
        await _handlePhotoAd();
      } else {
        await _handleVideoAd();
      }
    } catch (e) {
      _handleError('Ad initialization error', e);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _handlePhotoAd() async {
    setState(() => isPhoto = true);

    // Automatically proceed to next ad after delay
    _endWidgetTimer?.cancel();
    _endWidgetTimer = Timer(Duration(seconds: 10), () {
      if (mounted) _proceedToNextAd();
    });
  }

  Future<void> _handleVideoAd() async {
    setState(() => isPhoto = false);

    try {
      final videoPath = await videoService.fetchVideo(
          currentAds!.content.path.toString(), context);

      if (videoPath == null) {
        throw Exception('Failed to fetch video path');
      }

      await _initializeVideoController(videoPath);
    } catch (e) {
      _handleError('Video handling error', e);
      // Fallback: proceed to next ad if current fails
      if (mounted) _proceedToNextAd();
    }
  }

  Future<void> _initializeVideoController(String videoPath) async {
    _controller?.dispose();

    if (videoPath.endsWith('mkv')) {
      // Handle MKV format if needed
      // vlcController = VlcPlayerController.network(...);
    } else {
      _controller = VideoPlayerController.file(File(videoPath));

      try {
        await _controller!.initialize();
        _controller!.setVolume(_isMuted ? 0.0 : _volume);
        _controller!.play();

        _controller!.addListener(_videoListener);
        setState(() => _isControllerInitialized = true);
      } catch (e) {
        _handleError('Video controller initialization error', e);
        _controller?.dispose();
        _controller = null;
      }
    }
  }

  void _videoListener() {
    if (!_controller!.value.isInitialized || !mounted) return;

    final totalDuration = _controller!.value.duration;
    final currentPosition = _controller!.value.position;
    final remainingSeconds = (totalDuration - currentPosition).inSeconds;

    // Show end widget when 10 seconds remain
    if (remainingSeconds <= 10 && !showEndWidget) {
      setState(() => showEndWidget = true);
    }

    // Handle video completion
    if (_controller!.value.isCompleted || _controller!.value.hasError) {
      _endWidgetTimer?.cancel();
      _endWidgetTimer = Timer(Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            showEndWidget = false;
            rating = true;
          });
          _proceedToNextAd();
        }
      });
    }
  }

  void _proceedToNextAd() {
    if (!mounted) return;

    setState(() {
      rating = false;
      _currentIndex = (_currentIndex + 1) % videoModelList.length;
      currentAds = videoModelList[_currentIndex];
    });

    _initializeCurrentAd();
  }

  void _toggleMute() {
    if (_controller == null) return;

    setState(() {
      _isMuted = !_isMuted;
      _controller!.setVolume(_isMuted ? 0.0 : _volume);
    });
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    _endWidgetTimer?.cancel();
    _locationTimer?.cancel();
    likeController?.dispose();
    WakelockPlus.toggle(enable: false);
    super.dispose();
  }

  void _handleError(String context, dynamic error) {
    log('$context: $error');
    // You might want to show an error to the user or implement retry logic
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (displayWelcome) {
      return Container(); // Assuming this exists
    }

    if (rating) {
      return RatingPage();
    }

    if (isLoading) {
      return const EntertainmentPage(
        addDelay: true,
      );
    }

    if (isPhoto) {
      return _buildPhotoContent();
    }

    return _buildVideoContent();
  }

  Widget _buildPhotoContent() {
    return FutureBuilder<Uint8List>(
      future:
          videoService.fetchData(currentAds!.content.path.toString(), context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return EntertainmentPage();
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Center(child: Text('Failed to load image'));
        }

        return Column(
          children: [
            Expanded(
              child: Center(
                child: Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            _buildBottomControls(),
            _buildBottomSecondaryControls(),
          ],
        );
      },
    );
  }

  Widget _buildVideoContent() {
    if (!_isControllerInitialized || _controller == null) {
      return EntertainmentPage();
    }

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showVolumeSlider = false;
                          showBrightnessSlider = false;
                        });
                      },
                      child: AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      ),
                    ),
                  ),
                  if (showEndWidget) _buildEndWidget(),
                ],
              ),
              _buildVideoOverlayControls(),
            ],
          ),
        ),
        _buildBottomControls(),
        _buildBottomSecondaryControls(),
      ],
    );
  }

  Widget _buildEndWidget() {
    return Expanded(
        child: BarcodeDisplayWidget(
          url: currentAds?.callToAction?.url,
          text: currentAds?.callToAction?.description ?? "Scan Code",
        )
        // Container(
        //   height: 150,
        //   width: 200,
        //   decoration: BoxDecoration(
        //     image: DecorationImage(
        //       image: AssetImage("assets/images/Qr_code1.png"),
        //       fit: BoxFit.fill,
        //     ),
        //   ),
        // ),
        );
  }

  Widget _buildVideoOverlayControls() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (showVolumeSlider) _buildVolumeSlider(),
        if (showBrightnessSlider) _buildBrightnessSlider(),
        _buildVideoProgressControls(),
      ],
    );
  }

  Widget _buildVolumeSlider() {
    return Column(
      children: [
        Text(
          "Volume ${(_volume * 100).toStringAsFixed(0)}%",
          style: TextStyles().blackTextStyle700().copyWith(
                fontSize: 24,
                color: Colors.white,
              ),
        ),
        Slider(
          value: _volume,
          activeColor: Colors.white,
          inactiveColor: Colors.black,
          onChanged: (newVolume) {
            setState(() {
              _volume = newVolume;
              _controller?.setVolume(_isMuted ? 0.0 : _volume);
            });
          },
          min: 0.0,
          max: 1.0,
          divisions: 10,
          label: "Volume ${(_volume * 100).toStringAsFixed(0)}%",
        ),
      ],
    );
  }

  Widget _buildBrightnessSlider() {
    return Column(
      children: [
        Text(
          "Brightness ${(_brightness * 100).toStringAsFixed(0)}%",
          style: TextStyles().blackTextStyle700().copyWith(
                fontSize: 24,
                color: Colors.white,
              ),
        ),
        Slider(
          value: _brightness,
          label: "Brightness ${(_brightness * 100).toStringAsFixed(0)}%",
          onChanged: (value) async {
            setState(() => _brightness = value);
            await _setBrightness();
          },
          divisions: 10,
          activeColor: Colors.white,
          inactiveColor: Colors.black,
        ),
      ],
    );
  }

  Widget _buildVideoProgressControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(138, 45, 45, 45),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  _controller?.value.isPlaying ?? false
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (_controller == null) return;
                  setState(() {
                    if (_controller!.value.isPlaying) {
                      _controller!.pause();
                    } else {
                      _controller!.play();
                    }
                  });
                },
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: VideoProgressIndicator(
                          _controller!,
                          allowScrubbing: true,
                          colors: VideoProgressColors(
                            playedColor: Colors.white,
                            bufferedColor: Colors.red,
                            backgroundColor: Colors.white30,
                          ),
                        ),
                      ),
                    ),
                    if (_controller != null && _controller!.value.isInitialized)
                      Text(
                        _formatDuration(_controller!.value.duration),
                        style: TextStyles().whiteTextStyle().copyWith(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    return "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  Widget _buildBottomControls() {
    final height = MediaQuery.of(context).size.height;

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(width: 40),
                _buildLikeButton(height),
                SizedBox(width: 40),
                _buildDislikeButton(height),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 70,
                  child: SecondaryButton(
                    text: 'Prev',
                    onPressed: _currentIndex > 0 ? _goToPreviousAd : null,
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  width: 70,
                  child: MyButton(
                    text: 'Next',
                    onPressed: _proceedToNextAd,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLikeButton(double height) {
    return InkWell(
      splashColor: Colors.black,
      hoverColor: Colors.black,
      highlightColor: Colors.black,
      enableFeedback: false,
      onTap: () => _handleLike(true),
      child: Container(
        height: height < 500 ? 30 : 40,
        width: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: 210),
              child: Icon(
                MdiIcons.thumbUpOutline,
                color: Colors.blue,
                size: _isLikeLarge ? 35.0 : 25.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDislikeButton(double height) {
    return InkWell(
      splashColor: Colors.black,
      hoverColor: Colors.black,
      highlightColor: Colors.black,
      enableFeedback: false,
      onTap: () => _handleLike(false),
      child: Container(
        height: height < 500 ? 30 : 40,
        width: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              MdiIcons.thumbDownOutline,
              color: Colors.red,
              size: _isDislikeLarge ? 35.0 : 25.0,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLike(bool isLike) async {
    if (currentAds == null) return;

    setState(() {
      if (isLike) {
        _isLikeLarge = !_isLikeLarge;
      } else {
        _isDislikeLarge = !_isDislikeLarge;
      }
    });

    if (isLike && _isLikeLarge || !isLike && _isDislikeLarge) {
      likeController?.forward();
      await Future.delayed(Duration(milliseconds: 110));
      if (mounted) {
        setState(() {
          if (isLike)
            _isLikeLarge = false;
          else
            _isDislikeLarge = false;
        });
      }
    } else {
      likeController?.reverse();
    }

    try {
      final sessionId =
          Provider.of<UserState>(context, listen: false).sessionId;
      final body = {"sessionId": sessionId};

      if (isLike) {
        VideoService().likeVideo(context, body, currentAds!.content.path);
      } else {
        VideoService().disLikeVideo(context, body, currentAds!.content.path);
      }
    } catch (e) {
      _handleError('Like/Dislike error', e);
    }
  }

  void _goToPreviousAd() {
    if (_currentIndex <= 0) return;

    setState(() {
      rating = false;
      _currentIndex--;
      currentAds = videoModelList[_currentIndex];
    });

    _initializeCurrentAd();
  }

  Widget _buildBottomSecondaryControls() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  ImageAssets.appLogo,
                  height: 40,
                  width: 200,
                ),
                Row(
                  children: [
                    _buildBrightnessControl(),
                    SizedBox(width: 30),
                    _buildMuteControl(),
                    SizedBox(width: 30),
                    _buildVolumeControl(),
                    SizedBox(width: 40),
                    _buildProfileImage(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrightnessControl() {
    return InkWell(
      onTap: () {
        setState(() => showBrightnessSlider = true);
      },
      child: Column(
        children: [
          Icon(MdiIcons.brightness4, color: Colors.white),
          Text(
            'Brightness',
            style: TextStyles().whiteTextStyle().copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildMuteControl() {
    return Column(
      children: [
        InkWell(
          onTap: _toggleMute,
          child: Icon(
            _isMuted ? Icons.volume_off : Icons.volume_up,
            color: Colors.white,
          ),
        ),
        Text(
          'Mute',
          style: TextStyles().whiteTextStyle().copyWith(fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildVolumeControl() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() => showVolumeSlider = !showVolumeSlider);
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
          'Volume',
          style: TextStyles().whiteTextStyle().copyWith(fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildProfileImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7000),
      child: walletDetail == null || walletDetail!['image'] == null
          ? Container(
              width: 50,
              height: 50,
              color: Colors.grey,
            )
          : Image.network(
              'https://central.adverts247.xyz/${walletDetail!['image']}',
              height: 50,
              width: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 50,
                height: 50,
                color: Colors.grey,
              ),
            ),
    );
  }
}
