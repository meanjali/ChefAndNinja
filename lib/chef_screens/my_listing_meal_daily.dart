import 'package:flutter/material.dart';
import 'package:food_delivery_app/services/firebase_auth.dart';
import 'package:food_delivery_app/services/firebase_db_chef.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:food_delivery_app/models/food_item.dart';
import 'package:food_delivery_app/widgets/custom_listtile.dart';

const kMainColor = Color(0xFFFF785B);
const kSubMainColor = Color(0xFFDEE8FF);
const headingColor = Color(0xFF002140);

class MyListingMealDaily extends StatefulWidget {
  final String screenName = 'Meal Daily';
  @override
  _MyListingMealDailyState createState() => _MyListingMealDailyState();
}

class _MyListingMealDailyState extends State<MyListingMealDaily> {
  FirebaseServices _firebaseServices = FirebaseServices();
  final FirebaseMethodsChef _firebaseMethodsChef = FirebaseMethodsChef();
  DateTime now = DateTime.now();
  DateTime selectedFromDate = DateTime.now();
  TextEditingController _dateControllerFrom = TextEditingController();
  String formattedDate;
  @override
  void initState() {
    setState(() {
      formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
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
        formattedDate = DateFormat('dd-MM-yyyy').format(selectedFromDate);
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
    return Column(children: [
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
                      borderSide:
                          const BorderSide(color: kMainColor, width: 1.0),
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
          child: StreamBuilder<List<FoodItem>>(
              initialData: [],
              stream: _firebaseMethodsChef.getAllFoodItemsForChef(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                    ),
                  );
                }
                List<FoodItem> items = snapshot.data;

                List<FoodItem> breakfastItems = [];
                List<FoodItem> lunchItems = [];
                List<FoodItem> dinnerItems = [];

                final now = new DateTime.now();
                for (int i = 0; i < items.length; i++) {
                  if (items[i].eatTimeType == "meal-daily") {
                    if ("today" ==
                        _firebaseMethodsChef.tellMeDay_daily(items[i].fromDate,
                            items[i].toDate, formattedDate.toString())) {
                      if (items[i].mealType.toLowerCase() == "lunch")
                        lunchItems.add(items[i]);
                      else if (items[i].mealType.toLowerCase() == "dinner")
                        dinnerItems.add(items[i]);
                    } else if (items[i].mealType.toLowerCase() == "breakfast")
                      breakfastItems.add(items[i]);
                  }
                }
                return (breakfastItems.length > 0 ||
                        lunchItems.length > 0 ||
                        dinnerItems.length > 0)
                    ? Column(
                        children: [
                          SizedBox(height: 10),
                          (breakfastItems.length > 0)
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: [
                                      Text("Breakfast",
                                          style: GoogleFonts.lobster(
                                              fontStyle: FontStyle.normal,
                                              color: headingColor,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500)),
                                      Container(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics: ClampingScrollPhysics(),
                                          itemCount: breakfastItems.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            print(breakfastItems[index]);
                                            return MyListTile(
                                            dishname: breakfastItems[index].dishName,
                                            fromtime: breakfastItems[index].fromTime,
                                            totime: breakfastItems[index].toTime,
                                                totquantity:
                                                    breakfastItems[index].count,
                                                price: breakfastItems[index]
                                                    .price);
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Container(),
                          (lunchItems.length > 0)
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: [
                                      Text("Lunch",
                                          style: GoogleFonts.lobster(
                                              fontStyle: FontStyle.normal,
                                              color: headingColor,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500)),
                                      Container(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics: ClampingScrollPhysics(),
                                          itemCount: lunchItems.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            print(lunchItems[index]);
                                            return MyListTile(
                                                dishname:
                                                    lunchItems[index].dishName,
                                                fromtime:
                                                    lunchItems[index].fromTime,
                                                totime:
                                                    lunchItems[index].toTime,
                                                totquantity:
                                                    lunchItems[index].count,
                                                price: lunchItems[index].price);
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Container(),
                          (dinnerItems.length > 0)
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: [
                                      Text("Dinner",
                                          style: GoogleFonts.lobster(
                                              fontStyle: FontStyle.normal,
                                              color: headingColor,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500)),
                                      Container(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics: ClampingScrollPhysics(),
                                          itemCount: dinnerItems.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            print(dinnerItems[index]);
                                            return MyListTile(
                                                dishname:
                                                    dinnerItems[index].dishName,
                                                fromtime:
                                                    dinnerItems[index].fromTime,
                                                totime:
                                                    dinnerItems[index].toTime,
                                                totquantity:
                                                    dinnerItems[index].count,
                                                price:
                                                    dinnerItems[index].price);
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Container()
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Text("No food items added for Daily Subscription",textAlign: TextAlign.center,
                              style: GoogleFonts.lobster(
                                  fontStyle: FontStyle.normal,
                                  color: headingColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                  )),
                          Container(
                            child: Center(
                              child: Lottie.network(
                                "https://assets1.lottiefiles.com/packages/lf20_eQn2Tc.json",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      );
              })),
    ]);
  }
}


