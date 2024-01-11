import 'dart:async';
import 'dart:convert';

import 'package:adverts247Pass/pre-streaming-screen/welcome_onbaording/welcome-onboarding_view.dart';
import 'package:adverts247Pass/state/location_weather_state.dart';
import 'package:adverts247Pass/state/user_state.dart';
import 'package:adverts247Pass/ui/screen/video_player1.dart';
import 'package:adverts247Pass/ui/screen/waiting_Page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:geolocator/geolocator.dart';

class AppWebsocketService {
  Future<void> testWebsocket() async {
    /// Create the WebSocket channel
    final channel = WebSocketChannel.connect(
      Uri.parse('wss://ws-feed.pro.coinbase.com'),
    );

    channel.sink.add(
      jsonEncode(
        {
          'type': 'subscribe',
          'channels': [
            {
              'name': 'ticker',
              'product_ids': [
                'BTC-EUR',
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
        Uri.parse('wss://streamer.adverts247.xyz').replace(queryParameters: {
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

  void checkLocation(context) {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    var userData = Provider.of<UserState>(context, listen: false).userDetails;
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      //This function passes the latitude and logitude in the weatherPosition state
      Provider.of<WeatherLocationState>(context, listen: false).long =
          position!.longitude.toString();
      Provider.of<WeatherLocationState>(context, listen: false).lat =
          position.latitude.toString();

      print(position == null
          ? 'Unknown'
          : 'location ${position.latitude.toString()}, ${position.longitude.toString()}');
    });
  }

  ///
  ///
  ///webso cket to controller the app
  ///
  void broadcast(
    context,
  ) {
    var userData = Provider.of<UserState>(context, listen: false).userDetails;
    print('dfgfg $userData');
    var userId = userData['driver']['id'];

    IO.Socket socket = IO.io('wss://streamer.adverts247.xyz', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) {
      print('Connecteded');
      Provider.of<UserState>(context, listen: false).isFirstTime = false;

      // Navigator.of(context, rootNavigator: true).pop();
      socket.emit('watch driver', userId);
    });

    socket.on('stop-stream', (data) {
      // Handle stop-stream event
      // print('Received stop-stream event');
      // Provider.of<UserState>(context, listen: false).canStream = false;
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const WaitingPage()));
    });

    socket.on('start-stream', (data) {
      // Handle start-stream event
      print('Received start-stream event');
      Provider.of<UserState>(context, listen: false).canStream = true;

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const PreStreamingWelcomePage()));

      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => const VideoPlayerApp()));
    });

    socket.on('ad-broadcast', (data) {
      print('ad-broadcast');
      print(data);
      var canUserStream =
          Provider.of<UserState>(context, listen: false).canStream;

      print(canUserStream);
      var adsData = jsonDecode(data);

      // if (canUserStream!) {
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) =>
      //               BroadCastVideoPlayer(path: adsData['content']['path'])));
      // } else {}
    });
  }

  Future<Position?> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Handle the case where the user denied location permission permanently
        print('Location permission denied forever');
        return null;
      } else if (permission == LocationPermission.denied) {
        // Handle the case where the user denied location permission
        print('Location permission denied');
        return null;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      print(e);
      return null;
    }
  }

  ///check code
  ///
  connectToSocket(context, dynamic lat, long) {
    var userData = Provider.of<UserState>(context, listen: false).userDetails;
    final serverUrl = 'wss://streamer.adverts247.xyz';
    final driverId =
        userData['driver']['id']; // Replace with the desired driver's ID
    final latitude = lat; // Replace with the desired latitude
    final longitude = long; // Replace with the desired longitude

    IO.Socket socket;
    socket = IO.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) {
      print('Connected to the Socket.IO server');

      final content = {
        'driverId': driverId,
        'lat': latitude,
        'long': longitude,
      };
      print(content);

      socket.emit('driver ping', {
        // 'roomName': roomName,
        jsonEncode(content),
      });
      print('yes');
    });

    // socket.on('driver pong', (data) {
    //   // Handle the received location data (latitude and longitude)
    //   final location = data['data'];
    //   print(
    //       'Received driver location: Latitude: ${location['lat']}, Longitude: ${location['long']}');
    // });

    socket.connect();
  }
}
