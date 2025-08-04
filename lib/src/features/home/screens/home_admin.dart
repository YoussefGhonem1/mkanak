import 'package:flutter/material.dart';
import 'package:rento/crud.dart';
import 'package:rento/linkapi.dart';
import 'package:rento/main.dart';
import 'package:rento/src/features/add%20screen/screens/add_prop.dart';
import 'package:rento/src/features/details/screens/details.dart';
import 'package:rento/src/shared/componants/card.dart';
import 'package:rento/src/shared/componants/custom_drawer.dart';


class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Crud _crud = Crud();
  List<int> favoriteProperties = [];
  List allProperties = [];
  List filteredProperties = [];
  bool _loading = true;
  ScrollController _scrollController = ScrollController();
  int _limit = 8;
  int _offset = 0;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  // متحكمات حقول البحث داخل الـ Dialog
  TextEditingController searchNameController = TextEditingController();
  TextEditingController searchFromPriceController = TextEditingController();
  TextEditingController searchToPriceController = TextEditingController();
  TextEditingController searchRoomCountController = TextEditingController();

  // متغيرات Dropdown لفلترة الأدوار
  String? selectedFloor;

  // قائمة الأدوار المتاحة
  final List<String> floorOptions = ['أرضي', 'أول', 'ثاني'];
  Future<bool> _handleBackButton() async {
    bool isFiltered = filteredProperties.length != allProperties.length;

    if (isFiltered) {
      // رجّع كل العقارات الأصلية
      setState(() {
        filteredProperties = List.from(allProperties);
      });
      return false; // لا تخرج من الصفحة
    }

    return true; // اخرج من الصفحة عادي
  }

  getRealstates({bool isRefresh = true}) async {
    if (isRefresh) {
      _offset = 0;
      _hasMore = true;
    }

    var response = await _crud.postRequest(linkView, {
      "limit": _limit.toString(),
      "offset": _offset.toString(),
    });

    if (response['status'] == 'success') {
      setState(() {
        _loading = false;
        if (isRefresh) {
          allProperties = response['data'];
        } else {
          allProperties.addAll(response['data']);
        }

        filteredProperties = List.from(allProperties);

        // لو عدد النتائج أقل من الحد، يبقى مفيش بيانات تانية
        if (response['data'].length < _limit) {
          _hasMore = false;
        } else {
          _offset += _limit;
        }
      });
    }
  }

  Future<void> loadMore() async {
    setState(() {
      _isLoadingMore = true;
    });

    await getRealstates(isRefresh: false);

    setState(() {
      _isLoadingMore = false;
    });
  }

  void loadFavorites() async {
    var response = await _crud.postRequest(linkGetFav, {
      "user_id": sharedPref.getString("id").toString(),
    });

    if (response["status"] == "success") {
      setState(() {
        favoriteProperties = List<int>.from(
          response["favorites"].map((id) => id),
        );
      });
    }
  }

  Future<void> load() async {
    // هذه الدالة تعمل ريفريش للصفحة وتجلب كل العقارات الأصلية
    await getRealstates();
    loadFavorites();
    // تأكد من مسح الفلاتر المعروضة في الـ Dialog عشان تبدأ من جديد
    searchNameController.clear();
    searchFromPriceController.clear();
    searchToPriceController.clear();
    searchRoomCountController.clear();
    selectedFloor = null;
    // لا نحتاج لـ setState() هنا لأن getRealstates() و loadFavorites() بيعملوها
  }

  double _calculateAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 400) {
      return 0.65;
    } else if (screenWidth < 800) {
      return 0.75;
    } else {
      return 0.8;
    }
  }

  @override
  void initState() {
    super.initState();
    loadFavorites();
    getRealstates();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          !_isLoadingMore &&
          _hasMore) {
        loadMore();
      }
    });
  }

  // دالة لتطبيق جميع الفلاتر بناءً على المدخلات
  void applyFilters() {
    List tempFiltered = List.from(allProperties);

    String nameQuery = searchNameController.text.toLowerCase();
    String fromPrice = searchFromPriceController.text;
    String toPrice = searchToPriceController.text;
    String roomCountQuery = searchRoomCountController.text;

    // فلتر الاسم
    if (nameQuery.isNotEmpty) {
      tempFiltered =
          tempFiltered.where((property) {
            return property['address'] != null &&
                property['address'].toString().toLowerCase().contains(
                  nameQuery,
                );
          }).toList();
    }

    // فلتر السعر
    double? minP = double.tryParse(fromPrice);
    double? maxP = double.tryParse(toPrice);
    if (minP != null || maxP != null) {
      tempFiltered =
          tempFiltered.where((property) {
            double rentAmount =
                double.tryParse(property['rent_amount'].toString()) ?? 0;
            bool matchesMin = minP == null || rentAmount >= minP;
            bool matchesMax = maxP == null || rentAmount <= maxP;
            return matchesMin && matchesMax;
          }).toList();
    }

    // فلتر عدد الغرف (room_count) - رقمي
    int? targetRoomCount = int.tryParse(roomCountQuery);
    if (targetRoomCount != null) {
      tempFiltered =
          tempFiltered.where((property) {
            int propertyRoomCount =
                int.tryParse(property['room_count']?.toString() ?? '0') ?? 0;
            return propertyRoomCount == targetRoomCount;
          }).toList();
    }

    // فلتر الطابق (floor_number) - مطابقة نصية
    if (selectedFloor != null) {
      tempFiltered =
          tempFiltered.where((property) {
            String propertyFloor = property['floor_number']?.toString() ?? '';
            return propertyFloor == selectedFloor;
          }).toList();
    }

    setState(() {
      filteredProperties = tempFiltered;
    });
    Navigator.pop(context);
  }

  // دالة لمسح جميع مدخلات الفلاتر في الـ Dialog
  void _clearFiltersInDialog(Function setDialogState) {
    setDialogState(() {
      searchNameController.clear();
      searchFromPriceController.clear();
      searchToPriceController.clear();
      searchRoomCountController.clear();
      selectedFloor = null;
    });
  }

  // دالة لعرض الـ Search Dialog
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                backgroundColor: Colors.teal[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                title: Text(
                  "بحث وفلترة العقارات",
                  style: TextStyle(
                    color: Colors.teal[900],
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // حقل البحث بالاسم
                      TextField(
                        controller: searchNameController,
                        decoration: InputDecoration(
                          labelText: "ابحث بالاسم/العنوان",
                          labelStyle: TextStyle(color: Colors.teal[800]),
                          prefixIcon: Icon(
                            Icons.location_on,
                            color: Colors.teal[700],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.teal.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.teal.shade600),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        style: TextStyle(color: Colors.teal[900]),
                      ),
                      const SizedBox(height: 20),

                      // حقول البحث بالسعر
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "البحث حسب السعر",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[900],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchFromPriceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "من",
                                labelStyle: TextStyle(color: Colors.teal[800]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              style: TextStyle(color: Colors.teal[900]),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: searchToPriceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "إلى",
                                labelStyle: TextStyle(color: Colors.teal[800]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              style: TextStyle(color: Colors.teal[900]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // جديد: دمج حقول الطابق وعدد الغرف
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "الطابق وعدد الغرف",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[900],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // الطابق (Dropdown)
                      DropdownButtonFormField<String>(
                        value: selectedFloor,
                        hint: Text(
                          "اختر الطابق",
                          style: TextStyle(color: Colors.teal[800]),
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: [
                          // خيار "مسح الاختيار" للطابق
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text(
                              " اختر الطابق",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          ...floorOptions.map((String floor) {
                            return DropdownMenuItem<String>(
                              value: floor,
                              child: Text(
                                floor,
                                style: TextStyle(color: Colors.teal[900]),
                              ),
                            );
                          }),
                        ],
                        onChanged: (String? newValue) {
                          setDialogState(() {
                            selectedFloor = newValue;
                          });
                        },
                        style: TextStyle(color: Colors.teal[900]),
                      ),
                      const SizedBox(height: 10),
                      // عدد الغرف (TextField)
                      TextField(
                        controller: searchRoomCountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "عدد الغرف (بالضبط)",
                          labelStyle: TextStyle(color: Colors.teal[800]),
                          prefixIcon: Icon(
                            Icons.meeting_room,
                            color: Colors.teal[700],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        style: TextStyle(color: Colors.teal[900]),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[800],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("بحث"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // إغلاق الـ Dialog بدون مسح
                    },
                    child: Text(
                      "إلغاء",
                      style: TextStyle(color: Colors.teal[700]),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      // مسح الفلاتر وإعادة تحميل العقارات الأصلية
                      _clearFiltersInDialog(
                        setDialogState,
                      ); // مسح حقول الـ Dialog
                      Navigator.pop(context); // إغلاق الـ Dialog
                      await load(); // إعادة تحميل العقارات كلها
                    },
                    child: Text(
                      "إلغاء الفلاتر",
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackButton,
      child: Scaffold(
        backgroundColor: Colors.teal[50],
        key: _scaffoldKey,
        /* drawer: const _CustomDrawer(), */
        drawer: CustomDrawer(
          crud: _crud,
          userType: sharedPref.getString("type").toString(),
        ),
        appBar: AppBar(
          backgroundColor: Colors.teal[900],
          leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.teal[50]),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
          title: Row(
            children: [
              Text(
                "مكانك",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.teal[50],
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.search, color: Colors.teal[50]),
                onPressed: _showSearchDialog, // استدعاء الـ dialog عند الضغط
              ),
            ],
          ),
        ),
        body: SafeArea(
          child:
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredProperties.isEmpty
                  ? const Center(child: Text("لا يوجد عقارات متاحة"))
                  : RefreshIndicator(
                    onRefresh: load,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10),
                      controller: _scrollController,
                      itemCount: filteredProperties.length + (_isLoadingMore ? 1 : 0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: _calculateAspectRatio(context),
                      ),
                      itemBuilder: (context, index) {
                       if (_isLoadingMore && index == filteredProperties.length) {
    return const Padding(
      padding: EdgeInsets.all(10),
      child: Center(child: CircularProgressIndicator()),
    );
  }
                        var property = filteredProperties[index];
                        return InkWell(
                          onTap: () async {
                            var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => RealEstateDetailsPage(
                                      fav: false,
                                      favoriteProperties: favoriteProperties,
                                      images: List<String>.from(
                                        property['photos'],
                                      ),
                                      videos: List<String>.from(
                                        property['videos'],
                                      ),
                                      id: '${property['id']}',
                                      owner_id: '${property['owner_id']}',
                                      title: '${property['address']}',
                                      price: '${property['rent_amount']}',
                                      location: '${property['address']}',
                                      description: '${property['description']}',
                                      terms_and_conditions:
                                          '${property['terms_and_conditions']}',
                                      phone: '${property['phone']}',
                                      state: '${property['property_state']}',
                                      latitude: '${property['latitude']}',
                                      longitude: '${property['longitude']}',
                                      floor_number:
                                          '${property['floor_number']}',
                                      room_count: '${property['room_count']}',
                                      property_direction:
                                          '${property['property_direction']}',
                                      rating: '${property['rate']}',
                                    ),
                              ),
                            );
                            if (result == true) await getRealstates();
                            loadFavorites();
                          },
                          child: RealEstateCard(
                            image: "$linkImageRoot/${property['photos'][0]}",
                            title: '${property['address']}',
                            price: '${property['rent_amount']}',
                            location: '${property['address']}',
                            description: '${property['description']}',
                            rate: '${property['rate']}',
                            status: '${property['property_state']}',
                            isFavorite: favoriteProperties.contains(
                              int.parse(property['id']),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
        ),

        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddRealEstatePage()),
              );
            },
            backgroundColor: Colors.teal[800],
            child: Text(
              "اضافه",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.teal[50],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
