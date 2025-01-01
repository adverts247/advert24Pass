import 'dart:async';

import 'package:adverts247Pass/pre-streaming-screen/weather_and_profile/weather_and_profile.dart';
import 'package:adverts247Pass/services/image_assets.dart';
import 'package:adverts247Pass/state/user_state.dart';
import 'package:adverts247Pass/themes.dart';
import 'package:adverts247Pass/widget/clipper_page.dart/clipper_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _borderController;

  late Animation<double> _bounceAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _borderColorAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Main controller for entrance animations
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    // Separate controller for border color
    _borderController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    // Bounce animation
    _bounceAnimation = Tween<double>(begin: -400, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 0.5, curve: Curves.easeIn),
      ),
    );

    // Border color animation - only define it once
    _borderColorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _borderController,
        curve: Curves.linear, // Smooth transition between colors
      ),
    );

    // Start entrance animations
    _controller.forward();

    // Start border animation after delay
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _borderController.repeat(); // This will make it cycle continuously
      });
    });

    Future.delayed(Duration(seconds: 6), () {
      Get.to(
        ProfileWeatherView(),
        transition: Transition.fadeIn,
        curve: Curves.easeInOut,
        duration: Duration(seconds: 1),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _borderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userDetail = Provider.of<UserState>(context, listen: false).userDetails;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return
                  // Container(
                  //   height: MediaQuery.of(context).size.height,
                  //   width: MediaQuery.of(context).size.width,
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.all(30.0),
                  //         child: Image.asset(
                  //           ImageAssets.appLogo,
                  //           height: MediaQuery.of(context).size.height < 450
                  //               ? 80
                  //               : 200,
                  //           width: MediaQuery.of(context).size.height < 450
                  //               ? 80
                  //               : 200,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      // height: MediaQuery.of(context).size.height,
                      // width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              'You are riding with',
                              style: TextStyles().whiteTextStyle().copyWith(
                                    fontSize: 30,
                                  ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            userDetail['firstname'],
                            style: TextStyles().whiteTextStyle().copyWith(
                                fontSize: 50, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.sp,
                  ),
                  Transform.translate(
                    offset: Offset(_bounceAnimation.value, 0),
                    child: Container(
                      height: 150.sp,
                      width: 150.sp,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amberAccent,
                        border: Border.all(
                          color: Color.lerp(
                            Themes().blue,
                            Themes().pink,
                            _borderColorAnimation.value,
                          )!,
                          width: 6,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20000),
                        child: Image.network(
                          'https://central.adverts247.xyz/${userDetail!['image']}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
