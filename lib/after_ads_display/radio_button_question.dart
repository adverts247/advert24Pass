import 'package:flutter/material.dart';

class QuestionPage extends StatefulWidget {
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
        title: Text('Yes or No Questions'),
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
  final String text;

  Question(this.text);
}

class QuestionWidget extends StatelessWidget {
  final Question question;
  final VoidCallback onYes;
  final VoidCallback onNo;

  bool clicked = false;

  QuestionWidget(
      {required this.question, required this.onYes, required this.onNo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            question.text,
            style: TextStyle(fontSize: 24),
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
              child: Text('Yes'),
            ),
            SizedBox(width: 16),
            ElevatedButton(
                      autofocus: !clicked,
              onPressed: onNo,
              child: Text('No'),
            ),
          ],
        ),
        Divider(), // Add a divider between questions
      ],
    );
  }
}
