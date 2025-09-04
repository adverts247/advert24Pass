// Models
import 'dart:async';

import 'package:adverts247Pass/pre-streaming-screen/game/data/trivia_questions_data.dart';
import 'package:adverts247Pass/pre-streaming-screen/game/entertainment_page.dart';
import 'package:adverts247Pass/services/helpers.dart';
import 'package:adverts247Pass/services/image_assets.dart';
import 'package:adverts247Pass/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Main game screen
class PictureTrivia extends StatefulWidget {
  const PictureTrivia({Key? key}) : super(key: key);

  @override
  _PictureTriviaState createState() => _PictureTriviaState();
}

class _PictureTriviaState extends State<PictureTrivia> {
  int currentQuestionIndex = 0;
  int score = 0;
  bool questionAnswered = false;
  int? selectedAnswerIndex;
  bool showBrightnessSlider = false;
  bool? showVolumeSlider = false;

  // Add these variables to your state class
  late Timer _questionTimer;
  late Timer _gameTimer;
  int _totalTimeLeft = 50; // Total time in seconds
  int _questionTimeLeft = 5; // Time per question in seconds

// Add this to initState
  @override
  void initState() {
    super.initState();
    startTimers();
  }

// Add this to dispose
  @override
  void dispose() {
    _questionTimer.cancel();
    _gameTimer.cancel();
    super.dispose();
  }

  void startTimers() {
    // Timer for individual questions (5 seconds each)
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_questionTimeLeft > 0) {
          _questionTimeLeft--;
        } else {
          // Time's up for this question, move to next
          _questionTimeLeft = 5; // Reset question timer
          if (!questionAnswered) {
            // If user hasn't answered, count as wrong
            checkAnswer(-1); // -1 indicates no answer selected
          } else {
            goNext(dontDelay: true);
          }
        }
      });
    });

    // Timer for total game duration (50 seconds)
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_totalTimeLeft > 0) {
          _totalTimeLeft--;
        } else {
          // Total time's up, show game over
          _gameTimer.cancel();
          _questionTimer.cancel();
          showGameOverDialog();
        }
      });
    });
  }

  void checkAnswer(int selectedIndex) {
    if (questionAnswered) return;

    setState(() {
      questionAnswered = true;
      selectedAnswerIndex = selectedIndex;

      if (selectedIndex ==
          triviaQuestions[currentQuestionIndex].correctAnswerIndex) {
        score++;
      }
    });

    goNext();
  }

  Future<Null> goNext({bool? dontDelay}) {
    return Future.delayed(Duration(seconds: dontDelay == true ? 0 : 3), () {
      if (currentQuestionIndex < triviaQuestions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          questionAnswered = false;
          selectedAnswerIndex = null;
          _questionTimeLeft = 5; // Reset question timer
        });
      } else {
        _questionTimer.cancel(); // Cancel timers when game is over
        _gameTimer.cancel();
        showGameOverDialog();
      }
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Auto-close timer
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => EntertainmentPage()),
            (route) => false,
          );
        });

        return AlertDialog(
          title: Text(
            'Game Over!',
            style: GoogleFonts.manrope(
              color: Themes().blackColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Your final score: $score/${triviaQuestions.length}',
                style: GoogleFonts.manrope(
                  color: Themes().blackColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Performance: ${(score / triviaQuestions.length * 100).toStringAsFixed(1)}%',
                style: GoogleFonts.manrope(
                  color: Themes().blackColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'Ok',
                style: GoogleFonts.manrope(
                  color: Themes().blackColor,
                  fontWeight: FontWeight.w500,
                  // fontSize: 17,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                  return EntertainmentPage();
                }), (route) => false);
                setState(() {
                  currentQuestionIndex = 0;
                  score = 0;
                  questionAnswered = false;
                  selectedAnswerIndex = null;
                });
              },
            ),
            TextButton(
              child: Text(
                'Play Again',
                style: GoogleFonts.manrope(
                  color: Themes().pink,
                  fontWeight: FontWeight.w500,
                  // fontSize: 17,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  currentQuestionIndex = 0;
                  score = 0;
                  questionAnswered = false;
                  selectedAnswerIndex = null;
                });
              },
            ),
          ],
        );
      },
    );
  }

  // Add this method to format time
  String formatCountTime(int seconds) {
    return '${(seconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final question = triviaQuestions[currentQuestionIndex];

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  ImageAssets.gameBackground,
                ),
                fit: BoxFit.fill),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Picture Trivia',
                          style: TextStyles().whiteTextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w900),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          padding: EdgeInsets.all(18.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 5)),
                          child: Text(
                            formatCountTime(_totalTimeLeft),
                            style: TextStyles().whiteTextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.w900),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 55.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 90.sp,
                            width: 200.sp,
                            margin: EdgeInsets.symmetric(horizontal: 35.sp),
                            decoration: BoxDecoration(
                              // color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.pink,
                                width: 7,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.pink.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 10,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  27), // Slightly smaller than container border radius
                              child: Image.asset(
                                question.imageAsset,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // Question counter
                          // Text(
                          //   'Question ${currentQuestionIndex + 1}/${triviaQuestions.length}',
                          //   style:
                          //       const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          //   textAlign: TextAlign.center,
                          // ),
                          // const SizedBox(height: 20),

                          const SizedBox(height: 20),

                     
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 45.w),
                            child: Stack(
                              children: [
                                Image.asset(ImageAssets.questionBar),
                                Positioned(
                                  left: 20,
                                  right: 20,
                                  top: 15,
                                  bottom: 5,
                                  child: Text(
                                    question.question,
                                    style: GoogleFonts.manrope(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 6.sp,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Answer options
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 80.0),
                            child: Row(children: [
                              Expanded(
                                child: InkWell(
                                  // Add InkWell for tap detection
                                  onTap: () => checkAnswer(0), // For option A
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        ImageAssets.answerBar,
                                        color: questionAnswered
                                            ? (0 == question.correctAnswerIndex
                                                ? Colors.green.withOpacity(0.5)
                                                : (0 == selectedAnswerIndex
                                                    ? Colors.red
                                                        .withOpacity(0.5)
                                                    : null))
                                            : null,
                                        colorBlendMode: BlendMode.srcATop,
                                      ),
                                      Positioned(
                                        left: 35,
                                        top: 10,
                                        child: Text(
                                          "A. ${question.options[0]}", // Use actual option text
                                          style: GoogleFonts.manrope(
                                            color: questionAnswered
                                                ? (0 == question.correctAnswerIndex ||
                                                        0 == selectedAnswerIndex
                                                    ? Colors.white
                                                    : Themes().blue)
                                                : Themes().blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 8.sp,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                                width: 150,
                                child: DecoratedBox(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                ),
                              ),
                              // Repeat similar pattern for option B
                              Expanded(
                                child: InkWell(
                                  onTap: () => checkAnswer(1),
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        ImageAssets.answerBar,
                                        color: questionAnswered
                                            ? (1 == question.correctAnswerIndex
                                                ? Colors.green.withOpacity(0.5)
                                                : (1 == selectedAnswerIndex
                                                    ? Colors.red
                                                        .withOpacity(0.5)
                                                    : null))
                                            : null,
                                        colorBlendMode: BlendMode.srcATop,
                                      ),
                                      Positioned(
                                        left: 35,
                                        top: 10,
                                        child: Text(
                                          "B. ${question.options[1]}",
                                          style: GoogleFonts.manrope(
                                            color: questionAnswered
                                                ? (1 == question.correctAnswerIndex ||
                                                        1 == selectedAnswerIndex
                                                    ? Colors.white
                                                    : Themes().blue)
                                                : Themes().blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 8.sp,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 80.0),
                            child: Row(children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => checkAnswer(2),
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        ImageAssets.answerBar,
                                        color: questionAnswered
                                            ? (2 == question.correctAnswerIndex
                                                ? Colors.green.withOpacity(0.5)
                                                : (2 == selectedAnswerIndex
                                                    ? Colors.red
                                                        .withOpacity(0.5)
                                                    : null))
                                            : null,
                                        colorBlendMode: BlendMode.srcATop,
                                      ),
                                      Positioned(
                                        left: 35,
                                        top: 10,
                                        child: Text(
                                          "C. ${question.options[2]}",
                                          style: GoogleFonts.manrope(
                                            color: questionAnswered
                                                ? (2 == question.correctAnswerIndex ||
                                                        2 == selectedAnswerIndex
                                                    ? Colors.white
                                                    : Themes().blue)
                                                : Themes().blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 8.sp,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                                width: 150,
                                child: DecoratedBox(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () => checkAnswer(3),
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        ImageAssets.answerBar,
                                        color: questionAnswered
                                            ? (3 == question.correctAnswerIndex
                                                ? Colors.green.withOpacity(0.5)
                                                : (3 == selectedAnswerIndex
                                                    ? Colors.red
                                                        .withOpacity(0.5)
                                                    : null))
                                            : null,
                                        colorBlendMode: BlendMode.srcATop,
                                      ),
                                      Positioned(
                                        left: 35,
                                        top: 10,
                                        child: Text(
                                          "D. ${question.options[3]}",
                                          style: GoogleFonts.manrope(
                                            color: questionAnswered
                                                ? (3 == question.correctAnswerIndex ||
                                                        3 == selectedAnswerIndex
                                                    ? Colors.white
                                                    : Themes().blue)
                                                : Themes().blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 8.sp,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),

                    // Explanation text (shown after answering)
                    if (questionAnswered)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          question.explanation,
                          style: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Themes().whiteColor,
                    // border: Border.all(color: Colors.white),
                    // borderRadius: BorderRadius.circular(20)
                  ),
                  //  height: 85,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0).copyWith(right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                                child: Image.asset(ImageAssets.elementDown)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    // setState(() {
                                    //   // showVolumeSlider = !showVolumeSlider!;
                                    // });

                                    setState(() {
                                      showBrightnessSlider =
                                          !showBrightnessSlider;
                                      showVolumeSlider = false!;
                                    });
                                    // showBrightnessSlider = true;
                                  },
                                  icon: Image.asset(
                                    ImageAssets.brightness1,
                                    color: Themes().blue,
                                    height: 30,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      // showVolumeSlider = !showVolumeSlider!;
                                    });
                                  },
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  icon: Icon(
                                    MdiIcons.volumeHigh,
                                    color: Themes().blue,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: Text(formatTime(DateTime.now()),
                                      style: GoogleFonts.manrope(
                                        color: Themes().blue,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 6.sp,
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 2.2,
                // left: 0,
                right: 35,
                child: GestureDetector(
                    onTap: () {
                      //
                      goNext(dontDelay: true);
                    },
                    child: Image.asset(ImageAssets.nextArrow,
                        height: 70, width: 60)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
