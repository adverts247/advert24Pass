import 'package:adverts247Pass/ui/screen/video_player1.dart';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketListener extends StatefulWidget {
  @override
  _WebSocketListenerState createState() => _WebSocketListenerState();
}

class _WebSocketListenerState extends State<WebSocketListener> {
  final channel = IOWebSocketChannel.connect(
      'ws://echo.websocket.org'); // Replace with your WebSocket URL

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: channel.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == 'true') {
            // Replace 'true' with the value you're expecting
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      VideoPlayerApp()), // Replace NextPage with your next page
            );
          }
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('WebSocket Listener'),
          ),
          body: Center(
            child: Text(snapshot.hasData ? '${snapshot.data}' : 'No data'),
          ),
        );
      },
    );
  }
}
