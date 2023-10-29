//
import 'package:advert24pass/login.dart';
import 'package:advert24pass/themes.dart';
import 'package:advert24pass/websocket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    LocationWesocket().determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
          height: screenSize.height,
          width: screenSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/Group (6).png'),
              SizedBox(
                height: 20,
              ),
              Text(
                'WELCOME ONBOARD',
                style: TextStyles().whiteTextStyle().copyWith(fontSize: 30),
              )
            ],
          )),
    );
  }
}
