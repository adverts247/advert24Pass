import 'dart:async';

import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Timer _timer;
  bool _showModal = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 10), (_) {
      if (!_showModal) {
        showModal();
        
      }
      else{
        Navigator.pop(context);
      }
    });
  }

  void onTap() {
    if (_showModal) {
      Navigator.of(context).pop();
      _showModal = false;
    }
  }

  void showModal() {
    setState(() {
      _showModal = true;
    });

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            height: 200,
            color: Colors.white,
            child: Center(
              child: Text('Modal content'),
            ),
          ),
        );
      },
    ).whenComplete(() {
      setState(() {
        _showModal = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (_showModal) {
            Navigator.of(context).pop();
            _showModal = false;
          } else {
            showModal();
          }
        },
        child: Center(
          child: Text('Tap here'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
