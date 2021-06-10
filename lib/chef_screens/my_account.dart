import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/widgets/chef_nav-drawer.dart';
import 'package:food_delivery_app/widgets/chef_appbar.dart';
import 'package:intl/intl.dart';

import 'package:food_delivery_app/services/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

const kMainColor = Color(0xFFFF785B);
const kSubMainColor = Color(0xFFDEE8FF);
const headingColor = Color(0xFF002140);

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  FirebaseServices _firebaseServices = FirebaseServices();

  var chefs;
  bool loading = true;
  double totalEarning = 0;
  int totalItems = 0;
  int totalOrders = 0;
  double totalStars = 0;
  double rating = 0;
  String type;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  String leaveType;
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  String desc;
  final from = TextEditingController(); //from
  final to = TextEditingController(); //to
  int differ = 0;

  Future<DocumentSnapshot> getChefProfile(String uid) async {
    return FirebaseFirestore.instance.collection('Chef').doc(uid).get();
  }

  getChefStats(String uid) async {
    print(uid);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Orders")
        .where(
          "chefId",
          isEqualTo: uid,
        )
        .get();
    final orders = querySnapshot.docs.map((doc) => doc.data()).toList();
    final allDataid = querySnapshot.docs.map((doc) => doc.id).toList();
    double totalEarningX = 0;
    int totalItemsX = 0;

    for (int i = 0; i < orders.length; i++) {
      for (int j = 0; j < orders[i]['quantity'].length; j++) {
        if (orders[i]['isDelivered'][j]) {
          totalEarningX += int.parse(orders[i]['quantity'][j]) *
              double.parse(orders[i]['pricePerServing'][j]);
          totalItemsX += int.parse(orders[i]['quantity'][j]);
        }
      }
    }
    setState(() {
      totalEarning = totalEarningX;
      totalItems = totalItemsX;
      totalOrders = orders.length;
    });

    print("[INFO] Calculating Statistics.");
    return [orders, allDataid];
  }

  getChefStatsUsingDate(String uid) async {
    print(uid);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Orders")
        .where(
          "chefId",
          isEqualTo: uid,
        )
        .get();
    final orders = querySnapshot.docs.map((doc) => doc.data()).toList();
    final allDataid = querySnapshot.docs.map((doc) => doc.id).toList();
    double totalEarningX = 0;
    int totalItemsX = 0;
    int totalOrdersX = 0;

    print(orders);
    for (int i = 0; i < orders.length; i++) {
      String date = orders[i]['timeOrderPlaced'].substring(0, 11);

      print(date);
      var deliveryDate = new DateFormat('d MMM yyyy').parse(date);
      print(deliveryDate);
      print(fromDate);
      if ((fromDate.isBefore(deliveryDate) ||
              fromDate.isAtSameMomentAs(deliveryDate)) &&
          (toDate.isAfter(deliveryDate) ||
              toDate.isAtSameMomentAs(deliveryDate))) {
        totalOrdersX += 1;
        for (int j = 0; j < orders[i]['quantity'].length; j++) {
          print("chosse $deliveryDate");

          if (orders[i]['isDelivered'][j]) {
            totalEarningX += int.parse(orders[i]['quantity'][j]) *
                double.parse(orders[i]['pricePerServing'][j]);
            totalItemsX += int.parse(orders[i]['quantity'][j]);
          }
        }
      }
    }
    setState(() {
      totalEarning = totalEarningX;
      totalItems = totalItemsX;
      totalOrders = totalOrdersX;
    });

    print("[INFO] Calculating Statistics.");
    return [orders, allDataid];
  }

  @override
  void initState() {
    getChefStats(_firebaseServices.getUserId());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    String chefId = _firebaseServices.getUserId();
    return Scaffold(
      drawer: NavDrawer(),
      appBar: ChefAppbar('My Account'),
      body: Container(
          margin: EdgeInsets.all(10),
          child: FutureBuilder(
              future: getChefProfile(chefId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text("Error: ${snapshot.error}"),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> documentData = snapshot.data.data();
                  print(documentData);
                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                            color: Colors.white,
                            child: Container(
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    snapshot.data["imageUrl"]==""?
                                    CircleAvatar(
                                      backgroundColor: Color(0xffE6E6E6),
                                      radius: 60,
                                      child: Icon(
                                        Icons.person,
                                        color: Color(0xffCCCCCC),
                                      )):
                                    CircleAvatar(
                                      radius: 60.0,
                                      backgroundImage: NetworkImage(
                                          snapshot.data["imageUrl"],),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      snapshot.data["fname"],
                                      // "Chef's Name",
                                      style: TextStyle(
                                        fontSize: 35.0,
                                        color: kMainColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Card(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 5.0),
                                      clipBehavior: Clip.antiAlias,
                                      color: kSubMainColor,
                                      elevation: 5.0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 22.0),
                                        child: Container(
                                          width: (screenWidth) * 0.95,
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                "Statistics",
                                                style: TextStyle(
                                                  color: kMainColor,
                                                  fontSize: 25.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Column(
                                                children: [
                                                  Column(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Container(
                                                        child: Text("From",
                                                            style: TextStyle(
                                                              color:
                                                                  headingColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left),
                                                      ),
                                                      Center(
                                                        child: TextField(
                                                            readOnly: true,
                                                            controller: from,
                                                            decoration:
                                                                InputDecoration(
                                                                    hintText:
                                                                        'Pick your Start Date'),
                                                            onTap: () async {
                                                              var date =
                                                                  await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate:
                                                                    DateTime
                                                                        .now(),
                                                                firstDate:
                                                                    DateTime(
                                                                        1900),
                                                                lastDate:
                                                                    DateTime(
                                                                        2100),
                                                                builder: (BuildContext
                                                                        context,
                                                                    Widget
                                                                        child) {
                                                                  return Theme(
                                                                    data: ThemeData
                                                                            .light()
                                                                        .copyWith(
                                                                      colorScheme:
                                                                          ColorScheme
                                                                              .light(
                                                                        primary:
                                                                            kMainColor,
                                                                        onPrimary:
                                                                            Colors.white,
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        child,
                                                                  );
                                                                },
                                                              );
                                                              from.text =
                                                                  formatter
                                                                      .format(
                                                                          date);
                                                              fromDate = date;
                                                            }),
                                                      ),
                                                    ], 
                                                  ),
                                                  Column(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 8.0,
                                                      ),
                                                      Container(
                                                        child: Text("To",
                                                            style: TextStyle(
                                                                color:
                                                                    headingColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            textAlign:
                                                                TextAlign.left),
                                                      ),
                                                      Center(
                                                        child: TextField(
                                                            readOnly: true,
                                                            controller: to,
                                                            decoration:
                                                                InputDecoration(
                                                                    hintText:
                                                                        'Pick your End  Date'),
                                                            onTap: () async {
                                                              var date =
                                                                  await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate:
                                                                    DateTime
                                                                        .now(),
                                                                firstDate:
                                                                    DateTime(
                                                                        1900),
                                                                lastDate:
                                                                    DateTime(
                                                                        2100),
                                                                builder: (BuildContext
                                                                        context,
                                                                    Widget
                                                                        child) {
                                                                  return Theme(
                                                                    data: ThemeData
                                                                            .light()
                                                                        .copyWith(
                                                                      colorScheme:
                                                                          ColorScheme
                                                                              .light(
                                                                        primary:
                                                                            kMainColor,
                                                                        onPrimary:
                                                                            Colors.white,
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        child,
                                                                  );
                                                                },
                                                              );
                                                              to.text =
                                                                  formatter
                                                                      .format(
                                                                          date);
                                                              toDate = date;
                                                            }),
                                                      ),
                                                      Center(
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary:
                                                                      headingColor),
                                                          child: Text("Calculate"
                                                              .toUpperCase()),
                                                          onPressed: () =>
                                                              getChefStatsUsingDate(
                                                                  chefId),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Card(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 5.0),
                                      clipBehavior: Clip.antiAlias,
                                      color: kSubMainColor,
                                      elevation: 5.0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 22.0),
                                        child: Container(
                                          width: (screenWidth) * 0.95,
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                "Ratings",
                                                style: TextStyle(
                                                  color: kMainColor,
                                                  fontSize: 25.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              RatingBarIndicator(
                                                //snapshot.data["fname"]
                                                rating: snapshot.data["rating"]
                                                    .toDouble(),
                                                itemBuilder: (context, index) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                itemCount: 5,
                                                itemSize: 40,
                                                unratedColor: Colors.grey[500],
                                                direction: Axis.horizontal,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Card(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 5.0),
                                      clipBehavior: Clip.antiAlias,
                                      color: kSubMainColor,
                                      elevation: 5.0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 22.0),
                                        child: Container(
                                          width: (screenWidth) * 0.95,
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                "Orders Served",
                                                style: TextStyle(
                                                  color: kMainColor,
                                                  fontSize: 25.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                "$totalOrders",
                                                style: TextStyle(
                                                  fontSize: 22.0,
                                                  color: headingColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Card(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 5.0),
                                      clipBehavior: Clip.antiAlias,
                                      color: kSubMainColor,
                                      elevation: 5.0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 22.0),
                                        child: Container(
                                          width: (screenWidth) * 0.95,
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                "Items served",
                                                style: TextStyle(
                                                  color: kMainColor,
                                                  fontSize: 25.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                "$totalItems",
                                                style: TextStyle(
                                                  fontSize: 22.0,
                                                  color: headingColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Card(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 5.0),
                                      clipBehavior: Clip.antiAlias,
                                      color: kSubMainColor,
                                      elevation: 5.0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 22.0),
                                        child: Container(
                                          width: (screenWidth) * 0.95,
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                "Income",
                                                style: TextStyle(
                                                  color: kMainColor,
                                                  fontSize: 25.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                "$totalEarning",
                                                style: TextStyle(
                                                  fontSize: 22.0,
                                                  color: headingColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 50,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFFFF785B),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })),
    );
  }
}
