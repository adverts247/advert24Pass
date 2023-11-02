import 'package:adverts247Pass/themes.dart';
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
    return Container(
      child: AnimatedContainer(
        duration: Duration(microseconds: 550),
        curve: Curves.easeInOut,

        color: Colors.transparent,

        child: Image.asset(
          'assets/images/Untitled-1 1.png',
          width: _imageSize,
          height: _imageheigh,
          fit: BoxFit.fill,
        ), // Replace with your image path
      ),
    );
  }
}

class loader {
  void showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Stack(children: [
            Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/Group (6).png'),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Logging in ....',
                      style:
                          TextStyles().whiteTextStyle().copyWith(fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Text(
                    //   '',
                    //   style:
                    //       TextStyles().whiteTextStyle().copyWith(fontSize: 20),
                    // )
                  ],
                )),
            //  Center(
            //    child: SizedBox(
            //       height: 100,
            //       width: 100,
            //       child: CircularProgressIndicator(
            //           strokeWidth: 1, color: Colors.red)),
            //  ),
          ]),
        );
      },
    );
  }

  void circularModalLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          elevation: 0,
          insetPadding: EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //CircularProgressIndicator(strokeWidth: 1,),
                SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(
                        strokeWidth: 1, color: Colors.red)),
              ],
            ),
          ),
        );
      },
    );
  }
}
