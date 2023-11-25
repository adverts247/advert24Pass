import 'package:adverts247Pass/pre-streaming-screen/profile_display/profile_image_display.dart';
import 'package:adverts247Pass/pre-streaming-screen/welcome_onbaording/welcome_onbaording_viewmodel.dart';
import 'package:adverts247Pass/themes.dart';
import 'package:adverts247Pass/services/websocket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:get/get.dart';

class PreStreamingWelcomePage extends StatefulWidget {
  const PreStreamingWelcomePage({super.key});

  @override
  State<PreStreamingWelcomePage> createState() =>
      _PreStreamingWelcomePageState();
}

class _PreStreamingWelcomePageState extends State<PreStreamingWelcomePage> {
  @override
  void initState() {
    super.initState();
    AppWebsocketService().determinePosition();

    Future.delayed(Duration(seconds: 10), () {
      Get.to(ProfileImage(),
      transition: Transition.fadeIn,
        curve: Curves.easeIn,
        duration: Duration(seconds: 1),
      
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => WelcomeOnboarding(),
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SizedBox(
                height: screenSize.height,
                width: screenSize.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.asset('assets/images/Group (6).png'),
                          SizedBox(height: 5),
                          Text(
                            '...reach your true target',
                            textAlign: TextAlign.right,
                            style: TextStyles()
                                .whiteTextStyle()
                                .copyWith(fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'WELCOME ONBOARD',
                      style:
                          TextStyles().whiteTextStyle().copyWith(fontSize: 30),
                    )
                  ],
                )),
          );
        });
  }
}
