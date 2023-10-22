import 'dart:ui';

import 'package:flutter/material.dart';

class BackgroundWidget extends StatefulWidget {
  const BackgroundWidget({
    super.key,
  });

  @override
  State<BackgroundWidget> createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget>
    with TickerProviderStateMixin {
  late final AnimationController transitionAnimationController =
      AnimationController(
          animationBehavior: AnimationBehavior.preserve,
          duration: const Duration(seconds: 10),
          reverseDuration: const Duration(seconds: 10),
          vsync: this);

  late final AnimationController scaleAnimationController = AnimationController(
      animationBehavior: AnimationBehavior.preserve,
      duration: const Duration(seconds: 10),
      reverseDuration: const Duration(seconds: 10),
      vsync: this);

  late Animation<double> transitionAnimation =
      Tween<double>(begin: 0, end: 100).animate(transitionAnimationController)
        ..addListener(() {
          setState(() {});
        });

  late Animation<double> scaleAnimation =
      Tween<double>(begin: 1, end: 1.5).animate(scaleAnimationController)
        ..addListener(() {
          setState(() {});
        });

  @override
  void initState() {
    super.initState();

    transitionAnimationController.repeat(reverse: true);
    scaleAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    transitionAnimationController.dispose();
    scaleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              left: -120 + transitionAnimation.value,
              top: 50 + transitionAnimation.value,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.pink.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            Positioned(
              right: 100 - transitionAnimation.value,
              top: 250 - transitionAnimation.value,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.withOpacity(0.1)),
                  width: 150,
                  height: 150,
                ),
              ),
            ),
            Positioned(
              bottom: 200 - transitionAnimation.value,
              right: 50 - transitionAnimation.value,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            Positioned(
              bottom: 100 + transitionAnimation.value,
              left: -150 + transitionAnimation.value,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: const Color(0xFF00FFFF).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            Positioned(
              bottom: -250 + transitionAnimation.value,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                width: 350,
                height: 350,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
