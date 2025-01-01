import 'package:adverts247Pass/pre-streaming-screen/weather_and_profile/weather_and_profile.dart';
import 'package:adverts247Pass/services/image_assets.dart';
import 'package:flutter/material.dart';

class ThankYouPage extends StatefulWidget {
  const ThankYouPage({super.key});

  @override
  State<ThankYouPage> createState() => _ThankYouPageState();
}

class _ThankYouPageState extends State<ThankYouPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 700)).then((value) =>
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ProfileWeatherView()),
            (route) => true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset("assets/images/thank_you1.png",
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.fill,),
    );
  }
}
