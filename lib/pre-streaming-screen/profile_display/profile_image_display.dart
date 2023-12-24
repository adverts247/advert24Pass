import 'package:adverts247Pass/pre-streaming-screen/weather_and_profile/weather_and_profile.dart';
import 'package:adverts247Pass/state/user_state.dart';
import 'package:adverts247Pass/themes.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 10), () {
      Get.to(
        const ProfileWeatherView(),
        transition: Transition.fadeIn,
        curve: Curves.easeInOut,
        duration: const Duration(seconds: 1),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var userDetail = Provider.of<UserState>(context, listen: false).userDetails;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Image.asset(
                    'assets/images/Group (6).png',
                    height: MediaQuery.of(context).size.height < 450 ? 80 : 200,
                    width: MediaQuery.of(context).size.height < 450 ? 80 : 200,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'You are riding with',
                  style: TextStyles().whiteTextStyle().copyWith(fontSize: 30),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  userDetail['firstname'],
                  style: TextStyles()
                      .whiteTextStyle()
                      .copyWith(fontSize: 50, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2000),
                  child: Image.network(
                    'https://central.adverts247.xyz/${userDetail!['image']}',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
