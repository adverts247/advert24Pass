import 'dart:async';

import 'package:adverts247Pass/model/video_model.dart';
import 'package:adverts247Pass/services/update_app.dart';
import 'package:adverts247Pass/pre-streaming-screen/welcome_onbaording/welcome-onboarding_view.dart';
import 'package:adverts247Pass/services/network.dart/network.dart';
import 'package:adverts247Pass/services/wether_service/weather_service.dart';
import 'package:adverts247Pass/state/user_state.dart';
import 'package:adverts247Pass/ui/screen/waiting_Page.dart';

import 'package:adverts247Pass/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:adverts247Pass/tools.dart' as tools;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
        shouldPopOnError: false, onSuccess: (_, result) async {
      tools.putInStore('accessToken', result['data']['token']);
      tools.putInStore('email', body['email']);
      tools.putInStore('password', body['password']);

      await getWallet(context);
      WeatherService().getWeatherData(context);
      //    AppWebsocketService().broadcast(context);
      OtaService().checkifUpdateIsNeeded(context);
      //
      Get.to(
        const WaitingPage(),
        transition: Transition.fadeIn,
        curve: Curves.easeInOut,
        duration: const Duration(seconds: 1),
      );

      debugPrint(result);
    }, onFailure: (_, result) {
      Navigator.pop(context);

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

  Future<void> likeVideo(context, dynamic body, path) async {
    final url = Uri.parse('$path/like'); //
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
            backgroundColor: Colors.green.withOpacity(0.2),
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [],
            icon: const Icon(Icons.sentiment_very_satisfied,
                color: Color(0x15000000), size: 120),
            message: 'Liked ',
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
          boxShadow: const [],
          message: jsonDecode(response.body)['message'],
        ),
      );
    }
  }

  Future<void> disLikeVideo(context, dynamic body, path) async {
    final url = Uri.parse('$path/dislike'); //
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
            backgroundColor: Colors.green.withOpacity(0.2),
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [],
            icon: const Icon(Icons.sentiment_dissatisfied,
                color: Color(0x15000000), size: 120),
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
          boxShadow: const [],
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
        'Authorization': 'Bearer $token',
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
        'Authorization': 'Bearer $token',
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
    var uri = Uri.parse(path);

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
          'HTTP Error: ${response.statusCode} , $uri',
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

  //for ads queueimport 'dart:async';

  Future<dynamic> fetchVideo(String path, context) async {
    const maxRetries = 10;
    const retryDelay = Duration(seconds: 3);

    for (var retryCount = 0; retryCount < maxRetries; retryCount++) {
      try {
        final userState = Provider.of<UserState>(context, listen: false);
        final userData = userState.userDetails;
        final id = userData['id'].toString();
        const url = 'https://ads247-streaming.lazynerdstudios.com';
        final headers = {
          'Range': '0',
          'driver-id': id,
          'Accept': 'multipart/form-data',
        };

        final uri = Uri.parse('$path?location=3.584494,1.090932');

        http.Response response = await http.get(uri, headers: headers);

        if (response.statusCode >= 200 && response.statusCode < 300) {
          final responseBody = json.decode(utf8.decode(response.bodyBytes));
          final fileSize = responseBody['file_size'].toString();
          final sessionId = response.headers['sessionid'].toString();
          print(sessionId);

          userState.size = fileSize;
          userState.sessionId = sessionId;

          final videoUrl = '$url/${responseBody['url']}';

          var storeVideoPath = await tools.getFromStore(videoUrl);

          // check if video is on local storage
          if (storeVideoPath == null) {
            //video is not in local storage

            final filePath = await downloadVideo(videoUrl);
            await tools.putInStore(videoUrl, filePath);
            //remove from store after one week
            performFunctionAfterOneWeek(filePath);

            print('Downloaded file from: $videoUrl');
            return filePath;
          } else {
            //remove from store after one week
            performFunctionAfterOneWeek(storeVideoPath);

            //vdeo is in local storage
            return storeVideoPath;
          }
        } else {
          print(
              'HTTP Error: ${response.statusCode}, $uri, ${response.reasonPhrase}');
          return Uint8List(
              0); // Return an empty Uint8List or handle the error accordingly.
        }
      } catch (e) {
        print('Error: $e');
        if (retryCount < maxRetries - 1) {
          print('Retrying in $retryDelay...');
          await Future.delayed(retryDelay);
        }
      }
    }

    print('Max retries reached, giving up.');
    return Uint8List(
        0); // Return an empty Uint8List or handle the error accordingly.
  }

  // delete item after 7b days
  void performFunctionAfterOneWeek(String video) {
    print('Function will be performed after one week.');

    // Delay the function execution for one week
    Future.delayed(const Duration(days: 7), () {
      // Your function code here
      tools.deleteFile(video);
    });
  }

  // Future<dynamic> fetchVideo(String path, context) async {
  //   var token = await tools.getFromStore('accessToken');
  //   Completer<dynamic> completer = Completer<dynamic>();
  //   final userState = Provider.of<UserState>(context, listen: false);
  //   final userData = userState.userDetails;
  //   final id = userData['id'].toString();
  //   final url = 'https://ads247-streaming.lazynerdstudios.com';
  //   final headers = {
  //     'Range': '0',
  //     'driver-id': id,
  //     'Accept': 'multipart/form-data',
  //   };

  //   HttpRequestStreaming(
  //     path,
  //     method: 'GET',
  //     context: context,
  //     headers: headers,
  //     shouldPopOnError: false,
  //     onSuccess: (_, result) async {
  //       // ignore: avoid_print
  //       final videoUrl = '$url/${result['url']}';
  //       final filePath = await downloadVideo(videoUrl);

  //       print('Downloaded file from: $videoUrl');

  //       completer.complete(filePath);
  //     },
  //     onFailure: (_, result) {
  //       // ignore: avoid_print
  //       print(result);
  //       completer.completeError(result);
  //     },
  //   ).send();

  //   return completer.future;
  //   // }
  // }

  //for broadcast ads
  Future<dynamic> fetchBroadcastVideo(String path, context) async {
    // var path = 'https://ads247-streaming.lazynerdstudios.com/ads/${id}';
    var userData = Provider.of<UserState>(context, listen: false).userDetails;
    var headers = {
      'Range': '0',
      'driver-id': userData['id'].toString(),
      'Accept': 'multipart/form-data'
    };
    print(headers);

    var uri = Uri.parse('$path?location=3.584494,1.090932');
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

        var filePath = await downloadVideo(
            "https://ads247-streaming.lazynerdstudios.com/${responseBody['url']}");
        print(
            "https://ads247-streaming.lazynerdstudios.com/${responseBody['url']}");

        return filePath;
      } else {
        print('HTTP Error: ${response.statusCode}');
        print(
          'HTTP Error: ${response.statusCode} , $uri',
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
        final fileName = '${DateTime.now().toIso8601String()}.mp4';

        // Combine the directory path and the file name to create a complete file path
        final filePath = '${appDir.path}/$fileName';

        // Write the downloaded video data to the file
        File videoFile = File(filePath);
        await videoFile.writeAsBytes(response.bodyBytes, flush: true);
        print('download $filePath');

        // Return the file path of the downloaded video
        return filePath;
      } catch (e) {
        // Handle errors (e.g., file write error)
        print('Error writing video file: $e');
        return 'nhh';
      }
    } else {
      // Handle HTTP request error
      print('HTTP request error: ${response.statusCode}');
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
        'http://178.128.163.25:4036/stream?path=$path&sessionId=$sessionId');

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
  Future<void> rateVideo(
    context,
    dynamic body,
  ) async {
    final url =
        Uri.parse('https://ads247-streaming.lazynerdstudios.com/rate-ad'); //
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
            backgroundColor: Colors.green.withOpacity(0.2),
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [],
            message: 'Thank you for rating this ad',
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
          boxShadow: const [],
          message: jsonDecode(response.body)['message'],
        ),
      );
    }
  }

  //check weather
}
