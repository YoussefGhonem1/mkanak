import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rento/src/features/on_boarding/presentation/widgets/custom_button_onboarding.dart';
import 'package:rento/src/shared/routing/app_routes.dart';
import 'package:rento/src/shared/theme/app_colors.dart';

class PageViewItem extends StatelessWidget {
  const PageViewItem({
    super.key,
    required this.image,
    required this.subtitle,
    required this.title,
    required this.isVisible,
    required this.currentPage,
  });

  final String image, subtitle, title;
  final bool isVisible;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: AppColors.teal900,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: isVisible,
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, Routes.logIn);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.03,
                      horizontal: size.width * 0.06,
                    ),
                    child: Text(
                      'تخطى',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.teal50),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: size.width * 0.8,
            height: size.height * 0.4,
            child: SvgPicture.asset(image),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.13),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.05),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.teal50,
                    ),
                  ),
                  SizedBox(height: size.height * 0.015),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.teal50),
                  ),
                  SizedBox(height: 20),
                  DotsIndicator(
                    dotsCount: 3,
                    position: currentPage.toDouble(),
                    decorator: DotsDecorator(
                      color: AppColors.teal50.withAlpha((0.5 * 255).toInt()),
                      activeColor: AppColors.teal50,
                      size: Size(10.0, 10.0),
                      activeSize: Size(22.0, 10.0),
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 23),
                  Visibility(
                    visible: currentPage == 2,
                    maintainState: true,
                    maintainAnimation: true,
                    maintainSize: true,
                    child: CustomButtonOnboarding(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, Routes.logIn);
                      },
                      label: 'ابدأ',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
