import 'package:flutter/material.dart';
import 'package:rento/src/features/on_boarding/presentation/widgets/page_view_item.dart';

class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView({
    super.key,
    required this.pageController,
    required this.currentPage,
  });
  final PageController pageController;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: [
        PageViewItem(
          image: "images/imagesImagePageItem1.svg",
          title: 'ابحث عن "مكانك" المثالي',
          subtitle:
              'تصفح آلاف العقارات واعثر بسهولة على المنزل الذي يناسب احتياجاتك',
          isVisible: true,
          currentPage: currentPage,
        ),

        PageViewItem(
          image: "images/imagesImagePageItem2.svg",
          title: 'احجز "مكانك" بخطوات بسيطة',
          subtitle:
              'اختر التواريخ المناسبة وقم بتأكيد حجزك مباشرة عبر التطبيق بأمان وسهولة',
          isVisible: true,
          currentPage: currentPage,
        ),

        PageViewItem(
          image: "images/imagesImagePageItem3.svg",
          title: "استلم مفاتيحك",
          subtitle: "مبروك! أكمل حجزك واستعد للانتقال إلى منزلك الجديد",
          isVisible: false,
          currentPage: currentPage,
        ),
      ],
    );
  }
}
