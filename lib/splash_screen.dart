//
import 'package:advert24pass/login.dart';
import 'package:advert24pass/themes.dart';
import 'package:advert24pass/websocket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    LocationWesocket().determinePosition();

    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
          height: screenSize.height,
          width: screenSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/Untitled-1 1.png'),
              SizedBox(
                height: 20,
              ),
              Text(
                'WELCOME ONBOARD',
                style: TextStyles().blackTextStyle700().copyWith(fontSize: 20),
              )
            ],
          )),
    );
  }
}
