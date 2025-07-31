import 'package:Problem/pages/card_list.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return OnBoardingPage();
  }
}

class OnBoardingPage extends StatelessWidget {
  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => CardListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome",
          body: "This is a Flutter onboarding screen example.",
          image: Center(
              child: Icon(Icons.flutter_dash, size: 100, color: Colors.blue)),
          decoration: PageDecoration(
            titleTextStyle:
                TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 18),
          ),
        ),
        PageViewModel(
          title: "Fast Development",
          body: "Build your app in record time with Flutter.",
          image: const Center(
              child: Icon(Icons.speed, size: 100, color: Colors.green)),
        ),
        PageViewModel(
          title: "Get Started",
          body: "Let’s dive into your Flutter journey!",
          image: const Center(
              child:
                  Icon(Icons.rocket_launch, size: 100, color: Colors.purple)),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // Optional: skip button
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Get Started",
          style: TextStyle(fontWeight: FontWeight.bold)),
      dotsDecorator: DotsDecorator(
        size: Size.square(10),
        activeSize: Size(22, 10),
        activeColor: Colors.deepPurple,
        color: Colors.black26,
        spacing: EdgeInsets.symmetric(horizontal: 3.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
    );
  }
}
