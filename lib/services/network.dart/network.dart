// base file for network request
// Include show modal of two types (modal and snack)
// making a post request ( also surports file uploading )
// supports online and offline
// print(await http.read('http://example.com/foobar.txt'));

import 'dart:async';

import 'package:adverts247Pass/ui/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

// dio implementation
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import 'package:adverts247Pass/tools.dart' as tools;

// ignore: ant_identifier_names
const String BACKEND_URL = 'https://central.adverts247.xyz/api/v1/driver/';
//https://ads247-center.lazynerdstudios.com/

//central.adverts247.xyz/
//central.adverts247.xyz

//178.128.163.25

//  live ip 138.68.168.255
// test ip :  46.101.94.15

enum NetworkStatus { success, failure, error, redirect }

enum LoaderType {
  popup,
  snack,
  sheet,
}

class NetworkResponse {
  NetworkResponse({this.headers, this.body, this.status, this.statusCode});
  final body;
  final Headers? headers;
  final NetworkStatus? status;
  final int? statusCode;
}

typedef NetworkCallback = Future<bool>? Function(
    NetworkResponse response, dynamic result);

typedef NetworkSuccessCallback = void Function(
    NetworkResponse response, dynamic result);

class HttpRequest {
  HttpRequest(
    this.url, {
    this.method = 'GET',
    this.baseUrl = BACKEND_URL,
    this.body,
    this.loader,
    this.onSuccess,
    this.onRedirect,
    this.loadingMessage = 'Loading',
    this.onFailure,
    this.onError,
    this.timeout = 1000000,
    this.context,
    this.files,
    this.post,
    this.isPut,
    this.isPatch,
    this.useCache = false,
    this.forceRefresh = false,
    this.silent = false,
    this.shouldPopOnError = true,
    this.ignoreToken = false,
    this.cacheTimeout = 20,
    Map<String, String>? headers,
  }) {
    _headers.addAll(headers ?? {});
  }

  /// url: can be either full path or not
  /// if path ins't full, if will be concatinated to the [BASE_URL]
  final String url;
  final String baseUrl;
  final String loadingMessage;

  final bool silent;
  final bool shouldPopOnError;

  /// method used in request
  String method;

  final bool? post;
  final bool? isPut;
  final bool? isPatch;

  final dynamic body;

  // files to be uploaded on a post /put request
  final List? files;

  /// options are [modal] and [snack]
  final LoaderType? loader;

  /// use online cache
  final bool useCache;

  /// always try to use cache if available
  final bool forceRefresh;

  /// allow saving network result offline
  // final bool offlineCache;

  final int cacheTimeout; // cache timeout in minutes *(defaults to 20 minutes)

  /// internal token used for request
  String? _accessToken;

  // String get _cacheKey => '$_fullUrl.$method';

  /// callback Methods
  final NetworkSuccessCallback? onSuccess;
  final NetworkSuccessCallback? onFailure;
  final Function? onError;
  final Function? onRedirect;
  final int timeout;

  final BuildContext? context;

  final Map<String, String> _headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  final bool ignoreToken;

  Future<NetworkResponse> send() async {
    // get token

    _accessToken = await tools.getFromStore('accessToken');
    // _headers['Authorization'] = 'Bearer  $_accessToken';
    // print('headers: $_headers');
    // print(_headers);
    // _headers = {
    //   'Content-Type': 'application/json',
    //   'Accept': 'application/json',

    // }

    var dio = Dio();

    // Firebase Perfrmance Interceptor
    // var performanceInterceptor = DioFirebasePerformanceInterceptor();
    // dio.interceptors.add(performanceInterceptor);

    // try {
    //   if (useCache)
    //     dio.interceptors.add(DioCacheManager(CacheConfig()).interceptor);
    // } catch (e, stack) {
    //   print("local network cache not supported $stack $e");
    // }

    //

    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = timeout;
    dio.options.receiveTimeout = timeout;
    dio.options.headers = _headers;

    // auto set post method
    if (method == 'GET' && body != null && post == null) {
      method = 'POST';
    }

    if (method == 'GET' && body == null && post != null) {
      method = 'POST';
      print(method);
    }

    if (isPut == true) {
      method = 'PUT';
    }

    if (isPatch == true) {
      method = 'PATCH';
    }

    // file upload
    if (files != null) {
      for (var file in files!) {
        body[file] = await MultipartFile.fromFile(
          body[file],
        );
      }
    }
    var data = body;
    // FormData data = FormData.fromMap(body);

    //display loading modal if set
    // try {
    //   switch (loader) {
    //     case (LoaderType.snack):
    //       // Loaders.showSnackLoading(context, message: loadingMessage);
    //       break;
    //     case (LoaderType.popup):
    //       Loaders.showModalLoading(context).then((reason) {
    //         if (reason == null) {
    //           dio.close();
    //         } //'close connection';
    //       });
    //       break;
    //     case (LoaderType.sheet):
    //       Loaders.showModalLoading(context).then((reason) {
    //         if (reason == null) {
    //           dio.close();
    //         } //'close connection';
    //       });
    //       break;
    //     default:
    //   }
    // } catch (e, stack) {
    //   print(stack);
    // }

    Response? response;
    try {
      switch (method) {
        case 'GET':
          response = await dio.get(url,
              options: buildCacheOptions(Duration(minutes: cacheTimeout),
                  forceRefresh: forceRefresh));
          break;
        case 'POST':
          response = await dio.post(url,
              data: data, options: Options(headers: _headers));
          break;
        case 'PATCH':
          response = await dio.patch(url, data: data);
          break;
        case 'PUT':
          response = await dio.put(url, data: data);
          break;
        case 'DELETE':
          response = await dio.delete(url);
          break;
      }
    } on DioError catch (e, stack) {
      print(stack);
      response = e.response;

      if (e.type == DioErrorType.connectTimeout) {
        //showSnackbar(context!, 'TimeOut');

        //  Modal().error('Timeout', context);
        throw Exception('Connection  Timeout Exception');
      }

      if (response == null) {
        _onError(e);
        print(response!.headers);
        return NetworkResponse(
            headers: response.headers, status: NetworkStatus.error, body: null);
      }
    } finally {
      // remove loading widget if available
      // await Future.delayed(Duration(seconds: 1));
      try {
        switch (loader) {
          case (LoaderType.snack):
            ScaffoldMessenger.of(context!).removeCurrentSnackBar();
            break;
          case (LoaderType.popup):
            Navigator.of(context!, rootNavigator: true).pop();
            break;
          case (LoaderType.sheet):
            Navigator.of(context!).pop(true);
            break;
          default:
        }
      } catch (e) {
        print(e);
      }
    }

    if (response == null) {
      // Navigator.pop(context!);
    }

    return parseResponse(response!);
  }

  /// Parse the response to determine if it
  /// was a success, failure, error or redirect
  /// the optional aurgment [ responseBody ] is avaliable if
  /// the response obj doen't have a body
  NetworkResponse parseResponse(Response responses) {
    var responseBody = responses.data;
    int? statusCode = responses.statusCode;
    if ('$statusCode'.startsWith('2')) {
      NetworkResponse response = NetworkResponse(
          headers: responses.headers,
          status: NetworkStatus.success,
          body: responseBody,
          statusCode: statusCode);

      _onSuccess(response, responseBody);

      return response;
    } else if ('$statusCode'.startsWith('4')) {
      NetworkResponse response = NetworkResponse(
          headers: responses.headers,
          status: NetworkStatus.failure,
          body: responseBody,
          statusCode: statusCode);
      ScaffoldMessenger.of(context!).removeCurrentSnackBar();
      //   Modal().error(responseBody['message'], context);
      _onFailure(response, responseBody);

      return response;
    } else if ('$statusCode'.startsWith('5')) {
      NetworkResponse response = NetworkResponse(
          headers: responses.headers,
          status: NetworkStatus.failure,
          body: responseBody,
          statusCode: statusCode);
      ScaffoldMessenger.of(context!).removeCurrentSnackBar();

      print(responseBody);
      print(url);
      _onFailure(response, responseBody);

      return response;
    } else {
      NetworkResponse response = NetworkResponse(
          headers: responses.headers,
          status: NetworkStatus.failure,
          body: responseBody,
          statusCode: statusCode);
      _onFailure(response, responseBody);

      print(responseBody['message']);
      return response;
    }
  }

  void _onSuccess(NetworkResponse response, result) {
    print('Network success from $url, $result');
    if (onSuccess != null) {
      onSuccess!(response, result);

      //if (response.body['message'] != null) {
      // successfulshowSnackbar(
      // context,
      // response.body['message']
      // .toString()
      // .replaceAll('[', '')
      // .replaceAll(']', '')
      // .replaceAll('{', '')
      // .replaceAll('}', ''));
      // }
    }
  }

  void showUserError(message) {
    if (context == null) return;
    //Navigator.pop(context);
    showDialog(
        context: context!,
        builder: (context) {
          return AlertDialog(
              title: const Text('Error'),
              content: SizedBox(
                height: 270,
                width: 270,
                child: ListView(
                  children: <Widget>[Text('$message')],
                ),
              ));
        });
  }

  Future<void> _onFailure(NetworkResponse response, responseBody) async {
    print('$url Network failure ${response.statusCode} $responseBody');
    if (onFailure != null) {
      onFailure!(response, responseBody);
      showTopSnackBar(
        Overlay.of(context!),
        CustomSnackBar.error(
          message: responseBody['message'],
        ),
      );

      if (response.body['message'] != null) {
        // successfulshowSnackbar(
        // context,
        // response.body['message']
        // .toString()
        // .replaceAll('[', '')
        // .replaceAll(']', '')
        // .replaceAll('{', '')
        // .replaceAll('}', ''));

        showTopSnackBar(
          Overlay.of(context!),
          CustomSnackBar.error(
            message: responseBody['message'],
          ),
        );
      }
    }
    // Navigator.pop(context!);
    // print('fefrf');
    showTopSnackBar(
      Overlay.of(context!),
      CustomSnackBar.error(
        message: responseBody['message'],
      ),
    );

    // Modal().showToast(responseBody['message']);

    if (responseBody['message'].toString().contains('Unauthenticated')) {
      Navigator.push(
          context!, MaterialPageRoute(builder: (context) => const LoginPage()));
    }

    String? msg = 'connection failed!';
    try {
      if (responseBody.keys.contains('message')) {
        msg = responseBody['message'];
      }
    } catch (e) {
      try {
        msg = (responseBody as String).substring(0, 50);
      } catch (e) {}
      print('connection error $e');
    } finally {}
  }

  // void _onRedirect(NetworkResponse response) {
  //   if (!silent) {
  //     tools.showToast('Connection redirect, try again');
  //   }
  //   print('Network Redirect $response');
  //   if (onRedirect != null) {
  //     onRedirect!(response);
  //   }
  // }

  void _onError(DioError error) {
    Navigator.pop(context!);
    //showSnackbar(context!, 'TimeOut');
    print(error);

    // Modal().error('Timeout', context);
    print('bad network ${error.message}');
    showTopSnackBar(
      Overlay.of(context!),
      CustomSnackBar.error(
        backgroundColor: Colors.black26,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [],
        message: 'Please check your network connection',
      ),
    );

    if (shouldPopOnError == true) {
      //Navigator.pop(context!);
      //showSnackbar(context!, 'Connection error, try again');
    } else {
      //showSnackbar(context!, 'Connection error, try again');
    }

    if (onError != null) {
      try {
        onError!(error);
      } catch (error) {}
    }
  }
}
