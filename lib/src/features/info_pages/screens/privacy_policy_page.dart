import 'package:flutter/material.dart';
import 'package:rento/src/shared/theme/app_colors.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.teal50,
      appBar: AppBar(
        backgroundColor: AppColors.teal900,
        title: const Text(
          'سياسة الخصوصية',
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
                'سياسة الخصوصية لتطبيق "مكانك"',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.teal900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'آخر تحديث: 22 أكتوبر 2025',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('مقدمة'),
              _buildSectionContent(
                  'نحن في تطبيق "مكانك" ("نحن"، "التطبيق") نأخذ خصوصيتك على محمل الجد. توضح هذه السياسة كيفية جمعنا واستخدامنا وحمايتنا لمعلوماتك الشخصية عند استخدامك لخدماتنا. باستخدامك للتطبيق، فإنك توافق على الممارسات الموضحة في هذه السياسة.'),
              const SizedBox(height: 20),
              _buildSectionTitle('1. المعلومات التي نجمعها'),
              _buildSectionContent(
                  'نقوم بجمع أنواع مختلفة من المعلومات لتوفير وتحسين خدماتنا لك:'),
              _buildInfoPoint(
                  'معلومات شخصية:', 'الاسم ورقم الهاتف التي تقدمها عند إنشاء حساب.'),
              _buildInfoPoint('معلومات العقار:',
                  'تفاصيل العقارات التي يضيفها الملاك، مثل الموقع، الصور، السعر، الوصف، وشروط الإيجار.'),
              _buildInfoPoint('معلومات الحجز:',
                  'التواريخ التي تقوم بحجزها، وحالة الدفع، وسجل الحجوزات.'),
              _buildInfoPoint('معلومات فنية:',
                  'معلومات حول جهازك ونظام التشغيل ومعرفات الجهاز الفريدة (مثل FCM Token للإشعارات) لتحسين أداء التطبيق وإرسال الإشعارات الهامة.'),
              _buildInfoPoint('معلومات الدفع:',
                  'عند إجراء عملية دفع، يتم التعامل مع بياناتك المالية من خلال طرف ثالث موثوق (Paymob). نحن لا نقوم بتخزين تفاصيل بطاقتك الائتمانية أو محفظتك الإلكترونية، ولكن قد نحتفظ بمعرفات المعاملات لتأكيد الدفع.'),
              const SizedBox(height: 20),
              _buildSectionTitle('2. كيف نستخدم معلوماتك'),
              _buildSectionContent(
                  'نستخدم المعلومات التي نجمعها للأغراض التالية:'),
              _buildInfoPoint(
                  'تقديم الخدمة:', 'لإنشاء حسابك، وعرض العقارات، وتسهيل عملية الحجز والدفع.'),
              _buildInfoPoint('التواصل معك:',
                  'لإرسال تأكيدات الحجز، وتحديثات الحالة، وإشعارات هامة تتعلق بحسابك أو حجوزاتك.'),
              _buildInfoPoint('تحسين التطبيق:',
                  'لتحليل كيفية استخدام التطبيق، وإصلاح المشاكل التقنية، وتطوير ميزات جديدة.'),
              _buildInfoPoint('الأمان:',
                  'لحماية حسابك ومنع الاحتيال والأنشطة غير المصرح بها.'),
              const SizedBox(height: 20),
              _buildSectionTitle('3. مشاركة المعلومات'),
              _buildSectionContent(
                  'نحن لا نبيع أو نؤجر معلوماتك الشخصية لأطراف ثالثة. قد نشارك معلوماتك في الحالات التالية فقط:'),
              _buildInfoPoint('مزودو الخدمة:',
                  'مع شركاء خارجيين يساعدوننا في تشغيل خدماتنا، مثل بوابات الدفع (Paymob) ومقدمي خدمات الاستضافة، مع التزامهم بالحفاظ على سرية بياناتك.'),
              _buildInfoPoint('الامتثال القانوني:',
                  'إذا طُلب منا ذلك بموجب القانون أو أمر قضائي، أو لحماية حقوقنا وسلامة مستخدمينا.'),
              const SizedBox(height: 20),
              _buildSectionTitle('4. أمن البيانات'),
              _buildSectionContent(
                  'نتخذ تدابير أمنية معقولة لحماية معلوماتك من الوصول غير المصرح به أو التغيير أو الكشف. ومع ذلك، لا توجد طريقة نقل عبر الإنترنت أو تخزين إلكتروني آمنة بنسبة 100%.'),
              const SizedBox(height: 20),
              _buildSectionTitle('5. حقوقك'),
              _buildSectionContent(
                  'لديك الحق في الوصول إلى معلوماتك الشخصية وتحديثها. إذا كنت ترغب في حذف حسابك، يرجى التواصل معنا عبر معلومات الاتصال أدناه.'),
              const SizedBox(height: 20),
              _buildSectionTitle('6. التغييرات على هذه السياسة'),
              _buildSectionContent(
                  'قد نقوم بتحديث سياسة الخصوصية هذه من وقت لآخر. سنقوم بإعلامك بأي تغييرات عن طريق نشر السياسة الجديدة في هذه الصفحة. ننصحك بمراجعة هذه الصفحة بشكل دوري.'),
              const SizedBox(height: 20),
              _buildSectionTitle('7. تواصل معنا'),
              _buildSectionContent(
                  'إذا كانت لديك أي أسئلة حول سياسة الخصوصية هذه، يرجى التواصل معنا على البريد الإلكتروني:'),
              const SelectableText(
                'mkanakcompany@gmail.com', 
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
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

  Widget _buildInfoPoint(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 8.0),
            child: Icon(Icons.circle, size: 8, color: AppColors.teal700),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.teal800,
                  fontFamily:
                      'DefaultFont', // تأكد من استبداله باسم الخط المستخدم في تطبيقك
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
