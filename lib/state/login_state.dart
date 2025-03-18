import 'dart:developer';

import 'package:adverts247Pass/model/api_response.dart';
import 'package:adverts247Pass/services/video_service.dart';
import 'package:adverts247Pass/state/user_state.dart';
import 'package:adverts247Pass/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideoState extends ChangeNotifier {
  late VideoService videoService;
  VideoState() {
    videoService = VideoService();
  }
  Future<APIResponse> login(
      {required BuildContext context, dynamic body}) async {
    try {
      loader().showImageDialog(context);
      final response = await videoService.login(context, body);
      if (!response.error) {
        log("response ================= ${response.data}");
        final response2 = await getWallet(context);
        if (response2.error) {
          return APIResponse(error: true, message: response2.message);
        }
      }
      return response;
    } catch (e) {
      return APIResponse(error: true, message: e.toString());
    }
  }

  Future<APIResponse> getWallet(BuildContext context) async {
    try {
      final response = await videoService.getWallet(context);
      log("wallet response==================${response.data}");
      Provider.of<UserState>(context, listen: false)
          .getUserData(response.data["data"]["data"]);
      return response;
    } catch (e) {
      return APIResponse(error: true, message: e.toString());
    }
  }
}
