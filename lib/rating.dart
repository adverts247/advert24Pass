import 'package:adverts247Pass/about_me.dart';
import 'package:adverts247Pass/services/video_service.dart';
import 'package:adverts247Pass/state/user_state.dart';
import 'package:adverts247Pass/themes.dart';
import 'package:adverts247Pass/broadcast_videoplayer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:adverts247Pass/widget/button.dart';
import 'package:adverts247Pass/widget/input_textform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  TextEditingController? loginEmail;
  TextEditingController? password;

  double? ratingValue = 0;
  @override
  void initState() {
    loginEmail = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height > 450
                  ? MediaQuery.of(context).size.height * .7
                  : MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width * .7,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height > 450
                        ? MediaQuery.of(context).size.height * .7
                        : MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width * .7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          'assets/login/top-illustration.svg',
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height > 450
                        ? MediaQuery.of(context).size.height * .7
                        : MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width * .7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                            'assets/login/bottom-illustration.svg'),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                     // height: MediaQuery.of(context).size.height * .5,
                      width: MediaQuery.of(context).size.width * .58,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.grey.withOpacity(0.08), // Shadow color
                            spreadRadius: 5, // How much the shadow spreads
                            blurRadius: 9, // How blurry the shadow is
                            offset: Offset(0, 2), // Offset of the shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Thank You For Watching',
                                style: TextStyles().whiteTextStyle().copyWith(
                                    fontSize: 20, fontWeight: FontWeight.w800),
                              ),
                              // SizedBox(
                              //   height: 13,
                              // ),
                              // Text(
                              //   'Login your details',
                              //   style: TextStyles().greyTextStyle400().copyWith(
                              //         fontSize: 16,
                              //       ),
                              // ),
                              SizedBox(
                                height: 50,
                              ),
                              Text(
                                'Please rate the last Ad ',
                                style: TextStyles().greyTextStyle400().copyWith(
                                      fontSize: 20,
                                    ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              RatingBar.builder(
                                initialRating: 3,
                                minRating: 1,
                                unratedColor: Colors.white,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                  setState(() {
                                    ratingValue = rating;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                width: 150,
                                child: MyButton(
                                  text: 'Submit',
                                  onPressed: () async {
                                    var sessionId =
                                        await Provider.of<UserState>(context,
                                                listen: false)
                                            .sessionId;
                                    var body = {
                                      "sessionId": sessionId.toString(),
                                      "rating": ratingValue.toString()
                                    };
                                    print(body);
                                    VideoService().rateVideo(
                                      context,
                                      body,
                                    );
                                    //LocationWesocket().checkLocation();

                                    // showTopSnackBar(
                                    //     Overlay.of(context!),
                                    //     CustomSnackBar.success(
                                    //       backgroundColor:
                                    //           Colors.green.withOpacity(0.2)!,
                                    //       borderRadius:
                                    //           BorderRadius.circular(5),
                                    //       boxShadow: [],
                                    //       message:
                                    //           'Thank you for rating this ads ',
                                    //     ));

                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             VideoPlayerApp()));
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
