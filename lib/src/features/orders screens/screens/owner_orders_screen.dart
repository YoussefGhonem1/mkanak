import 'package:flutter/material.dart';
import 'package:rento/crud.dart';
import 'package:rento/linkapi.dart';
import 'package:rento/main.dart';
import 'package:rento/src/shared/theme/theme.dart';


class OwnerOrdersScreen extends StatefulWidget {
  const OwnerOrdersScreen({super.key});

  @override
  State<OwnerOrdersScreen> createState() => _OwnerOrdersScreenState();
}

class _OwnerOrdersScreenState extends State<OwnerOrdersScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Crud _crud = Crud();
  List allReservations = [];
  bool isLoading = true;
  String messageTitle = "تم الموافقه على عرضك";
  String messageBody = "تم الموافقه على عرضك من قبل المالك انتقل للدفع الان";
  String balance = "0.00";

  Future<void> getReservations() async {
    try {
      var response = await _crud.postRequest(linkOwnerOrder, {
        'owner_id': sharedPref.getString("id") ?? '',
      });
      if (response['status'] == 'success') {
        setState(() {
          allReservations = response['data'];
          balance =
              (response['data'][0]['owner']['balance'] ?? "0.00").toString();
          isLoading = false;
        });
      } else {
        print("Failed to load reservations: ${response['message']}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching reservations: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    getReservations();
  }

  Widget _buildReservationCard(Map<String, dynamic> reservation) {
    final transaction = reservation['transaction'];
    final property = reservation['property'];

    final images = property['images'] ?? [];
    final firstImage =
        images.isNotEmpty ? "$linkImageRoot/${images[0]}" : "images/fig.webp";

    final String numberOfPeople = transaction['number_of_people'] ?? "0";
    final String reservationType = transaction['reservation_type'] ?? 'N/A';
    final String startDate = transaction['start_date'] ?? '';
    final String endDate = transaction['end_date'] ?? '';
    final double dailyPrice =
        double.tryParse(property['rent_amount'] ?? '0') ?? 0;

    final DateTime start = DateTime.parse(startDate);
    final DateTime end = DateTime.parse(endDate);
    final int numberOfDays = end.difference(start).inDays + 1;
    final double totalPrice = numberOfDays * dailyPrice;

    return LayoutBuilder(
      builder: (context, constraints) {
        double imageWidth = constraints.maxWidth * 0.36;
        double imageHeight = imageWidth * 1.11;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.teal[100],
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(1, 2),
              ),
            ],
            border: Border.all(color: Colors.teal.shade400, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          firstImage,
                          width: imageWidth,
                          height: imageHeight,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Image.asset(
                                "images/fig.webp",
                                width: imageWidth,
                                height: imageHeight,
                                fit: BoxFit.cover,
                              ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property['address'] ?? 'لا يوجد عنوان',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[900],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  size: 18,
                                  color: Colors.teal[900],
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "${property['rent_amount']} ج.م / يوم",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.teal[900],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            _buildInfoRow("نوع الحجز:", reservationType),
                            _buildInfoRow("عدد الأشخاص:", numberOfPeople),
                            _buildInfoRow("عدد الأيام:", "$numberOfDays"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                // ✅ تاريخ البدء والانتهاء
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: _buildInfoRow(" البدء:", startDate)),
                      const SizedBox(width: 0),
                      Expanded(child: _buildInfoRow(" الانتهاء:", endDate)),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                Directionality(
                  textDirection: TextDirection.rtl,
                  child: _buildInfoRow(
                    "التكلفة الإجمالية:",
                    "${totalPrice.toStringAsFixed(2)} ج.م",
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    transaction['status'] == "confirmed"
                        ? Directionality(
                          textDirection: TextDirection.rtl,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "الحاله: ",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.teal[900],
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    _getStatusText(transaction['status']),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: _getStatusColor(
                                        transaction['status'],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.262,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "حاله الدفع: ",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.teal[900],
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    _getPaymentStatusText(
                                      transaction['payment_status'],
                                    ),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: _getPaymentStatusColor(
                                        transaction['payment_status'],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                        : Directionality(
                          textDirection: TextDirection.ltr,
                          child: Flexible(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal[900],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (ctx) => AlertDialog(
                                        backgroundColor: Colors.teal[50],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        title: Text(
                                          "تأكيد",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.teal[900],
                                          ),
                                        ),
                                        content: Text(
                                          "سوف يتم تاكيد الحجز تلقائيا عند دفع المستاجر 20% من القيمه الاجماليه",
                                          style: TextStyle(
                                            color: Colors.teal[900],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        actionsAlignment:
                                            MainAxisAlignment.center,
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.of(
                                                  ctx,
                                                ).pop(false),
                                            child: Text(
                                              "رفض العرض",
                                              style: TextStyle(
                                                color: Colors.teal[800],
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.teal[800],
                                            ),
                                            onPressed:
                                                () =>
                                                    Navigator.of(ctx).pop(true),
                                            child: Text(
                                              "تاكيد العرض",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );

                                if (confirmed == true) {
                                  await _crud.postRequest(
                                    linkUpdateOrderStatus,
                                    {'id': transaction['id'].toString()},
                                  );
                                  showCustomMessage(
                                    context,
                                    "تم قبول العرض",
                                    isSuccess: true,
                                  );
                                } else if (confirmed == false) {
                                  await _crud.postRequest(linkDeleteOrder, {
                                    'id': transaction['id'].toString(),
                                  });
                                  showCustomMessage(
                                    context,
                                    "تم رفض العرض",
                                    isSuccess: false,
                                  );
                                }
                                getReservations();
                              },
                              child: const Text(
                                "موافقة على العرض",
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'pending':
        return 'بانتظار التاكيد';
      case 'confirmed':
        return 'تم التاكيد';
      default:
        return 'غير ماكد';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.red;
      case 'confirmed':
        return Colors.green[900]!;
      default:
        return Colors.grey;
    }
  }

  String _getPaymentStatusText(String? status) {
    switch (status) {
      case 'pending':
        return 'بانتظار الدفع';
      case 'paid':
        return 'تم الدفع';
      default:
        return 'غير مدفوع';
    }
  }

  Color _getPaymentStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.red;
      case 'paid':
        return Colors.green[900]!;
      default:
        return Colors.grey;
    }
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.teal[800],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.teal[900],
        title: Padding(
          padding: EdgeInsets.only(right: 12),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             
              Text(
                'الرصيد: ${balance}', // جلب الرصيد من sharedPref
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16, // حجم خط أصغر للرصيد
                  color: Colors.amber[300], // لون مميز للرصيد
                ),
              ), 
              Text(
                'الحجوزات',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.teal[50],
                ),
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : allReservations.isEmpty
              ? Center(
                child: Text(
                  'لا توجد حجوزات حالية',
                  style: TextStyle(fontSize: 20, color: Colors.teal[800]),
                ),
              )
              : RefreshIndicator(
                onRefresh: getReservations,
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),

                      itemCount: allReservations.length,
                      itemBuilder:
                          (context, index) =>
                              _buildReservationCard(allReservations[index]),
                    ),
                  ),
                ),
              ),
    );
  }
}
