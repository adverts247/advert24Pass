import 'package:advert24pass/themes.dart';
import 'package:advert24pass/video_player1.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WaitingPage extends StatefulWidget {
  @override
  State<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {
  void connectToDriverChannel(String userId) {
    IO.Socket socket =
        IO.io('wss://streamer.lazynerdstudios.com', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) {
      print('Connected');
      socket.emit('watch driver', [userId]);
    });

    socket.on('stop-stream', (data) {
      // Handle stop-stream event
      print('Received stop-stream event');
    });

    socket.on('start-stream', (data) {
      // Handle start-stream event
      print('Received start-stream event');

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => VideoPlayerApp()));
    });
  }

  @override
  Widget build(BuildContext context) {
    connectToDriverChannel('26'); // Replace with the actual user ID
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
