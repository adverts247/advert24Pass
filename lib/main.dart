import 'package:adverts247Pass/pre-streaming-screen/profile_display/profile_image_display.dart';
import 'package:adverts247Pass/services/image_assets.dart';
import 'package:adverts247Pass/state/entertainment_state.dart';
import 'package:adverts247Pass/state/location_weather_state.dart';
import 'package:adverts247Pass/state/login_state.dart';
import 'package:adverts247Pass/state/user_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:adverts247Pass/services/websocket.dart';
import 'package:adverts247Pass/ui/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<String> imageUrls = [
    ImageAssets.blackHorse1,
    'assets/images/play_games_text1.png',
        'assets/images/video_ad_video_text.png',
        'assets/images/sport_ad_video_text.png',
        'assets/images/music_ad_video_text.png',
        'assets/images/coming_soon.png',
        'assets/images/classic_triva.png',
        'assets/images/picture_triva.png',
        'assets/images/head_icon.png',
    // 'https://example.com/image2.jpg',
    // 'https://example.com/image3.jpg',
  ];

  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Batch preload images
    for (var url in imageUrls) {
      precacheImage(
        AssetImage(url),
        context,
        onError: (error, stackTrace) {
          if (kDebugMode) {
            print('Image failed to load: $error');
          }
          // Handle the error, e.g., display a placeholder image
        },
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserState()),
        ChangeNotifierProvider(create: (context) => WeatherLocationState()),
        ChangeNotifierProvider(create: (context)=>VideoState()),
        ChangeNotifierProvider(create: (context)=>EntertainmentState())
      ],
      child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          // Use builder only if you need to use library outside ScreenUtilInit context
          builder: (_, child) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                // This is the theme of your application.

                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: SplashScreen(),
            );
          }),
    );
  }
}
