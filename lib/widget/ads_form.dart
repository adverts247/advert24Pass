import 'package:adverts247Pass/about_me.dart';
import 'package:adverts247Pass/services/video_service.dart';
import 'package:adverts247Pass/themes.dart';
import 'package:adverts247Pass/broadcast_videoplayer.dart';
import 'package:adverts247Pass/video_player1.dart';
import 'package:adverts247Pass/websocket.dart';
import 'package:adverts247Pass/widget/button.dart';
import 'package:adverts247Pass/widget/input_textform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdsFormPage extends StatefulWidget {
  const AdsFormPage({super.key});

  @override
  State<AdsFormPage> createState() => _AdsFormPageState();
}

class _AdsFormPageState extends State<AdsFormPage> {
  TextEditingController? loginEmail;
  TextEditingController? password;
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
          child: Center(
            child: Container(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width * .58,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                                'Welcome Back',
                                style: TextStyles()
                                    .blackTextStyle700()
                                    .copyWith(
                                        fontSize: 23,
                                        fontWeight: FontWeight.w800),
                              ),
                              SizedBox(
                                height: 13,
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              OutlineInput(
                                labelText: 'Email',
                                controller: loginEmail,
                              ),
                              SizedBox(
                                height: 23,
                              ),
                              OutlineInput(
                                labelText: 'Age',
                                controller: password,
                              ),
                              SizedBox(
                                height: 23,
                              ),
                              MyButton(
                                text: 'Submit',
                                onPressed: () {
                                  var body = {
                                    // 'email': loginEmail?.text,
                                    // 'password': password?.text

                                    'email': 'tested@test.com',
                                    'password': '12345678'
                                  };
                                  print(body);
                                  VideoService().login(context, body);
                                  //LocationWesocket().checkLocation();

                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             VideoPlayerApp()));
                                },
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
