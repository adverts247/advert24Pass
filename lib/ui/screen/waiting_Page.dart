import 'package:adverts247Pass/services/websocket.dart';
import 'package:adverts247Pass/state/user_state.dart';
import 'package:adverts247Pass/themes.dart';

import 'package:adverts247Pass/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaitingPage extends StatefulWidget {
  const WaitingPage({Key? key}) : super(key: key);

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
        Provider.of<UserState>(context, listen: false).isFirstTime;
    print(isFirstTime);

    if (isFirstTime == null) {
      loader().circularModalLoading(context);
      Future.delayed(const Duration(seconds: 6), () {
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
                    style: TextStyles().whiteTextStyle().copyWith(fontSize: 17),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Connecting ',
                    style: TextStyles().whiteTextStyle().copyWith(fontSize: 20),
                  ),
                  const TextSpan(
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
