import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class EntertainmentState extends ChangeNotifier {
  AudioPlayer audioPlayer = AudioPlayer();

  void playAudio() async {
    await audioPlayer.play(AssetSource("video/audio.mp3"),
        volume: 0.5, mode: PlayerMode.lowLatency);
    log("==================${audioPlayer.state}");
    notifyListeners();
  }

  pauseAudio() async {
    await audioPlayer.pause();
    log("==================${audioPlayer.state}");
    notifyListeners();
  }
}
