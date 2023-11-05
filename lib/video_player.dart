import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class VideoApp extends StatefulWidget {
  VideoApp({Key? key}) : super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;
  double _volumeValue = 0.5;
  double _brightnessValue = 0.5;

  @override
  void initState() {
    super.initState();
    String videoURL = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
    _controller = VideoPlayerController.network(videoURL)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? Stack(
                children: [
                  GestureDetector(
                    onVerticalDragUpdate: (details) {
                      setState(() {
                        _brightnessValue -= details.primaryDelta! / 100;
                        _brightnessValue = _brightnessValue.clamp(0.0, 1.0);
                      });
                    },
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        _volumeValue -= details.primaryDelta! / 1000;
                        _volumeValue = _volumeValue.clamp(0.0, 1.0);
                        _controller.setVolume(_volumeValue);
                      });
                    },
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Slider(
                        value: _brightnessValue,
                        onChanged: (value) {
                          setState(() {
                            _brightnessValue = value;
                            // Implement brightness control logic here.
                          });
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Slider(
                      value: _volumeValue,
                      onChanged: (value) {
                        setState(() {
                          _volumeValue = value;
                          _controller.setVolume(_volumeValue);
                        });
                      },
                    ),
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying ? _controller.pause() : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
