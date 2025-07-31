
import 'dart:async';

import 'package:Problem/components/round_it.dart';
import 'package:flutter/material.dart';

class ScrollablePageView extends StatefulWidget {

  List<dynamic> images;
  ScrollablePageView({super.key, required this.images});

  @override
  State<ScrollablePageView> createState() => _ScrollablePageViewState();
}

class _ScrollablePageViewState extends State<ScrollablePageView> {

 

  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;


@override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _pageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        viewportFraction: 0.97,
        initialPage: _currentPage,
        
      );
    _timer = Timer.periodic(Duration(seconds: 3), (timer){
      if (_currentPage < widget.images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
    _pageController.animateToPage(_currentPage, duration: Durations.extralong1, curve: Curves.easeIn);
    });

    
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PageView(
        controller: _pageController,
        allowImplicitScrolling: true,
      children: widget.images.map((img){
        return FadeInImage(
          fit: BoxFit.contain,
          
          placeholder: Image.network(img['thumbnail_url']).image, 
          image: Image.network(img['image_url']).image);
      }).toList(),
          ),
    );
  }
}