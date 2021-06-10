import 'package:flutter/material.dart';
import 'package:food_delivery_app/services/firebase_db_chef.dart';
import 'package:food_delivery_app/models/food_item.dart';
import 'package:food_delivery_app/widgets/custom_listtile.dart';
import 'package:google_fonts/google_fonts.dart';

const kMainColor = Color(0xFFFF785B);
const kSubMainColor = Color(0xFFDEE8FF);
const headingColor = Color(0xFF002140);

class MyListingTomorrow extends StatelessWidget {
  final FirebaseMethodsChef _firebaseMethodsChef = FirebaseMethodsChef();
  @override
  Widget build(BuildContext context) {
    return Container(
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
                if ("tomorrow" ==
                    _firebaseMethodsChef.tellMeDayTom(
                        items[i].fromDate, items[i].toDate)) {
                  if (_firebaseMethodsChef
                            .tellMeType(int.parse(items[i].fromTime.substring(0,2)))
                            .toLowerCase() == "breakfast")
                    breakfastItems.add(items[i]);
                  else if (_firebaseMethodsChef
                            .tellMeType(int.parse(items[i].fromTime.substring(0,2)))
                            .toLowerCase() == "lunch")
                    lunchItems.add(items[i]);
                  else
                    dinnerItems.add(items[i]);
                }
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Container(
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
                          (breakfastItems.length > 0)
                              ? Container(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemCount: breakfastItems.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      print(breakfastItems[index]);
                                      return MyListTile(
                                          dishname:
                                              breakfastItems[index].dishName,
                                          fromtime:
                                              breakfastItems[index].fromTime,
                                          totime: breakfastItems[index].toTime,
                                          totquantity:
                                              breakfastItems[index].count,
                                          price: breakfastItems[index].price);
                                    },
                                  ),
                                )
                              : Container(
                                  child: Text(
                                    "No Food Items for breakfast",
                                  ),
                                )
                        ],
                      ),
                    ),
                    Container(
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
                          (lunchItems.length > 0)
                              ? Container(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemCount: lunchItems.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      print(lunchItems[index]);
                                      return MyListTile(
                                          dishname: lunchItems[index].dishName,
                                          fromtime: lunchItems[index].fromTime,
                                          totime: lunchItems[index].toTime,
                                          totquantity: lunchItems[index].count,
                                          price: lunchItems[index].price);
                                    },
                                  ),
                                )
                              : Container(
                                  child: Text(
                                    "No Food Items for lunch",
                                  ),
                                )
                        ],
                      ),
                    ),
                    Container(
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
                          (dinnerItems.length > 0)
                              ? Container(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemCount: dinnerItems.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      print(dinnerItems[index]);
                                      return MyListTile(
                                          dishname: dinnerItems[index].dishName,
                                          fromtime: dinnerItems[index].fromTime,
                                          totime: dinnerItems[index].toTime,
                                          totquantity: dinnerItems[index].count,
                                          price: dinnerItems[index].price);
                                    },
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(),
                                  child: Text(
                                    "No Food Items for dinner",
                                  ),
                                )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
