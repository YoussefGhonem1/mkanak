import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:rento/crud.dart';
import 'package:rento/linkapi.dart';
import 'package:rento/main.dart';
import 'package:rento/src/features/home/screens/home_admin.dart';
import 'package:rento/src/features/home/screens/home_owner.dart';

class AddRealEstatePage extends StatefulWidget {
  const AddRealEstatePage({super.key});

  @override
  _AddRealEstatePageState createState() => _AddRealEstatePageState();
}

class _AddRealEstatePageState extends State<AddRealEstatePage> {
  bool isLoading = false;
  final Crud _crud = Crud();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _walletController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _rentAmountController = TextEditingController();
  final TextEditingController _saleAmountController = TextEditingController();
  final TextEditingController _termsAndConditionsController =
      TextEditingController();
  final List<File> _selectedImages = [];
  final List<File> _selectedVideos = [];

  String? selectedFloor; // لتخزين القيمة المختارة
  int? selectedRooms; // لتخزين القيمة المختارة
  String? selectedDirection; // لتخزين القيمة المختارة

  // Pick multiple images
  Future<void> _pickImages() async {
    final pickedImages = await ImagePicker().pickMultiImage();
    if (pickedImages.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(
          pickedImages.map((pickedFile) => File(pickedFile.path)).toList(),
        );
      });
    }
  }

  // Upload images and videos
  addRealEstate() async {
    isLoading = true;
    setState(() {});

    try {
      var response = await _crud.postRequestWithMultipleFiles(
        linkAdd,
        {
          "owner_id": sharedPref.getString("id").toString(),
          "address": _locationController.text,
          "description": _descriptionController.text,
          "phone": _phoneController.text,
          "wallet_number": _walletController.text,
          "rent_amount": _rentAmountController.text,
          "sale_amount": _saleAmountController.text,
          "floor_number": selectedFloor.toString(),
          "room_count": selectedRooms.toString(),
          "property_direction": selectedDirection.toString(),
          "terms_and_conditions": _termsAndConditionsController.text,
        },
        _selectedImages,
        _selectedVideos,
      );

      isLoading = false;
      setState(() {});

      if (response != null && response['status'] == "success") {
        sharedPref.getString("type") == "admin"
            ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeAdmin()),
            )
            : Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeOwner()),
            );
      } else {
        print("Adding real estate failed");
      }
    } catch (e) {
      isLoading = false;
      setState(() {});
      print("Exception occurred: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.teal[50],
          ), // أو أيقونة تانية تعجبك
          onPressed: () {
            Navigator.pop(context); // الرجوع للصفحة السابقة
          },
        ),
        title: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 12),
            child: Text(
              "العوده الى الرئيسيه",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.teal[50],
              ),
            ),
          ),
        ),
        backgroundColor: Colors.teal[900],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "اعرض عقارك وتواصل مع الالاف",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: _pickImages,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal[800],
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 45,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  "اضافه صور",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.teal[50],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "ليس اجبارى و لكن ضروري لتساعد الآخرين على اتخاذ القرار",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.teal[50],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _selectedImages.isNotEmpty
                            ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children:
                                    _selectedImages.asMap().entries.map((
                                      entry,
                                    ) {
                                      final index = entry.key;
                                      final file = entry.value;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.teal.shade100,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.file(
                                                  file,
                                                  width: 200,
                                                  height: 250,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            // زر الحذف
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: Material(
                                                color: Colors.redAccent,
                                                shape: CircleBorder(),
                                                elevation: 2,
                                                child: InkWell(
                                                  customBorder: CircleBorder(),
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedImages.removeAt(
                                                        index,
                                                      );
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          4.0,
                                                        ),
                                                    child: Icon(
                                                      Icons.close,
                                                      size: 18,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                              ),
                            )
                            : const SizedBox.shrink(),

                        const SizedBox(height: 10),
                        Form(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  // حقل الموقع
                                  TextFormField(
                                    controller: _locationController,
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    decoration: InputDecoration(
                                      label: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "الموقع",
                                          style: TextStyle(
                                            color: Colors.teal[900],
                                          ),
                                        ),
                                      ),
                                      hintText: "(مكان يسهل فتحه على الخريطه)",
                                      hintStyle: TextStyle(
                                        color: Colors.teal[900],
                                        fontSize: 14,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.teal[900]!,
                                        ),
                                      ),
                                      suffixIcon: Icon(
                                        Icons.location_on,
                                        color: Colors.teal[900],
                                      ),
                                      alignLabelWithHint: true,
                                      isDense: true,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "الرجاء إدخال الموقع";
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  // قسم رقم الطابق
                                  DropdownButtonFormField<String>(
                                    value: selectedFloor,
                                    decoration: InputDecoration(
                                      label: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          'رقم الطابق',
                                          style: TextStyle(
                                            color: Colors.teal[900],
                                          ),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    dropdownColor:
                                        Colors.teal[50], // لون خلفية القائمة
                                    iconEnabledColor: Colors.teal[900],
                                    borderRadius: BorderRadius.circular(15),
                                    style: TextStyle(
                                      color:
                                          Colors
                                              .teal[900], // لون النص بعد الاختيار
                                      fontSize: 16,
                                    ),
                                    items:
                                        [
                                          'أرضي',
                                          'أول',
                                          'ثاني',
                                          'ثالث',
                                          'رابع',
                                          'خامس',
                                        ].map((floor) {
                                          return DropdownMenuItem(
                                            value: floor,
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              floor,
                                              textAlign: TextAlign.right,
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                color: Colors.teal[900],
                                                fontSize: 16,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedFloor = value;
                                      });
                                    },
                                    isExpanded: true,
                                    menuMaxHeight: 300,
                                    selectedItemBuilder: (context) {
                                      return [
                                        'أرضي',
                                        'أول',
                                        'ثاني',
                                        'ثالث',
                                        'رابع',
                                        'خامس',
                                      ].map((floor) {
                                        return Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            selectedFloor ?? floor,
                                            textAlign: TextAlign.right,
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                              color: Colors.teal[900],
                                              fontSize: 16,
                                            ),
                                          ),
                                        );
                                      }).toList();
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  // قسم عدد الغرف
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'عدد الغرف',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal[900],
                                        ),
                                      ),
                                      Wrap(
                                        spacing: 10,
                                        children:
                                            [1, 2, 3, 4, 5].map((room) {
                                              return ChoiceChip(
                                                label: Text('$room'),
                                                selected: selectedRooms == room,
                                                onSelected: (bool selected) {
                                                  setState(() {
                                                    selectedRooms =
                                                        selected ? room : null;
                                                  });
                                                },
                                              );
                                            }).toList(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  DropdownButtonFormField<String>(
                                    value: selectedDirection,
                                    decoration: InputDecoration(
                                      label: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          'واجهة العقار',
                                          style: TextStyle(
                                            color: Colors.teal[900],
                                          ),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    dropdownColor:
                                        Colors.teal[50], // لون خلفية القائمة
                                    iconEnabledColor: Colors.teal[900],
                                    borderRadius: BorderRadius.circular(15),
                                    style: TextStyle(
                                      color:
                                          Colors
                                              .teal[900], // لون النص بعد الاختيار
                                      fontSize: 16,
                                    ),
                                    items:
                                        [
                                          'بحري',
                                          'قبلي',
                                          'غربي',
                                          'شرقي',
                                          'بحري غربي',
                                          'قبلي شرقي',
                                          'بحري شرقي',
                                          'قبلي غربي',
                                        ].map((dir) {
                                          return DropdownMenuItem(
                                            value: dir,
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              dir,
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                color: Colors.teal[900],
                                                fontSize: 16,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedDirection = value;
                                      });
                                    },
                                    isExpanded: true,
                                    menuMaxHeight: 300,
                                    selectedItemBuilder: (context) {
                                      return [
                                        'بحري',
                                        'قبلي',
                                        'غربي',
                                        'شرقي',
                                        'بحري غربي',
                                        'قبلي شرقي',
                                        'بحري شرقي',
                                        'قبلي غربي',
                                      ].map((dir) {
                                        return Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            selectedDirection ?? dir,
                                            textAlign: TextAlign.right,
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                              color: Colors.teal[900],
                                              fontSize: 16,
                                            ),
                                          ),
                                        );
                                      }).toList();
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  // حقل الوصف
                                  TextFormField(
                                    controller: _descriptionController,
                                    maxLines: 4,
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    decoration: InputDecoration(
                                      label: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "الوصف",
                                          style: TextStyle(
                                            color: Colors.teal[900],
                                          ),
                                        ),
                                      ),
                                      labelStyle: TextStyle(
                                        color: Colors.teal[900],
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none,
                                      ),
                                      alignLabelWithHint: true,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "الرجاء إدخال الوصف";
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  // الشروط
                                  TextFormField(
                                    controller: _termsAndConditionsController,
                                    maxLines: 4,
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    decoration: InputDecoration(
                                      label: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "الشروط التى يجب ان يتبعها المستأجر",
                                          style: TextStyle(
                                            color: Colors.teal[900],
                                          ),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none,
                                      ),
                                      alignLabelWithHint: true,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "الرجاء إدخال الشروط";
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  // رقم الهاتف
                                  TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    decoration: InputDecoration(
                                      label: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "رقم الهاتف",
                                          style: TextStyle(
                                            color: Colors.teal[900],
                                          ),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none,
                                      ),
                                      suffixIcon: Icon(
                                        Icons.phone,
                                        color: Colors.teal[900],
                                      ),
                                      alignLabelWithHint: true,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "الرجاء إدخال رقم الهاتف";
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  // تكلفة الإيجار
                                  TextFormField(
                                    controller: _rentAmountController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    decoration: InputDecoration(
                                      label: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "تكلفة الإيجار",
                                          style: TextStyle(
                                            color: Colors.teal[900],
                                          ),
                                        ),
                                      ),
                                      hintText:
                                          "يتم خصم 10% من قيمه الايجار رسوم",
                                      hintStyle: TextStyle(
                                        color: Colors.teal[900],
                                        fontSize: 14,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.teal[900]!,
                                        ),
                                      ),
                                      suffixIcon: Icon(
                                        Icons.attach_money,
                                        color: Colors.teal[900],
                                      ),
                                      alignLabelWithHint: true,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "الرجاء إدخال التكلفة";
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  // رقم الفيزا / المحفظة
                                  TextFormField(
                                    controller: _walletController,
                                    keyboardType: TextInputType.phone,
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    decoration: InputDecoration(
                                      label: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "رقم فيزا او محفظه كاش",
                                          style: TextStyle(
                                            color: Colors.teal[900],
                                          ),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none,
                                      ),
                                      suffixIcon: Icon(
                                        Icons.credit_card,
                                        color: Colors.teal[900],
                                      ),
                                      alignLabelWithHint: true,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "الرجاء إدخال رقم الفيزا او المحفظه";
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 30),

                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        // عرض مربع الحوار
                                        final confirmed = await showDialog<
                                          bool
                                        >(
                                          context: context,
                                          barrierDismissible:
                                              false, // لمنع الإغلاق بالضغط خارج الصندوق
                                          builder:
                                              (ctx) => AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                backgroundColor:
                                                    Colors.teal[50],
                                                title: Text(
                                                  'تأكيد',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.teal[900],
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                content: Text(
                                                  'هل أنت متأكد من إضافة العقار؟',
                                                  style: TextStyle(
                                                    color: Colors.teal[900],
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                actionsAlignment:
                                                    MainAxisAlignment.center,
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(
                                                        ctx,
                                                      ).pop(false);
                                                    },
                                                    child: Text(
                                                      'إلغاء',
                                                      style: TextStyle(
                                                        color: Colors.teal[900],
                                                      ),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.teal[800],
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(
                                                        ctx,
                                                      ).pop(true);
                                                    },
                                                    child: Text(
                                                      'متأكد',
                                                      style: TextStyle(
                                                        color: Colors.teal[50],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        );

                                        // إذا اختار "متأكد" ننفذ الإضافة
                                        if (confirmed == true) {
                                          addRealEstate();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal[800],
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15,
                                          horizontal: 125,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "إضافة العقار",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.teal[50],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
