// import 'dart:async';

import 'package:adverts247Pass/state/user_state.dart';
import 'package:adverts247Pass/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AfterAdsProfileView extends StatefulWidget {
  const AfterAdsProfileView({super.key});

  @override
  State<AfterAdsProfileView> createState() => _AfterAdsProfileViewState();
}

class _AfterAdsProfileViewState extends State<AfterAdsProfileView> {
  bool? isLoading = true;

  Map<String, dynamic>? walletDetail;

  var weatherApiResult;

  var showWeather = true;
  @override
  void initState() {
    getWalletBalance();
    super.initState();
    // _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
    //   setState(() {
    //     showWeather = !showWeather;
    //   });
    // });
  }

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
  }

  getWalletBalance() async {
    //  VideoService().getWallet(context);

    setState(() {
      isLoading = true;
    });
    walletDetail =
        await Provider.of<UserState>(context, listen: false).userDetails;
    print(walletDetail);

    // get weather from state
    // weatherApiResult =
    //     await Provider.of<WeatherLocationState>(context, listen: false)
    //         .weatherApiResult;
    print(weatherApiResult);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: isLoading!
            ? Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Row(
                children: [
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * .5,
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(color: Colors.black),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight < 450
                                ? 0
                                : MediaQuery.of(context).size.height / 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: isLoading!
                              ? []
                              : [
                                  Column(
                                    children: [
                                      Text(
                                        //'ugyg',
                                        'You are riding with',
                                        style: TextStyles()
                                            .whiteTextStyle()
                                            .copyWith(
                                                fontSize: screenHeight < 450
                                                    ? 20
                                                    : 24),
                                      ),
                                      Text(
                                        //'ugyg',
                                        '${walletDetail == null ? 'Advert24' : walletDetail!['firstname']}',
                                        style: TextStyles()
                                            .whiteTextStyle()
                                            .copyWith(
                                                fontSize: screenHeight < 450
                                                    ? 22
                                                    : 24,
                                                fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(7000),
                                    child: Image.network(
                                      walletDetail == null
                                          ? ' '
                                          : 'https://central.adverts247.xyz/${walletDetail!['image']}',
                                      height: screenHeight < 450 ? 130 : 200,
                                      width: screenHeight < 450 ? 130 : 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/images/Group (6).png',
                                    height: screenHeight < 450 ? 80 : 200,
                                    width: screenHeight < 450 ? 80 : 200,
                                  ),
                                ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        width: MediaQuery.of(context).size.width * .5,
                        height: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(color: Colors.red),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight < 450
                                  ? 0
                                  : MediaQuery.of(context).size.height / 8,
                              horizontal:
                                  MediaQuery.of(context).size.height / 35),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'About Me',
                                style: TextStyles()
                                    .whiteTextStyle()
                                    .copyWith(fontSize: 24),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              aboutMeCard('Favourite Food',
                                  walletDetail!['driver']['favourite_food']),
                              const SizedBox(
                                height: 10,
                              ),
                              aboutMeCard('Favourite Hobby',
                                  walletDetail!['driver']['favourite_hobby']),
                              const SizedBox(
                                height: 10,
                              ),
                              aboutMeCard(
                                  ' Ask Me', walletDetail!['driver']['ask_me']),
                              const SizedBox(
                                height: 10,
                              ),
                              aboutMeCard('Vacation Spot',
                                  walletDetail!['driver']['vacation_spot']),
                              // aboutMeCard()
                            ],
                          ),
                        )),
                  ),
                ],
              ));
  }

  Column aboutMeCard(String firstText, SecondText) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset('assets/images/Group 48095515.svg'),
            const SizedBox(
              width: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firstText,
                  style: TextStyles().whiteTextStyle().copyWith(
                      fontSize: screenHeight < 450 ? 12 : 14,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  walletDetail == null ? 'Loading...' : SecondText,
                  style: TextStyles().whiteTextStyle().copyWith(
                      fontSize: screenHeight < 400 ? 17 : 24,
                      fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
        SizedBox(
          height: screenHeight < 450 ? 5 : 15,
        ),
        const Divider(
          height: 0.1,
          color: Color(0xffD6DDEB),
        ),
        SizedBox(
          height: screenHeight < 450 ? 5 : 15,
        ),
      ],
    );
  }

  Padding weatherWidget() {
    var now = DateTime.now();
    var formatter = DateFormat('EEEE, MMMM d, y');
    String formattedDate = formatter.format(now);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(formattedDate,
                style: TextStyles()
                    .whiteTextStyle()
                    .copyWith(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Image.asset(
                  'assets/images/brain shaped cloud.png',
                  height: 50,
                  width: 50,
                ),
                const SizedBox(
                  width: 30,
                ),
                Text(
                    (weatherApiResult['main']['temp'] - 273.15)
                            .toStringAsFixed(2) +
                        '°C',
                    style: TextStyles()
                        .whiteTextStyle()
                        .copyWith(fontSize: 22, fontWeight: FontWeight.w800))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                squareBox(
                  'HIGH/LOW',
                  (weatherApiResult['main']['temp_max'] - 273)
                          .toStringAsFixed(1) +
                      '/' +
                      (weatherApiResult['main']['temp_min'] - 273.1)
                          .toStringAsFixed(1),
                ),
                const SizedBox(
                  width: 20,
                ),
                squareBox('WIND', '${weatherApiResult['wind']['speed']}m/s')
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                squareBox('RAIN CHANCE', 'Rain Chance'),
                const SizedBox(
                  width: 20,
                ),
                squareBox(
                    'HUMIDITY', '${weatherApiResult['main']['humidity']}%')
              ],
            )
          ],
        ),
      ),
    );
  }

  Container squareBox(String topText, bottomText) {
    var height = MediaQuery.of(context).size.height;
    return Container(
        color:
            //Colors.black,
            const Color(0xff66594e),
        height: height < 500 ? 80 : 130,
        width: height < 500 ? 140 : 180,
        child: Padding(
          padding: EdgeInsets.all(height < 500 ? 10.0 : 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(topText,
                  style: TextStyles().whiteTextStyle().copyWith(
                      fontSize: height < 500 ? 10 : 15,
                      fontWeight: FontWeight.w600)),
              const SizedBox(
                height: 10,
              ),
              Text(bottomText,
                  style: TextStyles().whiteTextStyle().copyWith(
                      fontSize: height < 500 ? 15 : 23,
                      fontWeight: FontWeight.w600))
            ],
          ),
        ));
  }
}
