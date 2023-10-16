import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class LocationWesocket {
  void testWebsocket() async {
    /// Create the WebSocket channel
    final channel = WebSocketChannel.connect(
      Uri.parse('wss://ws-feed.pro.coinbase.com'),
    );

    channel.sink.add(
      jsonEncode(
        {
          "type": "subscribe",
          "channels": [
            {
              "name": "ticker",
              "product_ids": [
                "BTC-EUR",
              ]
            }
          ]
        },
      ),
    );

    /// Listen for all incoming data
    channel.stream.listen(
      (data) {
        print(data);
      },
      onError: (error) => print(error),
    );
  }

  sendLocation() async {
    final channel = WebSocketChannel.connect(
        Uri.parse('wss://streamer.lazynerdstudios.com')
            .replace(queryParameters: {
      //'access_token': '',
    }));
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final lat = position.latitude;
    final lon = position.longitude;

    // Send "driver ping" message with location data when the connection is established.
    channel.sink.add('driver ping');
    final content = {
      'driverId': '0',
      'lat': lat,
      'long': lon,
    };
    final message = jsonEncode(content);
    channel.sink.add(message);

    // Listen for "driver pong" events.
    channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      final latitude = decodedMessage['lat'];
      final longitude = decodedMessage['long'];
      print('Received driver pong: Latitude: $latitude, Longitude: $longitude');
    });

    // channel.sink.add(json.encode(data));
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void checkLocation() {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      LocationWesocket().connectToSocket(
        'wss://streamer.lazynerdstudios.com',
        50,
        position!.latitude.toString(),
        position!.longitude.toString(),
      );
      print(position == null
          ? 'Unknown'
          : 'location ${position.latitude.toString()}, ${position.longitude.toString()}');
    });
  }

  void connectToSocket(String serverUrl, driverId, latitude, lonitude) {
    // final serverUrl = 'wss://streamer.lazynerdstudios.com';
    // final driverId = 50; // Replace with the desired driver's ID
    // final latitude = 12.34; // Replace with the desired latitude
    // final longitude = 56.78; // Replace with the desired longitude
    io.Socket socket;
    socket = io.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) {
      print('Connected to the Socket.IO server');
      final roomName = 'driver-$driverId';
      socket.emit('join_room', {'roomName': roomName});
      final content = {
        'driverId': driverId,
        'lat': latitude,
        'long': lonitude,
      };

      socket!.emit('send_message', {
        'roomName': roomName,
        'message': 'fdf',
        'content': content,
      });
    });

    socket.on('driver pong', (data) {
      // Handle the received location data (latitude and longitude)
      final location = data['data'];
      print(
          'Received driver location: Latitude: ${location['lat']}, Longitude: ${location['long']}');
    });

    socket.connect();
  }
}
