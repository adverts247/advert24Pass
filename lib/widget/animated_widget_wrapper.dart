import 'package:flutter/material.dart';

enum AnimationType {
  slideFromRight,
  slideFromLeft,
  slideFromTop,
  slideFromBottom,
  fadeIn,
}

class AnimatedWidgetWrapper extends StatefulWidget {
  final Widget child;
  final AnimationType animationType;
  final int delay;

  const AnimatedWidgetWrapper({super.key,
    required this.child,
    required this.animationType,
    this.delay = 100,
  });

  @override
  _AnimatedWidgetWrapperState createState() => _AnimatedWidgetWrapperState();
}

class _AnimatedWidgetWrapperState extends State<AnimatedWidgetWrapper> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    switch (widget.animationType) {
      case AnimationType.slideFromRight:
        _offsetAnimation = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
        break;
      case AnimationType.slideFromLeft:
        _offsetAnimation = Tween<Offset>(
          begin: const Offset(-1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
        break;
      case AnimationType.slideFromTop:
        _offsetAnimation = Tween<Offset>(
          begin: const Offset(0.0, -1.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
        break;
      case AnimationType.slideFromBottom:
        _offsetAnimation = Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
        break;
      case AnimationType.fadeIn:
        _fadeAnimation = CurvedAnimation(
          parent: _controller,
          curve: Curves.easeIn,
        );
        break;
    }

    if (widget.delay > 0) {
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (mounted) {
          _controller.forward();
        }
      });
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animationType == AnimationType.fadeIn) {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: widget.child,
      );
    } else {
      return SlideTransition(
        position: _offsetAnimation,
        child: widget.child,
      );
    }
  }
}