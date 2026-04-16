import 'package:flutter/material.dart';
import 'package:rento/crud.dart';
import 'package:rento/linkapi.dart';
import 'package:rento/main.dart';
import 'package:rento/src/features/approve%20screen/screens/approve_screen.dart';
import 'package:rento/src/features/chat/screens/chat_screen.dart';
import 'package:rento/src/features/chatadmin/screens/AdminChatList.dart';
import 'package:rento/src/features/control%20screens/screens/control_admin.dart';
import 'package:rento/src/features/control%20screens/screens/ownerrealstates.dart';
import 'package:rento/src/features/favourits/screens/favorites.dart';
import 'package:rento/src/features/home/screens/home_admin.dart';
import 'package:rento/src/features/home/screens/home_owner.dart';
import 'package:rento/src/features/login/screens/login.dart';
import 'package:rento/src/features/orders%20screens/screens/order_admin_screen.dart';
import 'package:rento/src/features/orders%20screens/screens/owner_orders_screen.dart';
import 'package:rento/src/features/orders%20screens/screens/renter_orders_screen.dart';
import 'package:rento/src/shared/routing/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatelessWidget {
  final Crud crud;
  final String userType;

  const CustomDrawer({super.key, required this.crud, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.teal[900],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // color: Colors.white.withOpacity(0.2),
                    // border: Border.all(color: Colors.white, width: 0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Image.asset("images/drawer.png", fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  (sharedPref.getString("username").toString().isNotEmpty ==
                              true &&
                          sharedPref.getString("username").toString().length >
                              15)
                      ? '${sharedPref.getString("username").toString().substring(0, 15)}'
                      : sharedPref.getString("username").toString(),

                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.teal.shade50,
                  ),
                ),
              ],
            ),

            // Menu Items
            Expanded(
              child: ListView(
                children: [
                  _buildDrawerItem(
                    context,
                    title: "الصفحه الرئيسية",
                    icon: Icons.home,
                    onTap: () {
                      // بناءً على نوع المستخدم، يروح للصفحة الرئيسية بتاعته
                      if (userType == "admin") {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeAdmin(),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeOwner(),
                          ),
                        );
                      }
                    },
                  ),
                  const Divider(color: Colors.white54, height: 10),

                  // صفحة الحساب
                  userType != "renter"
                      ? _buildDrawerItem(
                        context,
                        title: "حسابى",
                        icon: Icons.account_circle,
                        onTap: () {
                          if (userType == "owner") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OwnerRealstate(),
                              ),
                            );
                          } else if (userType == "admin") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ControlAdmin(),
                              ),
                            );
                          }
                          // لو renter ممكن ميكنش ليها صفحة حساب منفصلة
                        },
                      )
                      : SizedBox.shrink(), // لو مش owner أو admin مش هتظهر
                  userType != "renter"
                      ? const Divider(color: Colors.white54, height: 10)
                      : SizedBox.shrink(),

                  // صفحة الطلبات
                /*   _buildDrawerItem(
                    context,
                    title:
                        userType == "admin"
                            ? "الطلبات"
                            : userType == "owner"
                            ? "الطلبات على عقاراتى"
                            : "طلباتى",
                    icon: Icons.list_alt,
                    onTap: () {
                      if (userType == "admin") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderAdminScreen(),
                          ),
                        );
                      } else if (userType == "owner") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OwnerOrdersScreen(),
                          ),
                        );
                      } else {
                        // renter
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RenterOrdersScreen(),
                          ),
                        );
                      }
                    },
                  ),
                  const Divider(color: Colors.white54, height: 10), */

                  // صفحة المفضلة
                  _buildDrawerItem(
                    context,
                    title: "المفضلة",
                    icon: Icons.favorite,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Favorite(),
                        ),
                      );
                    },
                  ),
                  // شرط عرض "طلبات التأكيد" للأدمن فقط
                  if (userType == "admin") ...[
                    // ✅ استخدام spread operator لتضمين عناصر مشروطة
                    const Divider(color: Colors.white54, height: 10),
                    _buildDrawerItem(
                      context,
                      title: "طلبات التاكيد",
                      icon: Icons.approval,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Approve(),
                          ),
                        );
                      },
                    ),
                  ],
                  const Divider(color: Colors.white54, height: 10),

                  // تواصل معنا
                  _buildDrawerItem(
                    context,
                    title: "تواصل معنا",
                    icon: Icons.contact_support,
                    onTap: () async {
                      try {
                        // استخدام الـ crud object الممرر
                        var response = await crud.postRequest(linkCreateChat, {
                          "user_id": sharedPref.getString("id").toString(),
                        });

                        if (response['status'] == "success" &&
                            response.containsKey('chat_id')) {
                          // توجيه لصفحة الشات الخاصة بالأدمن لو المستخدم أدمن
                          if (userType == "admin") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AdminChatList(),
                              ),
                            );
                          } else {
                            // للمالك والمستأجر
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ChatScreen(
                                      chatId: int.parse(
                                        response['chat_id'].toString(),
                                      ),
                                      userId: int.parse(
                                        sharedPref.getString("id")!,
                                      ),
                                    ),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                response['message'] ?? "فشل إنشاء المحادثة",
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("حدث خطأ: ${e.toString()}")),
                        );
                      }
                    },
                  ),
                  const Divider(color: Colors.white54, height: 10),
                  _buildDrawerItem(
                    context,
                    title: "سياسة الخصوصية",
                    icon: Icons.privacy_tip_outlined, // أيقونة مناسبة
                    onTap: () {
                      Navigator.pop(context); // إغلاق الـ Drawer أولاً
                      Navigator.pushNamed(
                        context,
                        Routes.privacyPolicy,
                      ); // الذهاب لصفحة سياسة الخصوصية
                    },
                  ),
                  const Divider(color: Colors.white54, height: 10), // فاصل
                  // **== العنصر الجديد: كيف يعمل التطبيق ==**
                  _buildDrawerItem(
                    context,
                    title: "كيف يعمل التطبيق",
                    icon: Icons.help_outline, // أيقونة مناسبة
                    onTap: () {
                      Navigator.pop(context); // إغلاق الـ Drawer أولاً
                      Navigator.pushNamed(
                        context,
                        Routes.howItWorks,
                      ); // الذهاب لصفحة الشرح
                    },
                  ),
                  const Divider(color: Colors.white54, height: 10),

                  // ✅ جديد: رقم التواصل للشركة
                  _buildDrawerItem(
                    context,
                    title: "تواصل مع الشركة",
                    icon: Icons.phone,
                    onTap: () async {
                      const phoneNumber = '01014395851'; // رقم الهاتف المطلوب
                      final url = 'tel:$phoneNumber';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('لا يمكن الاتصال بالرقم المحدد.'),
                          ),
                        );
                      }
                    },
                  ),
                  const Divider(color: Colors.white54, height: 10),
                  _buildDrawerItem(
                    context,
                    title: "تسجيل الخروج",
                    icon: Icons.logout,
                    onTap: () async {
                      await crud.postRequest(linkDeleteUserFcmToken, {
                        "user_id": sharedPref.getString("id").toString(),
                      });
                      sharedPref.clear();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      title: Text(
        title,
        style: TextStyle(fontSize: 18, color: Colors.teal.shade50),
      ),
      leading: Icon(icon, color: Colors.teal.shade50, size: 26),
      minLeadingWidth: 30,
      onTap: onTap,
    );
  }
}
