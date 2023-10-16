import 'package:flutter/material.dart';

class AnimatedImage extends StatefulWidget {
  @override
  _AnimatedImageState createState() => _AnimatedImageState();
}

class _AnimatedImageState extends State<AnimatedImage> {
  double _imageSize = 100.0;
  bool _isAnimating = false;
  
  double _imageheigh = 90;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    setState(() {
      _isAnimating = !_isAnimating;
    });

    Future.delayed(Duration(milliseconds: 550), () {
      setState(() {
        _imageSize = _isAnimating ? 400.0 : 100.0;
         _imageheigh = _isAnimating ? 150.0 : 90.0;
      });
      _startAnimation();
    });
  }

  
  @override
  void dispose() {
    
    _startAnimation();
  }


  

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(microseconds: 550),
      curve: Curves.easeInOut,

      color: Colors.transparent,


      child: Image.asset(
        'assets/images/Untitled-1 1.png',
        width: _imageSize,
        height: _imageheigh,
        fit: BoxFit.fill,
      ), // Replace with your image path
    );
  }
}

class loader {
  void showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: AnimatedImage(),
        );
      },
    );
  }
}
