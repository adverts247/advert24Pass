//

import 'package:adverts247Pass/themes.dart';
import 'package:adverts247Pass/ui/screen/login.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // AppWebsocketService().determinePosition();
    moveToNextPage();
  }

  moveToNextPage() {
    //  var data = await tools.getFromStore('accessToken');
    //  if (data == null) {
        Future.delayed(const Duration(seconds: 2), () {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
        });
    //  } else {
    //    var storedEmail = await tools.getFromStore('email');
    //    var storedPassword = await tools.getFromStore('password');

    //    var body = {
    //      'email': storedEmail,
    //      'password': storedPassword

    // 'email': 'tested@test.com',
    // 'password': '12345678'
    //    };

    //    VideoService().login(context, body);
    //  }
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
              SizedBox(
                width: MediaQuery.of(context).size.width * .4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset('assets/images/Group (6).png'),
                    const SizedBox(height: 5),
                    Text(
                      '...reach your true target',
                      textAlign: TextAlign.right,
                      style:
                          TextStyles().whiteTextStyle().copyWith(fontSize: 17),
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // Text(
              //   'WELCOME ONBOARD',
              //   style: TextStyles().whiteTextStyle().copyWith(fontSize: 20),
              // )
            ],
          )),
    );
  }
}
