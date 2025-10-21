import 'package:flutter/material.dart';
import 'package:rento/src/features/on_boarding/presentation/widgets/on_boarding_page_body.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: OnBoardingPageBody()),
    );
  }
}
