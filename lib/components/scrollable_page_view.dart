import 'dart:async';
import 'package:Problem/pages/common_pages/image_view_screen.dart';
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
  late var _imageProvider = [];

  int direction = 0;

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _pageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _imageProvider = widget.images.map((image) {
      return NetworkImage(image['image_url']);
    }).toList();
    _pageController = PageController(
      viewportFraction: 0.97,
      initialPage: _currentPage,
    );

    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage == widget.images.length - 1) {
        direction = -1;
      }

      if (_currentPage == 0) {
        direction = 1;
      }

      if (widget.images.length <= 1) {
        direction = 0;
      }

      _currentPage += direction;

      print('scrollingLEFT: $direction ,  $_currentPage');

      _pageController.animateToPage(_currentPage,
          duration: Durations.extralong1, curve: Curves.easeIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PageView.builder(
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => ImageViewScreen(
                          title: 'Image',
                          imageProvider: NetworkImage(
                              widget.images[index]['image_url']))));
            },
            child: Hero(
              tag: widget.images[index]['image_url'],
              child: FadeInImage(
                  fit: BoxFit.contain,
                  placeholder:
                      Image.network(widget.images[index]['thumbnail_url'])
                          .image,
                  image:
                      Image.network(widget.images[index]['image_url']).image),
            ),
          );
        },
        controller: _pageController,
        allowImplicitScrolling: true,
      ),
    );
  }
}
