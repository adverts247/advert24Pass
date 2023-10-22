import 'package:advert24pass/state/location_weather_state.dart';
import 'package:advert24pass/state/user_state.dart';
import 'package:advert24pass/themes.dart';
import 'package:advert24pass/widget/loader.dart';
import 'package:flutter/material.dart ';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AboutMePage extends StatefulWidget {
  const AboutMePage({super.key});

  @override
  State<AboutMePage> createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  bool? isLoading = true;

  Map<String, dynamic>? walletDetail;

  var weatherApiResult;
  @override
  void initState() {
    getWalletBalance();
    super.initState();
  }

  getWalletBalance() async {
    setState(() {
      isLoading = true;
    });
    walletDetail =
        await Provider.of<UserState>(context, listen: false).userDetails;
    print(walletDetail);

    // get weather from state
    weatherApiResult =
        await Provider.of<WeatherLocationState>(context, listen: false)
            .weatherApiResult;
    print(weatherApiResult);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    print(MediaQuery.of(context).size.width);
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: isLoading!
            ? Text('fef')
            : Row(
                children: [
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * .5,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(color: Colors.black),
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
                                  Text(
                                    //'ugyg',
                                    'You are riding with   ${walletDetail == null ? 'Advert24' : walletDetail!['firstname']}',
                                    style: TextStyles()
                                        .whiteTextStyle()
                                        .copyWith(fontSize: 24),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(7000),
                                    child: Image.network(
                                      walletDetail == null
                                          ? ' '
                                          : 'https://ads24.lazynerdstudios.com/${walletDetail!['image']}',
                                      height: screenHeight < 450 ? 130 : 200,
                                      width: screenHeight < 450 ? 130 : 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/images/Group (6).png',
                                    height: screenHeight < 450 ? 70 : 200,
                                    width: screenHeight < 450 ? 70 : 200,
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
                        decoration: BoxDecoration(color: Colors.red),
                        child: true == true
                            ? weatherWidget()
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight < 450
                                        ? 0
                                        : MediaQuery.of(context).size.height /
                                            8,
                                    horizontal:
                                        MediaQuery.of(context).size.height /
                                            35),
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
                                    SizedBox(
                                      height: 40,
                                    ),
                                    aboutMeCard('FirstName',
                                        walletDetail!['firstname']),
                                    aboutMeCard(
                                        'LastName', walletDetail!['lastname']),
                                    aboutMeCard(
                                        'Gender', walletDetail!['gender']),
                                    // aboutMeCard()
                                  ],
                                ),
                              )),
                  ),
                ],
              ));
  }

  aboutMeCard(String firstText, SecondText) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset('assets/images/Group 48095515.svg'),
            SizedBox(
              width: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firstText,
                  style: TextStyles().whiteTextStyle().copyWith(fontSize: 16),
                ),
                Text(
                  walletDetail == null ? 'Loading...' : SecondText,
                  style: TextStyles().greyTextStyle400().copyWith(fontSize: 14),
                )
              ],
            )
          ],
        ),
        SizedBox(
          height: screenHeight < 450 ? 5 : 15,
        ),
        Divider(
          height: 0.1,
          color: Color(0xffD6DDEB),
        ),
        SizedBox(
          height: screenHeight < 450 ? 5 : 15,
        ),
      ],
    );
  }

  weatherWidget() {
    var now = DateTime.now();
    var formatter = DateFormat('EEEE, MMMM d, y');
    String formattedDate = formatter.format(now);
    return Padding(
      padding:
      
      
       const EdgeInsets.all(20.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formattedDate,
                style: TextStyles()
                    .whiteTextStyle()
                    .copyWith(fontSize: 22, fontWeight: FontWeight.w800)),
            Row(
              children: [
                SvgPicture.asset('assets/login/brain shaped cloud.svg'),
                Text(
                    (weatherApiResult['main']['temp'] - 273.15).toStringAsFixed(2) +
                        '°C',
                    style: TextStyles()
                        .whiteTextStyle()
                        .copyWith(fontSize: 22, fontWeight: FontWeight.w800))
              ],
            ),
            Row(
              children: [
                squareBox(
                  'High/Low',
                    (weatherApiResult['main']['temp_max'] - 273).toStringAsFixed(1) + '/'+ (weatherApiResult['main']['temp_min'] - 273.1).toStringAsFixed(1),
                    ),
                SizedBox(
                  width: 20,
                ),
                squareBox('winds',
                    weatherApiResult['wind']['speed'].toString() + 'm/s')
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                squareBox('Rain Chnage', 'Rain Change'),
                SizedBox(
                  width: 20,
                ),
                squareBox('Humidity',
                    weatherApiResult['main']['humidity'].toString() + '%')
              ],
            )
          ],
        ),
      ),
    );
  }

  squareBox(String topText, bottomText) {
    return Container(
        color: Color.fromARGB(104, 82, 82, 92),
        height: 120,
        width: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(topText,
                style: TextStyles()
                    .whiteTextStyle()
                    .copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(
              height: 10,
            ),
            Text(bottomText,
                style: TextStyles()
                    .whiteTextStyle()
                    .copyWith(fontSize: 16, fontWeight: FontWeight.w600))
          ],
        ));
  }
}
