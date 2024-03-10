import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SearchLoader extends StatefulWidget {
  final String loaderMessage;

  const SearchLoader({super.key, required this.loaderMessage});

  @override
  State<SearchLoader> createState() => _SearchLoaderState();
}

class _SearchLoaderState extends State<SearchLoader> {
  double _offsetX = 0.0;
  double _offsetY = 0.0;
  final Random _random = Random();
  late Timer _animationTimer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void dispose() {
    _animationTimer.cancel();
    super.dispose();
  }

  void _startAnimation() {
    _animationTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {
        _offsetX = _random.nextDouble() * 30 - 10;
        _offsetY = _random.nextDouble() * 30 - 10;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            transform: Matrix4.translationValues(_offsetX, _offsetY, 0),
            child: const Icon(Icons.search, color: Colors.blueGrey, size: 200),
          ),
          const SizedBox(height: 10), // Adjust spacing between icon and text
          Text(
            widget.loaderMessage,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ]
    );
  }
}
