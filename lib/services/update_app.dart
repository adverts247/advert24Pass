// IMPORT PACKAGE
import 'dart:async';
import 'dart:developer';

// import 'package:ota_update/ota_update.dart';
import 'package:adverts247Pass/services/network.dart/streaming-network.dart';
import 'package:adverts247Pass/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ota_update/ota_update.dart';
import 'package:adverts247Pass/tools.dart' as tools;
import 'package:shorebird_code_push/shorebird_code_push.dart';

// RUN OTA UPDATE
// START LISTENING FOR DOWNLOAD PROGRESS REPORTING EVENTS

class OtaService extends ChangeNotifier {
  final updater = ShorebirdUpdater();
  late final bool isUpdaterAvailable;
  var currentTrack = UpdateTrack.stable;
  var isCheckingForUpdates = false;
  Patch? currentPatche;
  OtaEvent? currentEvent;

  updaterCheck() {
    isUpdaterAvailable = updater.isAvailable;
    notifyListeners();

    // Read the current patch (if there is one.)
    // `currentPatch` will be `null` if no patch is installed.
    updater.readCurrentPatch().then((currentPatch) async {
      currentPatche = currentPatch;
      await checkForUpdates();
    }).catchError((Object error) {
      // If an error occurs, we log it for now.
      debugPrint('Error reading current patch: $error');
    });
  }

  Future<void> checkForUpdates() async {
    if (isCheckingForUpdates) return;
    try {
      isCheckingForUpdates = true;
      notifyListeners();
      final status = await updater.checkForUpdate(track: currentTrack);
      switch (status) {
        case UpdateStatus.upToDate:
          _showNoUpdateAvailableBanner();
        case UpdateStatus.outdated:
          _showUpdateAvailableBanner();
        case UpdateStatus.restartRequired:
          _showRestartBanner();
        case UpdateStatus.unavailable:
        // Do nothing, there is already a warning displayed at the top of the
        // screen.
      }
    } catch (e) {
      debugPrint('Error checking for update: $e');
    } finally {
      isCheckingForUpdates = false;
      notifyListeners();
    }
  }

  updateAppOta(String url) {
    try {
      //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
      OtaUpdate()
          .execute(
        url,
   
        // OPTIONAL
        destinationFilename: 'advert247.apk',
        //OPTIONAL, ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:
      )
          .listen(
        (OtaEvent event) async {
          switch (event.status) {
            case OtaStatus.DOWNLOADING:
              print("Downloading");

            case OtaStatus.INSTALLING:
              await tools.putInStore('updatUrl', url);
            case OtaStatus.DOWNLOAD_ERROR:
              print("Error");
            default:
              print(event.status.name);
          }
        
      
        },
      );
    } catch (e) {
      print('Failed to make OTA update. Details: $e');
    }
  }

  Future<dynamic> getUrl() async {
    var token = await tools.getFromStore('accessToken');
    print(token);
    Completer<dynamic> completer = Completer<dynamic>();

    //Loaders().showModalLoading(context);
    HttpRequestStreaming('https://ads247-center.lazynerdstudios.com/api/v1/apk',
        // 'https://ads247-streaming.lazynerdstudios.com'
        context: Get.context,
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

  checkifUpdateIsNeeded() async {
    String url = await tools.getFromStore('updatUrl') ?? 'No url';
    String updateUrl = await getUrl() ?? 'No url';

    print(url);
    print(updateUrl);

    if (url != updateUrl) {
      Get.dialog(Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(100),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("New Update available"),
              SizedBox(
                height: 12,
              ),
              Text(
                  "There is a new version of this app do you want to update it"),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Spacer(),
                  SizedBox(
                    width: 100,
                    height: 56,
                    child: MyButton(
                      text: "Update",
                      onPressed: () => updateAppOta(updateUrl),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ));
    } else {}
  }

  void _showDownloadingBanner(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(
        const MaterialBanner(
          content: Text('Downloading...'),
          actions: [
            SizedBox(
              height: 14,
              width: 14,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
  }

  void _showUpdateAvailableBanner() {
    ScaffoldMessenger.of(Get.context!)
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(
        MaterialBanner(
          content: Text(
            'Update available for the ${currentTrack.name} track.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                ScaffoldMessenger.of(Get.context!).hideCurrentMaterialBanner();
                await _downloadUpdate();
                // if (!mounted) return;
                ScaffoldMessenger.of(Get.context!).hideCurrentMaterialBanner();
              },
              child: const Text('Download'),
            ),
          ],
        ),
      );
  }

  void _showNoUpdateAvailableBanner() {
    ScaffoldMessenger.of(Get.context!)
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(
        MaterialBanner(
          content: Text(
            'No update available on the  track.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(Get.context!).hideCurrentMaterialBanner();
              },
              child: const Text('Dismiss'),
            ),
          ],
        ),
      );
  }

  void _showRestartBanner() {
    ScaffoldMessenger.of(Get.context!)
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(
        MaterialBanner(
          content: const Text('A new patch is ready! Please restart your app.'),
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(Get.context!).hideCurrentMaterialBanner();
              },
              child: const Text('Dismiss'),
            ),
          ],
        ),
      );
  }

  void _showErrorBanner(
    Object error,
  ) {
    ScaffoldMessenger.of(Get.context!)
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(
        MaterialBanner(
          content: Text(
            'An error occurred while downloading the update: $error.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(Get.context!).hideCurrentMaterialBanner();
              },
              child: const Text('Dismiss'),
            ),
          ],
        ),
      );
  }

  Future<void> _downloadUpdate() async {
    _showDownloadingBanner(Get.context!);
    try {
      // Perform the update (e.g download the latest patch on [_currentTrack]).
      // Note that [track] is optional. Not passing it will default to the
      // stable track.
      await updater.update(track: currentTrack);
      // if (!mounted) return;
      // Show a banner to inform the user that the update is ready and that they
      // need to restart the app.
      _showRestartBanner();
    } on UpdateException catch (error) {
      // If an error occurs, we show a banner with the error message.
      _showErrorBanner(
        error.message,
      );
    }
  }
  // OtaEvent? currentEvent;
  // Future<void> tryOtaUpdate(String urlUpdate) async {
  //   print(urlUpdate);
  //   try {
  //     print('ABI Platform: ${await OtaUpdate().getAbi()}');
  //     //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
  //     OtaUpdate()
  //         .execute(
  //       urlUpdate,
  //       // urlUpdate,
  //       destinationFilename: 'flutter_hello_world.apk',
  //       //FOR NOW ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:
  //       //  sha256checksum:
  //       //     'f6535d938944f2cc4e32c95a846c61d90b0f0647e2d7d252c08b3a5aeaf3614d',
  //     )
  //         .listen(
  //       (OtaEvent event) async {
  //         print(event.status.name);
  //         if (event.status.name.toString() == 'INSTALLING') {
  //           await tools.putInStore('updatUrl', urlUpdate);
  //         }

  //         // setState(() => currentEvent = event);
  //       },
  //     );
  //     // ignore: avoid_catches_without_on_clauses
  //   } catch (e) {
  //     print('Failed to make OTA update. Details: $e');
  //   }
  // }

  // checkifUpdateIsNeeded(context) async {
  //   String url = await tools.getFromStore('updatUrl') ?? 'No url';
  //   String updateUrl = await getUrl(context) ?? 'No url';

  //   print(url);
  //   print(updateUrl);

  //   if (url != updateUrl) {
  //     tryOtaUpdate(updateUrl);
  //   } else {}
  // }

  // Future<dynamic> getUrl(
  //   context,
  // ) async {
  //   var token = await tools.getFromStore('accessToken');
  //   print(token);
  //   Completer<dynamic> completer = Completer<dynamic>();

  //   //Loaders().showModalLoading(context);
  //   HttpRequestStreaming('https://central.adverts247.xyz/api/v1/apk',
  //       // 'https://streaming.adverts247.xyz'
  //       context: context,
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //       },

  //       // loader: LoaderType.popup,
  //       shouldPopOnError: false, onSuccess: (_, result) {
  //     print('Ota');
  //     //   print(await result['data']);

  //     completer.complete(result['data']['apk'] ??
  //         'no'); // Complete the completer with the result
  //   }, onFailure: (_, result) {
  //     //Navigator.pop(context);
  //     debugPrint(result);
  //     completer.completeError(
  //         result['data']); // Complete the completer with an error
  //   }).send();

  //   return completer
  //       .future; // Return the completer's future for handling results
  // }
}
