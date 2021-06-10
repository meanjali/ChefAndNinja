import 'package:flutter/foundation.dart';
// import 'package:intl/intl.dart';

class FoodItem {
  // final String foodId;
  final String chefId;
  final String dishName;
  final int price;
  final int count;
  final String eatTimeType;
  final String mealType;
  final String imageUrl;
  final String timeStamp;
  final String fromTime;
  final String toTime;
  final String fromDate;
  final String toDate;
  final double rating;
  final String cuisineType;
  final bool self_delivery;

  FoodItem({
    // @required this.foodId,
    @required this.chefId,
    @required this.dishName,
    @required this.price,
    @required this.count,
    @required this.eatTimeType,
    @required this.mealType,
    this.imageUrl,
    @required this.timeStamp,
    @required this.fromTime,
    @required this.toTime,
    @required this.fromDate,
    @required this.toDate,
    @required this.rating,
    @required this.cuisineType,
    @required this.self_delivery,
  });

  factory FoodItem.fromMap(Map<String, dynamic> data) {
    return FoodItem(
        // foodId: data["foodId"],
        chefId: data["chefId"],
        dishName: data["dishName"],
        price: data["price"],
        count: data["count"],
        cuisineType: data['cusineType'],
        eatTimeType:
            data["eatTimeType"], //Eat-now,Eat-later,Eat-tomorrow,Meal-daily
        mealType: data["mealType"], //breakfast,lunch,dinner
        imageUrl: data["imageUrl"],
        timeStamp: data["timeStamp"],
        fromTime: data['fromTime'],
        toTime: data['toTime'],
        fromDate: data['fromDate'],
        toDate: data['toDate'],
        rating: data['rating'],
        self_delivery: data['self_delivery']);
  }

  Map<String, dynamic> toMap() {
    return {
      // "foodId": this.foodId,
      "chefId": this.chefId,
      "dishName": this.dishName,
      "price": this.price,
      "count": this.count,
      "eatTimeType": this.eatTimeType,
      "mealType": this.mealType,
      "imageUrl": this.imageUrl,
      "timeStamp": this.timeStamp,
      "fromTime": this.fromTime,
      "toTime": this.toTime,
      "fromDate": this.fromDate,
      "toDate": this.toDate,
      "rating": this.rating,
      "cuisineType": this.cuisineType,
      "self_delivery": this.self_delivery
    };
  }
}
