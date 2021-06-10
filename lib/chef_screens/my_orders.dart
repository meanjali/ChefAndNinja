import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:food_delivery_app/chef_screens/order_details.dart';
import 'package:food_delivery_app/services/firebase_auth.dart';
import 'package:food_delivery_app/services/firebase_db_chef.dart';
import 'package:food_delivery_app/widgets/alert.dart';
import 'package:food_delivery_app/widgets/chef_nav-drawer.dart';
import 'package:food_delivery_app/widgets/customDialogChef.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

const kMainColor = Color(0xFFFF785B);
const kSubMainColor = Color(0xFFDEE8FF);
const headingColor = Color(0xFF002140);

class MyOrders extends StatefulWidget {
  final String screenName = 'My Orders';
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  FirebaseServices _firebaseServices = FirebaseServices();
  final FirebaseMethodsChef _firebaseMethodsChef = FirebaseMethodsChef();
  DateTime now = DateTime.now();
  DateTime selectedFromDate = DateTime.now();
  TextEditingController _dateControllerFrom = TextEditingController();
  String formattedDate;
  @override
  void initState() {
    setState(() {
      formattedDate = DateFormat('d MMM yyyy').format(DateTime.now());
      print("init " + formattedDate);
      _dateControllerFrom.text = DateFormat.yMd().format(DateTime.now());
    });
    super.initState();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedFromDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: kMainColor,
              onPrimary: Colors.white,
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null)
      setState(() {
        selectedFromDate = picked;
        formattedDate = DateFormat('d MMM yyyy').format(selectedFromDate);
        print("format date " + formattedDate);
        _dateControllerFrom.text = DateFormat.yMd().format(selectedFromDate);
        print("hit");
        print(_dateControllerFrom.text);
      });
  }

  @override
  Widget build(BuildContext context) {
    String chefId = _firebaseServices.getUserId();
    print(chefId);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    TextEditingController _dateControllerFrom = TextEditingController();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: headingColor),
          backgroundColor: Colors.white,
          title: Text(widget.screenName,
              style: GoogleFonts.lobster(
                  color: Color(0xff002140),
                  //fontWeight: FontWeight.w600,
                  fontSize: screenHeight * 0.034)),
          centerTitle: true,
          actions: [
            IconButton(
                padding: EdgeInsets.only(left: 5.0),
                iconSize: 30,
                icon: Icon(Icons.exit_to_app, color: headingColor),
                onPressed: () async {
                  AlertMessage()
                      .logOutAlert(context, "Are you sure you want to Logout");
                })
          ],
         
          bottom: TabBar(
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: kMainColor, width: 5.0)),
            tabs: <Widget>[
              Container(
                width: screenWidth / 2,
                child: Tab(
                    child: Text("ACTIVE ORDERS",
                        style: TextStyle(color: kMainColor))),
              ),
              Container(
                width: screenWidth / 2,
                child: Tab(
                    child: Text("COMPLETED ORDERS",
                        style: TextStyle(color: kMainColor))),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Column(
              children: [
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: screenHeight * 0.09,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    child: Center(
                      child: TextFormField(
                          textAlign: TextAlign.center,
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _dateControllerFrom,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.calendar_today,
                                color: kMainColor,
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: kMainColor, width: 1.0),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: kMainColor),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderSide: BorderSide(color: kMainColor),
                              ),
                              labelStyle: new TextStyle(
                                  letterSpacing: 2.0,
                                  color: headingColor,
                                  fontSize: screenWidth * 0.039),
                         
                              labelText: "Selected date : " + formattedDate)),
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Orders")
                          .where(
                            "chefId",
                            isEqualTo: chefId,
                          )
                          .snapshots(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          default:
                            if (snapshot.data != null) {
                              List orders = snapshot.data.docs;
                              List res = [];
                              for (int i = 0; i < orders.length; i++) {
                                for (int j = 0;
                                    j < orders[i]['dishName'].length;
                                    j++) {
                                  if (orders[i]['dateToBeDelivered'][j]
                                              .toString() ==
                                          formattedDate &&
                                      !orders[i]['isDelivered'][j]) {
                                    var order = [];
                                    order.add(orders[i]['dishName'][j]);
                                    order.add(orders[i]['fromTime'][j]);
                                    order.add(orders[i]['toTime'][j]);
                                    order.add(orders[i]['quantity'][j]);
                                    order.add(orders[i]['self_delivery'][j]);
                                    order.add(orders[i]['userPhone']);
                                    order.add(orders[i]['address']);
                                    order.add(orders[i]['userName']);
                                    order.add(j);
                                    order.add(orders[i].id);
                                    order.add(orders[i]['isDelivered']);
                                    res.add(order);
                                  }
                                }
                              }
                              var temp = [];
                              for (int i = 0; i < res.length - 1; i++) {
                                for (int j = 0; j < res.length - i - 1; j++) {
                                  if (res[j][1].compareTo(res[j + 1][1]) == 1) {
                                    temp = res[j];
                                    res[j] = res[j + 1];
                                    res[j + 1] = temp;
                                  }
                                }
                              }
                              if (res.length > 0) {
                                return ListView.builder(
                                    itemCount: res.length,
                                    itemBuilder: (context, index) {
                                      return OrderTile(
                                        dishname: res[index][0],
                                        fromtime: res[index][1],
                                        totime: res[index][2],
                                        totquantity: int.parse(res[index][3]),
                                        selfDelivery: res[index][4],
                                        phone: res[index][5],
                                        address: res[index][6],
                                        userName: res[index][7],
                                        orderStatus: 0,
                                        indexNo:res[index][8],
                                        orderId:res[index][9],
                                        deliveryArray:res[index][10]
                                      );
                                    });
                              } else {
                                return NoOrders(
                                    msg:
                                        "No active orders for selected date ...");
                              }
                            } else {
                              return NoOrders(
                                  msg:
                                      "No active orders for selected date ...");
                            }
                        }
                      }),
                ),
              ],
            ),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: screenHeight * 0.09,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    child: Center(
                      child: TextFormField(
                          textAlign: TextAlign.center,
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _dateControllerFrom,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.calendar_today,
                                color: kMainColor,
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: kMainColor, width: 1.0),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: kMainColor),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderSide: BorderSide(color: kMainColor),
                              ),
                              labelStyle: new TextStyle(
                                  letterSpacing: 2.0,
                                  color: headingColor,
                                  fontSize: screenWidth * 0.039),
                              // labelText: "Select a date".toUpperCase(),
                              labelText: "Selected date: " + formattedDate)),
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Orders")
                          .where(
                            "chefId",
                            isEqualTo: chefId,
                          )
                          .snapshots(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          default:
                            if (snapshot.data != null) {
                              List orders = snapshot.data.docs;
                              List res = [];
                              for (int i = 0; i < orders.length; i++) {

                                for (var j = 0;
                                    j < orders[i]['dishName'].length;
                                    j++) {
                                  if (orders[i]['dateToBeDelivered'][j]
                                              .toString() ==
                                          formattedDate &&
                                      orders[i]['isDelivered'][j]) {
                                    var order = [];
                                    order.add(orders[i]['dishName'][j]);
                                    order.add(orders[i]['fromTime'][j]);
                                    order.add(orders[i]['toTime'][j]);
                                    order.add(orders[i]['quantity'][j]);
                                    order.add(orders[i]['self_delivery'][j]);
                                    order.add(orders[i]['userPhone']);
                                    order.add(orders[i]['address']);
                                    order.add(orders[i]['userName']);
                                    order.add(j);
                                    order.add(orders[i].id);
                                    order.add(orders[i]['isDelivered']);
                                    res.add(order);
                                  }
                                }
                              }
                              print(res);
                              var temp = [];
                              for (int i = 0; i < res.length - 1; i++) {
                                for (int j = 0; j < res.length - i - 1; j++) {
                                  if (res[j][1].compareTo(res[j + 1][1]) == 1) {
                                    temp = res[j];
                                    res[j] = res[j + 1];
                                    res[j + 1] = temp;
                                  }
                                }
                              }
                              if (res.length > 0) {
                                return ListView.builder(
                                    itemCount: res.length,
                                    itemBuilder: (context, index) {
                                      return OrderTile(
                                        dishname: res[index][0],
                                        fromtime: res[index][1],
                                        totime: res[index][2],
                                        totquantity: int.parse(res[index][3]),
                                        selfDelivery: res[index][4],
                                        phone: res[index][5],
                                        address: res[index][6],
                                        userName: res[index][7],
                                        orderStatus: 1,
                                        indexNo:res[index][8],
                                        orderId:res[index][9],
                                        deliveryArray:res[index][10]
                                        //deliveryArray:res[index][]
                                      );
                                    });
                              } else {
                                return NoOrders(
                                    msg:
                                        "No completed orders for selected date ...");
                              }
                            } else {
                              return NoOrders(
                                  msg:
                                      "No completed orders for selected date ...");
                            }
                        }
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NoOrders extends StatelessWidget {
  final String msg;
  NoOrders({
    this.msg,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(msg,
            style: GoogleFonts.lobster(
                fontStyle: FontStyle.normal,
                color: headingColor,
                fontSize: 25,
                fontWeight: FontWeight.w500)),
        Container(
 
          child: Center(
            child: Lottie.network(
              "https://assets2.lottiefiles.com/packages/lf20_vkqybeu5/data.json",
          
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

class OrderTile extends StatelessWidget {
  final String dishname, totime, fromtime, userName, phone, address,orderId;
  final bool selfDelivery;
  final int totquantity, orderStatus,indexNo;
  final List deliveryArray;
  OrderTile({
    @required this.dishname,
    @required this.fromtime,
    @required this.totime,
    @required this.totquantity,
    @required this.selfDelivery,
    @required this.userName,
    @required this.phone,
    @required this.address,
    @required this.orderStatus, 
     this.indexNo,
     this.orderId, this.deliveryArray,
    
  });
  @override
  Widget build(BuildContext context) {
    String fromtimeNew = "",
        totimeNew = "",
        fromStart = "",
        fromEnd = "",
        toStart = "",
        toEnd = "";
    bool showMins = false;
    var diff;
    if (orderStatus == 0) {
      final now = new DateTime.now();
      var format = DateFormat("HH:mm");
      var two = format.parse(totime);
      var one = format.parse(format.format(now).toString());
      diff = two.difference(one).toString();
      if (diff.substring(0, 1) == '-') {
        diff = '0';
        showMins = true;
      } else if (diff.substring(0, 1) == '0') {
        diff = diff.substring(2, 4);
        showMins = true;
      }
      print(diff);
    }

    if (!showMins) {
      fromStart = fromtime.substring(0, 2);
      fromEnd = fromtime.substring(2);
      toStart = totime.substring(0, 2);
      toEnd = totime.substring(2);
      int from = int.parse(fromStart);
      int to = int.parse(toStart);
      if (from > 12) {
        from = from - 12;
        fromStart = from.toString();
        fromtimeNew = fromStart + fromEnd + " PM";
      } else if (from == 12) {
        fromtimeNew = fromtime + " PM";
      } else {
        fromtimeNew = fromtime + " AM";
      }
      if (to > 12) {
        to = to - 12;
        toStart = to.toString();
        totimeNew = toStart + toEnd + " PM";
      } else if (to == 12) {
        totimeNew = totime + " PM";
      } else {
        totimeNew = totime + " AM";
      }
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBox(
                userName: userName,
                address: address,
                phone: phone,
                selfDelivery: selfDelivery,
                indexNo:indexNo,
                orderId:orderId,
                deliveryArray:deliveryArray,
              );
            });
     
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.01, horizontal: screenWidth * 0.02),
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.019, horizontal: screenWidth * 0.043),
          color: kSubMainColor,
          child: Column(children: [
            Row(
  
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                     
                      child: Text(dishname.toUpperCase(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor: screenWidth * 0.0025)),
                ),
                showMins
                    ? Expanded(
                        flex: 2,
                        child: Container(
                          child: Row(
                            children: [
                              Container(
                                  color: Colors.black12,
                                  height: screenHeight * 0.03,
                                  width: 1.5),
                              SizedBox(width: screenWidth * 0.1),
                              Container(
                                  child: Text(diff,
                                      textScaleFactor: screenWidth * 0.0025)),
                              Container(
                                  child: Text(" ",
                                      textScaleFactor: screenWidth * 0.0024)),
                              Container(
                                  child: Text("MINS",
                                      textScaleFactor: screenWidth * 0.0024)),
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        flex: 2,
                        child: Container(
                          child: Row(
                            children: [
                              Container(
                                  color: Colors.black12,
                                  height: screenHeight * 0.03,
                                  width: 1.5),
                              SizedBox(width: screenWidth * 0.025),
                              Container(
                                  child: Text(fromtimeNew,
                                      textScaleFactor: screenWidth * 0.0025)),
                              Container(
                                  child: Text("-",
                                      textScaleFactor: screenWidth * 0.0024)),
                              Container(
                                  child: Text(totimeNew,
                                      textScaleFactor: screenWidth * 0.0024)),
                            ],
                          ),
                        ),
                      ),
                Expanded(
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                            color: Colors.black12,
                            height: screenHeight * 0.03,
                            width: 1.5),
                        SizedBox(width: screenWidth * 0.05),
                        Expanded(
                          child: Container(
                              child: Text(totquantity.toString(),
                                  textScaleFactor: screenWidth * 0.0027)),
                        ),
                        Expanded(
                          child: Container(
                              child: Icon(Icons.arrow_forward_ios,
                                  color: kMainColor)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}

