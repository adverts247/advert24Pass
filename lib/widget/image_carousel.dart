import 'dart:async';

import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  Timer? _timer;
  int currentImageIndex = 0;

  final List<String> images = [
    'assets/images/head_icon.png',
    'assets/images/fishes.png',
    'assets/images/lion.png',
    'assets/images/two_head.png',
    'assets/images/curved_unicorn.png',
    'assets/images/bull.png',
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        currentImageIndex = (currentImageIndex + 1) % images.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: Image.asset(
          images[currentImageIndex],
          key: ValueKey<int>(currentImageIndex),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
