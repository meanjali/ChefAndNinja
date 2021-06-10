import 'package:flutter/foundation.dart';
// import 'package:intl/intl.dart';

class ContactService {
  final String chefName;
  final String chefId;
  final String feedback;

  ContactService({
    @required this.chefName,
    @required this.chefId,
    @required this.feedback,
  });

  factory ContactService.fromMap(Map<String, dynamic> data) {
    return ContactService(
      chefName: data["chefName"],
      chefId: data["chefId"],
      feedback: data["feedback"],

    );
  }

  Map<String, dynamic> toMap() {
    return {
      "chefId": this.chefId,
      "chefName":this.chefName,
      "feedback": this.feedback,
      
    };
  }
}
