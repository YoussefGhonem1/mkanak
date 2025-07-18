import 'package:flutter/material.dart';
import 'package:rento/componants/custom_drawer.dart';
import 'package:rento/linkapi.dart';
import 'package:rento/main.dart';
import 'package:rento/renter/details.dart';
import '../crud.dart';
import '../owner/add_prop.dart';
import '../owner/edit_prop.dart';

class ControlAdmin extends StatefulWidget {
  const ControlAdmin({super.key});

  @override
  State<ControlAdmin> createState() => _ControlAdminState();
}

//with Crud
class _ControlAdminState extends State<ControlAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();
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

  double _calculateAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 400) {
      return 0.72;
    } else if (screenWidth < 800) {
      return 0.82;
    } else {
      return 0.92;
    }
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

  void filterSearch(String query) {
    if (allProperties.isEmpty) {
      print("🔴 No properties available to filter!");
      return;
    }

    setState(() {
      filteredProperties =
          allProperties.where((property) {
            print("🔍 Checking property: ${property['address']}"); // Debugging

            bool matchesSearch =
                query.isEmpty ||
                (property['address'] != null &&
                    property['address'].toString().toLowerCase().contains(
                      query.toLowerCase(),
                    ));

            return matchesSearch;
          }).toList();
    });

    print("✅ Found ${filteredProperties.length} matching properties.");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      key: _scaffoldKey,
      drawer: CustomDrawer(
        crud: _crud,
        userType: sharedPref.getString("type").toString(),
      ),
      appBar: AppBar(
        backgroundColor: Colors.teal[900],
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.teal[50]),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer(); // كده تفتحه بسهولة
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "مكانك",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.teal[50],
              ),
            ),
            SizedBox(
              width:
                  MediaQuery.of(context).size.width *
                  0.45, // 45% of screen width
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "ابحث عن عقار",
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white),
                onChanged: filterSearch,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child:
                    _loading
                        ? const Center(child: CircularProgressIndicator())
                        : allProperties.isEmpty
                        ? Center(
                          child: CircularProgressIndicator(),
                        ) // عرض مؤشر تحميل أثناء جلب البيانات
                        : filteredProperties.isEmpty
                        ? Center(
                          child: Text("لا يوجد عقارات متاحة"),
                        ) // عرض رسالة إذا لم يتم العثور على نتائج
                        : GridView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          physics:
                              AlwaysScrollableScrollPhysics(), // تمكين التمرير
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 300,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: _calculateAspectRatio(
                                  context,
                                ),
                              ),
                          itemCount:
                              filteredProperties
                                  .length, // استخدام filteredProperties
                          itemBuilder: (context, index) {
                            var property =
                                filteredProperties[index]; // استخدام filteredProperties
                            return InkWell(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => RealEstateDetailsPage(
                                          fav: false,
                                          favoriteProperties:
                                              favoriteProperties,
                                          images: List<String>.from(
                                            property['photos'],
                                          ),
                                          videos: List<String>.from(
                                            property['videos'],
                                          ),
                                          id: '${property['id']}',
                                          owner_id: '${property['id']}',
                                          terms_and_conditions:
                                              '${property['terms_and_conditions']}',
                                          title: '${property['address']}',
                                          price: '${property['rent_amount']}',
                                          location: '${property['address']}',
                                          description:
                                              '${property['description']}',
                                          phone: '${property['phone']}',
                                          state:
                                              '${property['property_state']}',
                                          latitude: '${property['latitude']}',
                                          longitude: '${property['longitude']}',
                                          floor_number:
                                              '${property['floor_number']}',
                                          room_count:
                                              '${property['room_count']}',
                                          property_direction:
                                              '${property['property_direction']}',
                                          rating: '${property['rate']}',
                                        ),
                                  ),
                                );
                                loadFavorites();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.teal[100],
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(1, 1),
                                    ),
                                  ],
                                  border: Border.all(
                                    // إضافة الحدود هنا
                                    color: Colors.teal.shade400,
                                    width: 1,
                                  ),
                                ),

                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 3,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Property Image
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ),
                                        child: Image.network(
                                          "$linkImageRoot/${property['photos'][0]}",
                                          height: 110,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 5),

                                      // Property Details
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 10,
                                          left: 3,
                                          top: 5,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on,
                                                    color: Colors.teal[900],
                                                    size: 24,
                                                  ),
                                                  Text(
                                                    (property['address']
                                                                    ?.isNotEmpty ==
                                                                true &&
                                                            property['address']!
                                                                    .length >
                                                                10)
                                                        ? '${property['address']!.substring(0, 10)}...'
                                                        : property['address'] ??
                                                            'لا يوجد عنوان',

                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.teal[900],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.attach_money,
                                                    color: Colors.teal[900],
                                                    size: 20,
                                                  ),
                                                  // السعر
                                                  Text(
                                                    " ${'${property['rent_amount']}'} ج.م",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.teal[900],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                          ],
                                        ),
                                      ),

                                      // Edit and Delete Buttons
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: ElevatedButton.icon(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              EditRealEstatePage(
                                                                realdata:
                                                                    property,
                                                              ),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.mode_edit_outlined,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                                label: const Text(
                                                  'تعديل',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 8,
                                                      ),
                                                  backgroundColor:
                                                      Colors.teal[800],
                                                  textStyle: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 2),
                                            Flexible(
                                              child: ElevatedButton.icon(
                                                onPressed: () async {
                                                  var response = await _crud
                                                      .postRequest(linkDelete, {
                                                        "id":
                                                            property['id']
                                                                .toString(),
                                                      });
                                                  if (response['status'] ==
                                                      "success") {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder:
                                                            (context) =>
                                                                ControlAdmin(),
                                                      ),
                                                    );
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                                label: const Text(
                                                  'حذف',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 8,
                                                      ),
                                                  backgroundColor:
                                                      Colors.red.shade400,
                                                  textStyle: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
              ),
              if (_isLoadingMore)
                const Padding(
                  padding: EdgeInsets.all(5),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
    );
  }
}
