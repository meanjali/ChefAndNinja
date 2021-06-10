import 'package:flutter/foundation.dart';
// import 'package:intl/intl.dart';

class Chef{

  final String chefName;
  final double rating;
  final int orderServed;
  final String chefImageUrl;

  Chef(
    {
      @required this.chefName,
      @required this.rating,
      @required this.orderServed,
      @required this.chefImageUrl,

      });

  factory Chef.fromMap(Map<String, dynamic> data) {
    return Chef(
      chefName: data["chefName"],
      rating: data["rating"],
      
      orderServed: data["orderServed"],
      chefImageUrl: data["chefImageUrl"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "chefName": this.chefName,
      "rating": this.rating,
      "orderServed": this.orderServed,
      "chefImageUrl": this.chefImageUrl,
    };
  }
}
