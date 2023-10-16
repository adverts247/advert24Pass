// import 'dart:async';

// import 'package:advert24pass/themes.dart';
// import 'package:advert24pass/websocket.dart';
// import 'package:advert24pass/widget/button.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator_platform_interface/src/enums/location_service.dart';
// import 'package:kiosk_mode/kiosk_mode.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';
// import 'package:video_player/video_player.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// class VideoPlayerScreen extends StatefulWidget {
//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   VideoPlayerController? _videoPlayerController;
//   ChewieController? _chewieController;
//   List<String> videoUrls = [
//     'assets/images/istockphoto-1211256735-640_adpp_is.mp4',
//     // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
//     // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
//   ];
//   int currentVideoIndex = 0;

//   Future<void> _initializeVideoPlayer(int index) async {
//     _videoPlayerController = VideoPlayerController.asset(
//       videoUrls[index],
//     );
//     final mode = await getKioskMode().then((value) => print('started'));

//     startKioskMode();
//   }

//   @override
//   void initState() {
//     super.initState();
//     LocationWesocket().serviceStatusStream;

//     _initializeVideoPlayer(currentVideoIndex);

//     _chewieController = ChewieController(
//       videoPlayerController: _videoPlayerController!,
//       aspectRatio:
//           16 / 9, // You can adjust this ratio to fit your video's aspect ratio
//       autoPlay: true,
//       looping: true,
//       // Customize your controls here
//       materialProgressColors: ChewieProgressColors(
//         playedColor: Colors.red,
//         handleColor: Colors.red,
//         backgroundColor: Colors.black,
//         bufferedColor: Colors.grey,
//       ),

//       placeholder: Container(
//         color: Colors.grey,
//       ),
//     );

//     _videoPlayerController!.addListener(() {
//       print(_videoPlayerController!.value.position);
//       //   print(_videoPlayerController!.value.isCompleted);

//       if (_videoPlayerController!.value.isCompleted) {
//         print('yes');
//         // Video playback is completed
//         setState(() {
//           if (currentVideoIndex < videoUrls.length - 1) {
//             // If there are more videos in the list, move to the next one
//             currentVideoIndex++;
//             _initializeVideoPlayer(currentVideoIndex);
//             print(currentVideoIndex);
//           }
//         });
//       }
//     });
//   }

//   nextVideo() {
//     //  if (currentVideoIndex < videoUrls.length - 1) {
//     // If there are more videos in the list, move to the next one
//     setState(() {
//       print('def');
//       currentVideoIndex++;
//       _initializeVideoPlayer(currentVideoIndex);
//     });
//     // }
//   }

//   prevVideo() {
//     if (currentVideoIndex < videoUrls.length - 1) {
//       // If there are more videos in the list, move to the next one
//       setState(() {
//         currentVideoIndex--;
//         _initializeVideoPlayer(currentVideoIndex);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Video Player Example'),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             Expanded(
//               child: Chewie(
//                 controller: _chewieController!,
//               ),
//             ),
//             Container(
//               height: 79,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         SizedBox(
//                           width: 40,
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(MdiIcons.thumbUpOutline,
//                                 color: Colors.blue, size: 30),
//                             Text(
//                               'Like',
//                               style: TextStyles()
//                                   .greyTextStyle400()
//                                   .copyWith(fontSize: 16, color: Colors.blue),
//                             )
//                           ],
//                         ),
//                         SizedBox(
//                           width: 40,
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(MdiIcons.thumbDownOutline,
//                                 color: Colors.red, size: 30),
//                             Text(
//                               'DisLike',
//                               style: TextStyles()
//                                   .greyTextStyle400()
//                                   .copyWith(fontSize: 16, color: Colors.red),
//                             )
//                           ],
//                         )
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Container(
//                             width: 70,
//                             child: SecondaryButton(
//                               text: 'Prev',
//                               onPressed: () {
//                                 prevVideo();
//                               },
//                             )),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         Container(
//                             width: 70,
//                             child: MyButton(
//                               text: 'Next',
//                               onPressed: () {
//                                 nextVideo();
//                               },
//                             ))
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _videoPlayerController!.dispose();
//     _chewieController!.dispose();
//     super.dispose();
//   }
// }
