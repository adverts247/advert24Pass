// IMPORT PACKAGE
import 'dart:async';

import 'package:adverts247Pass/services/network.dart/streaming-network.dart';
import 'package:ota_update/ota_update.dart';
import 'package:flutter/material.dart';
import 'package:adverts247Pass/tools.dart' as tools;

// RUN OTA UPDATE
// START LISTENING FOR DOWNLOAD PROGRESS REPORTING EVENTS

class OtaService {
  OtaEvent? currentEvent;
  Future<void> tryOtaUpdate(String urlUpdate) async {
    print(urlUpdate);
    try {
      print('ABI Platform: ${await OtaUpdate().getAbi()}');
      //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
      OtaUpdate()
          .execute(
        urlUpdate,
   
      )
          .listen(
        (OtaEvent event) async {
          print(event.status.name);
          if (event.status.name.toString() == 'INSTALLING') {
            await tools.putInStore('updatUrl', urlUpdate);
          }

          // setState(() => currentEvent = event);
        },
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      print('Failed to make OTA update. Details: $e');
    }
  }

  checkifUpdateIsNeeded(context) async {
    String url = await tools.getFromStore('updatUrl') ?? 'No url';
    String updateUrl = await getUrl(context) ?? 'No url';

    print(url);
    print(updateUrl);

    if (url != updateUrl) {
      tryOtaUpdate(updateUrl);
    } else {}
  }

  Future<dynamic> getUrl(
    context,
  ) async {
    var token = await tools.getFromStore('accessToken');
    print(token);
    Completer<dynamic> completer = Completer<dynamic>();

    //Loaders().showModalLoading(context);
    HttpRequestStreaming('https://ads247-center.lazynerdstudios.com/api/v1/apk',
        // https://ads247-center.lazynerdstudios.com/api/v1/apk
        //https://central.adverts247.xyz/api/v1/apk

        context: context,
        headers: {
          'Authorization': 'Bearer $token',
        },

        // loader: LoaderType.popup,
        shouldPopOnError: false, onSuccess: (_, result) {
      print('Ota');
      //   print(await result['data']);

      completer.complete(result['data']['apk'] ??
          'no'); // Complete the completer with the result
    }, onFailure: (_, result) {
      //Navigator.pop(context);
      debugPrint(result);
      completer.completeError(
          result['data']); // Complete the completer with an error
    }).send();

    return completer
        .future; // Return the completer's future for handling results
  }
}
