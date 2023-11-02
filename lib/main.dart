import 'package:adverts247Pass/about_me.dart';
import 'package:adverts247Pass/login.dart';
import 'package:adverts247Pass/splash_screen.dart';
import 'package:adverts247Pass/state/location_weather_state.dart';
import 'package:adverts247Pass/state/user_state.dart';
import 'package:adverts247Pass/broadcast_videoplayer.dart';
import 'package:adverts247Pass/video_player1.dart';
import 'package:adverts247Pass/waiting_Page.dart';
import 'package:adverts247Pass/websocket.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserState()),
        ChangeNotifierProvider(create: (context) => WeatherLocationState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreen(),

        //  VideoPlayerScreen1(
        //   videoUrls: [
        //     'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        //     'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        //     // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        //     // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        //     // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        //     // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        //   ],
        // ),
      ),
    );
  }
}
