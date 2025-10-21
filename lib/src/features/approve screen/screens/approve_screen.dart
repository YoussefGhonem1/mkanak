import 'package:flutter/material.dart';
import 'package:rento/crud.dart';
import 'package:rento/linkapi.dart';
import 'package:rento/main.dart';
import 'package:rento/src/features/details/screens/details.dart';
import 'package:rento/src/features/edit%20screen/screens/edit_prop.dart';
import 'package:rento/src/shared/componants/custom_drawer.dart';

class Approve extends StatefulWidget {
  const Approve({super.key});

  @override
  State<Approve> createState() => _ApproveState();
}

class _ApproveState extends State<Approve> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();
  final Crud _crud = Crud();
  List<int> favoriteProperties = [];
  List allProperties = [];
  List filteredProperties = [];
  bool _loading = true;

  getRealstates() async {
    var response = await _crud.postRequest(linkGetNotApprove, {});
    if (response['status'] == 'success') {
      setState(() {
        allProperties = response['data'];
        filteredProperties = List.from(allProperties);
        _loading = false;
      });
    }
    return response;
  }

  double _calculateAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 400) {
      return 1.5;
    } else if (screenWidth < 800) {
      return 1.65;
    } else {
      return 1.75;
    }
  }

  void filterSearch(String query) {
    if (allProperties.isEmpty) return;
    setState(() {
      filteredProperties =
          allProperties.where((property) {
            bool matchesSearch =
                query.isEmpty ||
                (property['address'] != null &&
                    property['address'].toString().toLowerCase().contains(
                      query.toLowerCase(),
                    ));
            return matchesSearch;
          }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getRealstates();
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
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  hintText: "ابحث عن عقار",
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: filterSearch,
              ),
            ),
            Row(
              children: [
                Text(
                  "مكانك",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.teal[50],
                  ),
                ),
                const SizedBox(width: 8),
                Image.asset("images/drawer.png", height: 35, width: 35),
              ],
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
                    allProperties.isEmpty
                        ? Center(
                          child: Text(
                            "لا يوجد طلبات تاكيد",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[800],
                            ),
                          ),
                        )
                        : filteredProperties.isEmpty
                        ? Center(child: Text("لا يوجد عقارات متاحة"))
                        : _loading
                        ? const Center(child: CircularProgressIndicator())
                        : GridView.builder(
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1, // One item per row
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: _calculateAspectRatio(
                                  context,
                                ),
                              ),
                          itemCount: filteredProperties.length,
                          itemBuilder: (context, index) {
                            var property = filteredProperties[index];
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
                                    color: Colors.teal.shade400,
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 3,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
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
                                                textDirection:
                                                    TextDirection.rtl,
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
                                                              true)
                                                          ? '${property['address']}'
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
                                                textDirection:
                                                    TextDirection.rtl,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.attach_money,
                                                      color: Colors.teal[900],
                                                      size: 20,
                                                    ),
                                                    Text(
                                                      " ${'${property['rent_amount']}'} L.E",
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
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                  onPressed: () async {
                                                    var response = await _crud
                                                        .postRequest(
                                                          linkApprove,
                                                          {
                                                            "id":
                                                                property['id']
                                                                    .toString(),
                                                          },
                                                        );
                                                    if (response['status'] ==
                                                        "success") {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  Approve(),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  icon: const Icon(
                                                    Icons.approval_outlined,
                                                    size: 18,
                                                    color: Colors.white,
                                                  ),
                                                  label: const Text(
                                                    'موافق',
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
                                                        Colors.teal.shade900,
                                                    textStyle: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
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
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                  onPressed: () async {
                                                    var response = await _crud
                                                        .postRequest(
                                                          linkDelete,
                                                          {
                                                            "id":
                                                                property['id']
                                                                    .toString(),
                                                          },
                                                        );
                                                    if (response['status'] ==
                                                        "success") {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  Approve(),
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
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var response = await _crud.postRequest(linkUpdateStatus, {});
          if (response['status'] == "success") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Approve()),
            );
          }
        },
        backgroundColor: Colors.teal[800],
        child: Text(
          "update",
          style: TextStyle(fontSize: 14, color: Colors.teal[50]),
        ),
      ),
    );
  }
}
