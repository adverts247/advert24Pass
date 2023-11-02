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
  @override
  State<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {
  @override
  void initState() {
    checkIfisFirstTime();
    // TODO: implement initState
    super.initState();
  }

  Future<void> checkIfisFirstTime() async {
    var isFirstTime =
        await Provider.of<UserState>(context, listen: false).isFirstTime;
    print(isFirstTime);

    if (isFirstTime == null) {
      loader().circularModalLoading(context);
    } else {
      Provider.of<UserState>(context, listen: false).isFirstTime = false;
    }
  }

  void connectToDriverChannel(int userId) {
    IO.Socket socket =
        IO.io('wss://ads247-streaming.lazynerdstudios.com', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) {
      print('Connected');
      Provider.of<UserState>(context, listen: false).isFirstTime = false;
      

      Navigator.of(context, rootNavigator: true).pop();
      socket.emit('watch driver', userId);
    });

    socket.on('stop-stream', (data) {
      // Handle stop-stream event
      print('Received stop-stream event');
      Provider.of<UserState>(context, listen: false).canStream = false;
    });

    socket.on('start-stream', (data) {
      // Handle start-stream event
      print('Received start-stream event');
      Provider.of<UserState>(context, listen: false).canStream = true;

      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => VideoPlayerApp()));
    });

    socket.on('ad-broadcast', (data) {
      print('ad-broadcast');
      print(data);
      var canUserStream =
          Provider.of<UserState>(context, listen: false).canStream;

      print(canUserStream);
      var adsData = jsonDecode(data);

      if (canUserStream!) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BroadCastVideoPlayer(path: adsData['content']['path'])));
      } else {}
    });
  }

  Widget build(BuildContext context) {
    var userData = Provider.of<UserState>(context, listen: false).userDetails;
    print('dfgfg ${userData}');
    connectToDriverChannel(userData['id']); // Replace with the actual user ID
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/Group (6).png'),
              SizedBox(
                height: 20,
              ),
              Text(
                'Connecting ....',
                style: TextStyles().whiteTextStyle().copyWith(fontSize: 20),
              )
            ],
          )),
    );
  }
}
