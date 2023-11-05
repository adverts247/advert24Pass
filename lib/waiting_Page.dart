import 'dart:convert';
import 'package:adverts247Pass/state/user_state.dart';
import 'package:adverts247Pass/themes.dart';
import 'package:adverts247Pass/broadcast_videoplayer.dart';

import 'package:adverts247Pass/video_player1.dart';
import 'package:adverts247Pass/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WaitingPage extends StatefulWidget {
  WaitingPage({Key? key}) : super(key: key);

  @override
  _WaitingPageState createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {
  @override
  void initState() {
    checkIfisFirstTime();
    super.initState();
  }

  Future<void> checkIfisFirstTime() async {
    var isFirstTime =
        await Provider.of<UserState>(context, listen: false).isFirstTime;
    print(isFirstTime);

    if (isFirstTime == null) {
      loader().circularModalLoading(context);
      Future.delayed(Duration(seconds: 6), () {
        Navigator.pop(context);
      });
    } else {
      Provider.of<UserState>(context, listen: false).isFirstTime = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // var userData = Provider.of<UserState>(context, listen: false).userDetails;
    // print('dfgfg ${userData}');
    // connectToDriverChannel(userData['id']); // Replace with the actual user ID
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * .4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset('assets/images/Group (6).png'),
                  SizedBox(height: 5),
                  Text(
                    '...reach your true target',
                    textAlign: TextAlign.right,
                    style: TextStyles().whiteTextStyle().copyWith(fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Connecting ',
                    style: TextStyles().whiteTextStyle().copyWith(fontSize: 20),
                  ),
                  TextSpan(
                    text: '....',
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
