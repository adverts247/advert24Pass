import 'package:advert24pass/state/user_state.dart';
import 'package:advert24pass/themes.dart';
import 'package:advert24pass/widget/loader.dart';
import 'package:flutter/material.dart ';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AboutMePage extends StatefulWidget {
  const AboutMePage({super.key});

  @override
  State<AboutMePage> createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  bool? isLoading = true;

  Map<String, dynamic>? walletDetail;
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
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width * .5,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(color: Colors.white),
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
                                          .blackTextStyle700()
                                          .copyWith(fontSize: 24),
                                    ),
                                    ClipRRect( 
                                      borderRadius: BorderRadius.circular(7000),
                                      child: Image.network(
                                        walletDetail == null ? ' ' : 
                                         'https://ads24.lazynerdstudios.com/${walletDetail!['image']}',
                                        height: screenHeight < 450 ? 130 : 200,
                                        width: screenHeight < 450 ? 130 : 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Image.asset(
                                      'assets/images/Untitled-1 1.png',
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
                          decoration: BoxDecoration(
                              color: Color.fromARGB(97, 244, 231, 231)),
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
                                      .blackTextStyle700()
                                      .copyWith(fontSize: 24),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                aboutMeCard('FirstName' ,  walletDetail!['firstname']),
                                aboutMeCard('LastName' ,  walletDetail!['lastname']),
                                aboutMeCard('Gender' ,  walletDetail!['gender']),
                               // aboutMeCard()
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
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
                  style:
                      TextStyles().blackTextStyle400().copyWith(fontSize: 16),
                ),
                Text(
                 walletDetail == null ? 'Loading...': SecondText,
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
}
