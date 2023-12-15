import 'package:flutter/material.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int currentQuestionIndex = 0;

  List<Question> questions = [
    Question('Is Flutter awesome?'),
    Question('Is Dart a great programming language?'),
    Question('Do you enjoy Flutter development?'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yes or No Questions'),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return QuestionWidget(
            question: questions[index],
            onYes: () {
              // Handle "Yes" option for the current question
              print('You selected "Yes" for question $index');
            },
            onNo: () {
              // Handle "No" option for the current question
              print('You selected "No" for question $index');
            },
          );
        },
      ),
    );
  }
}

class Question {

  Question(this.text);
  final String text;
}

class QuestionWidget extends StatelessWidget {

  QuestionWidget(
      {super.key, required this.question, required this.onYes, required this.onNo});
  final Question question;
  final VoidCallback onYes;
  final VoidCallback onNo;

  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            question.text,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              autofocus: clicked,
              onPressed: () {
                onYes;
              },
              child: const Text('Yes'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
                      autofocus: !clicked,
              onPressed: onNo,
              child: const Text('No'),
            ),
          ],
        ),
        const Divider(), // Add a divider between questions
      ],
    );
  }
}
