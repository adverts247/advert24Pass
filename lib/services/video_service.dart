import 'dart:async';

import 'package:advert24pass/about_me.dart';
import 'package:advert24pass/model/video_model.dart';
import 'package:advert24pass/services/network.dart/network.dart';
import 'package:advert24pass/services/wether_service/weather_service.dart';
import 'package:advert24pass/state/user_state.dart';
import 'package:advert24pass/video_player1.dart';
import 'package:advert24pass/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:advert24pass/tools.dart' as tools;
import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';

class VideoService {
  login(context, dynamic body) {
    // AboutMePage();
    loader().showImageDialog(context);
    HttpRequest('auth/login',
        context: context,
        body: body,
        loader: LoaderType.popup,
        shouldPopOnError: false, onSuccess: (_, result) async {
      tools.putInStore('accessToken', result['data']['token']);

      await getWallet(context);
      WeatherService().getWeatherData(context);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => VideoPlayerApp()));

      debugPrint(result);
    }, onFailure: (_, result) {
      //Navigator.pop(context);

      debugPrint(result);
      return;
    }).send();
  }

  Future<dynamic> getWallet(
    context,
  ) async {
    var token = await tools.getFromStore('accessToken');
    print(token);
    Completer<dynamic> completer = Completer<dynamic>();

    //Loaders().showModalLoading(context);
    HttpRequest('/auth',
        context: context,
        headers: {
          'Authorization': 'Bearer $token',
        },

        // loader: LoaderType.popup,
        shouldPopOnError: false, onSuccess: (_, result) {
      Provider.of<UserState>(context, listen: false)
          .getUserData(result['data']);
      print(result['data']);
      var state = Provider.of<UserState>(context, listen: false);
      state.userDetails = result['data'];
      //   print(await result['data']);

      completer
          .complete(result['data']); // Complete the completer with the result
    }, onFailure: (_, result) {
      //Navigator.pop(context);
      debugPrint(result);
      completer.completeError(
          result['data']); // Complete the completer with an error
    }).send();

    return completer
        .future; // Return the completer's future for handling results
  }

  // //verify Bvn
  // likeVideo(context, dynamic body) async {
  //   var token = await tools.getFromStore('accessToken');
  //   //  Loaders().showModalLoading(context);
  //   HttpRequest('/${body['Id']}/like',
  //       context: context,
  //       headers: {
  //         'Authorization': 'Bearer ${token}',
  //       },
  //       body: body,
  //       shouldPopOnError: false, onSuccess: (_, result) async {
  //     print(result);

  //     tools.getFromStore('accessToken');
  //     debugPrint(result);
  //   }, onFailure: (_, result) {
  //     //Navigator.pop(context);

  //     return;
  //   }).send();
  // }

  void likeVideo(context, dynamic body, path) async {
    final url = Uri.parse('${path}/like'); //
    print(url);
    print(body);

    // Replace this with the data you want to send in the POST request

    final response = await http.post(
      url,
      body: body,
    );

    if (response.statusCode.toString().startsWith('2')) {
      // Successful POST request
      print('Response data: ${response.body}');

      showTopSnackBar(
          Overlay.of(context!),
          CustomSnackBar.success(
            backgroundColor: Colors.green.withOpacity(0.2)!,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [],
            message: 'Liked',
          ));
    } else {
      // Error handling
      print('Failed to make POST request: ${response.statusCode}');
      print('Response body: ${response.body}');
      showTopSnackBar(
        Overlay.of(context!),
        CustomSnackBar.error(
          backgroundColor: Colors.black26,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [],
          message: jsonDecode(response.body)['message'],
        ),
      );
    }
  }

  void disLikeVideo(context, dynamic body, path) async {
    final url = Uri.parse('${path}/dislike'); //
    print(url);
    print(body);

    // Replace this with the data you want to send in the POST request

    final response = await http.post(
      url,
      body: body,
    );

    if (response.statusCode.toString().startsWith('2')) {
      // Successful POST request
      print('Response data: ${response.body}');

      showTopSnackBar(
          Overlay.of(context!),
          CustomSnackBar.success(
            backgroundColor: Colors.green.withOpacity(0.2)!,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [],
            message: jsonDecode(response.body)['message'],
          ));
    } else {
      // Error handling
      print('Failed to make POST request: ${response.statusCode}');
      print('Response body: ${response.body}');
      showTopSnackBar(
        Overlay.of(context!),
        CustomSnackBar.error(
          backgroundColor: Colors.black26,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [],
          message: jsonDecode(response.body)['message'],
        ),
      );
    }
  }

  // disLiikeVideo(context, dynamic body) async {
  //   var token = await tools.getFromStore('accessToken');
  //   //  Loaders().showModalLoading(context);
  //   HttpRequest('/onboard/vehicle',
  //       context: context,
  //       headers: {
  //         'Authorization': 'Bearer ${token}',
  //       },
  //       body: body,
  //       loader: LoaderType.popup,
  //       shouldPopOnError: false, onSuccess: (_, result) async {
  //     tools.getFromStore('accessToken');
  //     debugPrint(result);
  //   }, onFailure: (_, result) {
  //     //Navigator.pop(context);

  //     return;
  //   }).send();
  // }

  Future<List<VideoModel>> getNotification(context) async {
    var token = await tools.getFromStore('accessToken');
    Completer<List<VideoModel>> completer = Completer<List<VideoModel>>();

    HttpRequest(
      '/ad-queue',
      method: 'GET',
      context: context,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      shouldPopOnError: false,
      onSuccess: (_, result) async {
        // ignore: avoid_print
        print(result);
        List<VideoModel> notificationList = result
            .map<VideoModel>((element) => VideoModel.fromJson(element))
            .toList();

        completer.complete(notificationList);
      },
      onFailure: (_, result) {
        // ignore: avoid_print
        print(result);
        completer.completeError(result);
      },
    ).send();

    return completer.future;
    // }
  }

  Future<List<VideoModel>> getVideo(context) async {
    var token = await tools.getFromStore('accessToken');
    Completer<List<VideoModel>> completer = Completer<List<VideoModel>>();

    HttpRequest(
      '/ad-queue',
      method: 'GET',
      context: context,
      headers: {
        'Authorization': 'Bearer ${token}',
      },
      shouldPopOnError: false,
      onSuccess: (_, result) async {
        // ignore: avoid_print
        print(result);
        List<VideoModel> notificationList = result
            .map<VideoModel>((element) => VideoModel.fromJson(element))
            .toList();

        completer.complete(notificationList);
      },
      onFailure: (_, result) {
        // ignore: avoid_print
        print(result);
        completer.completeError(result);
      },
    ).send();

    return completer.future;
    // }
  }

  Future<Uint8List> fetchData(String path, context) async {
    var userData = Provider.of<UserState>(context, listen: false).userDetails;

    var headers = {
      'Range': '0',
      'driver-id': userData['id'].toString(),
      'Accept': 'multipart/form-data'
    };

    //var uri = Uri.parse('${path}?location=3.584494,1.090932');
    var uri = Uri.parse('${path}');

    var request = http.Request('GET', uri);
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode.toString().startsWith('2')) {
        final List<int> byteList = await response.stream.toBytes();
        print('HTTP Error: ${response.statusCode}');
        return Uint8List.fromList(byteList);
      } else {
        print(
          'HTTP Error: ${response.statusCode} , ${uri}',
        );
        print(response.reasonPhrase);

        return Uint8List(
            0); // Return an empty Uint8List or handle the error accordingly.
      }
    } catch (e) {
      print('Error: $e');

      return Uint8List(
          0); // Return an empty Uint8List or handle the error accordingly.
    }
  }

  Future<dynamic> fetchVideo(String path, context) async {
    var userData = Provider.of<UserState>(context, listen: false).userDetails;

    var headers = {
      'Range': '0',
      'driver-id': userData['id'].toString(),
      'Accept': 'multipart/form-data'
    };
    print(headers);

    var uri = Uri.parse('${path}?location=3.584494,1.090932');
    print(uri);

    var request = http.Request('GET', uri);
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode.toString().startsWith('2')) {
        var responseBody = json.decode(await response.stream.bytesToString());
        print(response.headers);
        Provider.of<UserState>(context, listen: false).size =
            responseBody['file_size'].toString();

        Provider.of<UserState>(context, listen: false).sessionId =
            response.headers['sessionid'].toString();
        print(responseBody);
        print(' sessionId : ${response.headers['sessionid'].toString()}');

        // var video = await fetchVideoSecondEndpoint(
        //     path, responseBody['file_path'], response.headers['sessionid']);

        // ignore: avoid_print

        //    print(byteList);
        //print('HTTP Error: ${response.statusCode}');
        // final tempDir = await getApplicationDocumentsDirectory();
        // final file = File('${tempDir.path}/video.mp4');
        // // File().writeAsBytes(bytes)
        // print(file.path);
        // var videoFile = await file.writeAsBytes(byteList);
        // print('converted${videoFile.path}');
        var filePath = await downloadVideo(
            "https://streamer.lazynerdstudios.com/${responseBody['url']}");
        print("https://streamer.lazynerdstudios.com/${responseBody['url']}");

        return filePath;
      } else {
        print('HTTP Error: ${response.statusCode}');
        print(
          'HTTP Error: ${response.statusCode} , ${uri}',
        );
        print(response.reasonPhrase);
        return Uint8List(
            0); // Return an empty Uint8List or handle the error accordingly.
      }
    } catch (e) {
      print('Error: $e');
      return Uint8List(
          0); // Return an empty Uint8List or handle the error accordingly.
    }
  }

  //download video
  Future<String> downloadVideo(String videoUrl) async {
    final response = await http.get(Uri.parse(videoUrl));

    if (response.statusCode == 200) {
      try {
        // Get the app's documents directory
        final appDir = await getApplicationDocumentsDirectory();

        // Generate a unique file name for the downloaded video
        final fileName = DateTime.now().toIso8601String() + ".mp4";

        // Combine the directory path and the file name to create a complete file path
        final filePath = "${appDir.path}/$fileName";

        // Write the downloaded video data to the file
        File videoFile = File(filePath);
        await videoFile.writeAsBytes(response.bodyBytes, flush: true);
        print('download ${filePath}');

        // Return the file path of the downloaded video
        return filePath;
      } catch (e) {
        // Handle errors (e.g., file write error)
        print("Error writing video file: $e");
        return 'nhh';
      }
    } else {
      // Handle HTTP request error
      print("HTTP request error: ${response.statusCode}");
      return 'nhn';
    }
  }

  Future<dynamic> fetchVideoSecondEndpoint(
    String initailPath,
    path,
    sessionId,
  ) async {
    var headers = {
      'Range': '0',
      //  'driver-id': '1',
    };

    var uri = Uri.parse(
        'http://178.128.163.25:4036/stream?path=${path}&sessionId=${sessionId}');

    var request = http.Request('GET', uri);
    request.headers.addAll(headers);
    request.body = jsonEncode({}); // Encode the request body as JSON

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode.toString().startsWith('2')) {
        print('yes');
        // var responseBody = json.decode(await response.stream.bytesToString());
        // ignore: avoid_print
        print(response);
        final List<int> byteList = await response.stream.toBytes();

        print(byteList);
        print('HTTP Error: ${response.statusCode}second');
        final tempDir = await getApplicationDocumentsDirectory();
        final file = File('${tempDir.path}/video.mp4');
        // File().writeAsBytes(bytes)
        print(file.path);
        var videoFile = await file.writeAsBytes(byteList);
        print('converted${videoFile.path}');

        return file.path;
      } else {
        print('HTTP Error: ${response.statusCode}second');
        print(response.reasonPhrase);
        return Uint8List(
            0); // Return an empty Uint8List or handle the error accordingly.
      }
    } catch (e) {
      print('Error: $e');
      return Uint8List(
          0); // Return an empty Uint8List or handle the error accordingly.
    }
  }

  ///////rate ads ///////////////////////////////////////
  ///
  void rateVideo(
    context,
    dynamic body,
  ) async {
    final url = Uri.parse('https://streamer.lazynerdstudios.com/rate-ad'); //
    print(url);
    print(body);

    // Replace this with the data you want to send in the POST request

    final response = await http.post(
      url,
      body: body,
    );

    if (response.statusCode.toString().startsWith('2')) {
      // Successful POST request
      print('Response data: ${response.body}');

      showTopSnackBar(
          Overlay.of(context!),
          CustomSnackBar.success(
            backgroundColor: Colors.green.withOpacity(0.2)!,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [],
            message: 'Thank you for rating this ads ',
          ));
    } else {
      // Error handling
      print('Failed to make POST request: ${response.statusCode}');
      print('Response body: ${response.body}');
      showTopSnackBar(
        Overlay.of(context!),
        CustomSnackBar.error(
          backgroundColor: Colors.black26,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [],
          message: jsonDecode(response.body)['message'],
        ),
      );
    }
  }

  //check weather
}
