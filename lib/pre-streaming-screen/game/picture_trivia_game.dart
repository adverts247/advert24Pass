// Models
import 'package:adverts247Pass/pre-streaming-screen/game/data/trivia_questions_data.dart';
import 'package:adverts247Pass/pre-streaming-screen/game/entertainment_page.dart';
import 'package:adverts247Pass/themes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



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

    // Show explanation and wait before moving to next question
    Future.delayed(const Duration(seconds: 3), () {
      if (currentQuestionIndex < triviaQuestions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          questionAnswered = false;
          selectedAnswerIndex = null;
        });
      } else {
        showGameOverDialog();
      }
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    final question = triviaQuestions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Picture Trivia'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Score: $score/${triviaQuestions.length}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Question counter
            Text(
              'Question ${currentQuestionIndex + 1}/${triviaQuestions.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  question.imageAsset,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Question text
            Text(
              question.question,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Answer options
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  bool isCorrect = index == question.correctAnswerIndex;
                  bool isSelected = index == selectedAnswerIndex;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: questionAnswered
                            ? (isCorrect
                                ? Colors.green
                                : (isSelected ? Colors.red : null))
                            : null,
                        padding: const EdgeInsets.all(16),
                      ),
                      onPressed: () => checkAnswer(index),
                      child: Text(
                        question.options[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
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
    );
  }
}
