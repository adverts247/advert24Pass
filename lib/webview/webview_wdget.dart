import 'dart:async';

import 'package:adverts247Pass/services/image_assets.dart';
import 'package:adverts247Pass/state/entertainment_state.dart';
import 'package:adverts247Pass/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  const WebviewPage({super.key});

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  late WebViewController controller;
  bool isLoading = true; // Track loading state
  int loadingProgress = 0; // Track loading progress
  late Timer _questionTimer;
  int _totalTimeLeft = 60;

  @override
  void initState() {
    super.initState();
    initializeWebView();
    startTimers();
  }

  // Add this method to format time
  String formatCountTime(int seconds) {
    return '${(seconds % 60).toString().padLeft(2, '0')}';
  }

  void startTimers() {
    // Timer for individual questions (5 seconds each)
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_totalTimeLeft > 0) {
          _totalTimeLeft--;
        } else {
           Provider.of<EntertainmentState>(context,listen: false).playAudio();
          Navigator.of(context).pop();
        }
      });
    });
  }

  void initializeWebView() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading progress
            setState(() {
              loadingProgress = progress;
              // Keep isLoading true until 100% complete
              isLoading = progress < 100;
            });
          },
          onPageStarted: (String url) {
            // Show loader when page starts loading
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            // Hide loader when page finishes loading
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            // Handle errors by showing an error state
            setState(() {
              isLoading = false;
            });
            // Optionally show an error message to the user
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error loading page: ${error.description}'),
              ),
            );
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.livescore.com/en/'));
  }

  @override
  void dispose() {
    _questionTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Themes().pink,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 40,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Image.asset(
          ImageAssets.appLogo,
          height: 40,
          width: 200,
        ),
      ),
      body: Stack(
        children: [
          // WebView always present in the stack
          WebViewWidget(controller: controller),

          Positioned(
            right: 20,
            top: 20,
            child: Container(
              padding: EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 5)),
              child: Text(
                formatCountTime(_totalTimeLeft),
                style: TextStyles().whiteTextStyle(
                    fontSize: 12.sp, fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Loading overlay shown while isLoading is true
          if (isLoading)
            Container(
              color: Colors.black87, // Semi-transparent background
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App logo
                    Image.asset(
                      ImageAssets.appLogo,
                      height: 100,
                      width: 100,
                    ),
                    const SizedBox(height: 20),

                    // Loading text with dots
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Connecting ',
                            style: TextStyles().whiteTextStyle().copyWith(
                                  fontSize: 20,
                                ),
                          ),
                          const TextSpan(
                            text: '....',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Progress indicator
                    SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        value: loadingProgress / 100,
                        backgroundColor: Colors.grey[700],
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Progress percentage
                    Text(
                      '$loadingProgress%',
                      style: TextStyles().whiteTextStyle().copyWith(
                            fontSize: 16,
                          ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
