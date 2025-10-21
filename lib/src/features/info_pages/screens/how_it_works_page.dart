import 'package:flutter/material.dart';
import 'package:rento/src/shared/theme/app_colors.dart';

class HowItWorksPage extends StatelessWidget {
  const HowItWorksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.teal50,
      appBar: AppBar(
        backgroundColor: AppColors.teal900,
        title: const Text(
          'كيف يعمل التطبيق',
          style: TextStyle(color: AppColors.teal50),
        ),
        iconTheme: const IconThemeData(color: AppColors.teal50),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مرحباً بك في "مكانك"',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.teal900,
                ),
              ),
              const SizedBox(height: 8),
              _buildSectionContent(
                  'منصتنا مصممة لتجعل عملية تأجير العقارات تجربة سهلة، سريعة، وآمنة للجميع. إليك كيف يعمل التطبيق:'),
              const SizedBox(height: 25),

              // قسم المستأجر
              _buildSectionTitle('للمستأجر: خطوات بسيطة لإيجاد مكانك المثالي'),
              _buildStep(
                icon: Icons.search_rounded,
                title: '1. اكتشف وابحث',
                description:
                    'تصفح آلاف العقارات المتاحة. استخدم فلاتر البحث المتقدمة للعثور على العقار الذي يناسبك من حيث الموقع، السعر، والمواصفات.',
              ),
              _buildStep(
                icon: Icons.calendar_today_rounded,
                title: '2. اختر التواريخ المناسبة',
                description:
                    'بعد اختيار العقار، حدد تواريخ الوصول والمغادرة. يمكنك الاطلاع على تقويم الحجوزات للعقار لتجنب أي تداخل مع حجوزات أخرى. سيظهر لك السعر الإجمالي للإقامة تلقائياً.',
              ),
              _buildStep(
                icon: Icons.send_rounded,
                title: '3. أرسل طلب الحجز',
                description:
                    'بمجرد تحديد التواريخ، قم بإرسال طلب الحجز. سيتم إشعار مالك العقار بطلبك فوراً لمراجعته.',
              ),
              _buildStep(
                icon: Icons.notifications_active_rounded,
                title: '4. الموافقة والدفع المبدئي',
                description:
                    'عندما يوافق المالك على طلبك، سيصلك إشعار يطلب منك تأكيد الحجز عن طريق دفع عربون بقيمة 20% من إجمالي قيمة الإيجار. تتم عملية الدفع بشكل آمن بالكامل داخل التطبيق.',
              ),
              _buildStep(
                icon: Icons.check_circle_rounded,
                title: '5. تأكيد الحجز واستمتع بإقامتك',
                description:
                    'بمجرد إتمام الدفع، يتم تأكيد حجزك رسمياً. المبلغ المتبقي (80%) يتم دفعه عند استلامك للعقار. رحلة سعيدة!',
              ),
              const SizedBox(height: 25),

              // قسم المالك
              _buildSectionTitle('لمالك العقار: اعرض عقارك بسهولة وأمان'),
               _buildStep(
                icon: Icons.add_business_rounded,
                title: '1. أضف عقارك بسهولة',
                description:
                    'قم بإضافة عقارك عبر خطوات بسيطة، مع تحديد كافة التفاصيل الهامة مثل الموقع، السعر اليومي، الصور، والمواصفات.',
              ),
               _buildStep(
                icon: Icons.inbox_rounded,
                title: '2. استقبل طلبات الحجز',
                description:
                    'عندما يهتم مستأجر بعقارك، سيصلك إشعار بطلب الحجز مع كافة التفاصيل المتعلقة بالمدة المطلوبة.',
              ),
               _buildStep(
                icon: Icons.thumb_up_rounded,
                title: '3. وافق على الطلبات',
                description:
                    'راجع تفاصيل الطلب وقم بالموافقة عليه. بعد موافقتك، سيتم توجيه المستأجر لدفع العربون لتأكيد الحجز.',
              ),
                 _buildStep(
                icon: Icons.account_balance_wallet_rounded,
                title: '4. استلم أرباحك بأمان',
                description:
                    'بعد تأكيد الحجز من قبل المستأجر، يتم تحويل المبلغ إلى حسابك عبر التطبيق وفقاً للشروط المحددة، مما يضمن لك عملية تحصيل آمنة وموثوقة.',
              ),
              const SizedBox(height: 25),

              // قسم الأمان
              _buildSectionTitle('الأمان والثقة: أولويتنا'),
              _buildSectionContent(
                  '"مكانك" تعمل كوسيط آمن لضمان حقوق كل من المالك والمستأجر:'),
              _buildInfoPoint(
                  'دفع آمن:', 'جميع عمليات الدفع تتم عبر بوابات دفع موثوقة ومؤمنة بالكامل داخل التطبيق.'),
               _buildInfoPoint(
                  'ضمان الحقوق:', 'نظام العربون يضمن جدية المستأجر ويحفظ حق المالك في الحجز. كما يضمن للمستأجر أن العقار محجوز له بعد الدفع.'),
                _buildInfoPoint(
                  'دعم فني:', 'فريق الدعم الفني متواجد لمساعدتك في حال واجهت أي مشكلة أو كان لديك أي استفسار.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.teal900,
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: TextStyle(
        fontSize: 16,
        color: AppColors.teal800,
        height: 1.5,
      ),
    );
  }

  Widget _buildStep({required IconData icon, required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.orange, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.teal900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.teal800,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

    Widget _buildInfoPoint(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 8.0),
            child: Icon(Icons.check_circle, size: 16, color: AppColors.orange),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.teal800,
                  fontFamily: 'DefaultFont', 
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: '$title ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
