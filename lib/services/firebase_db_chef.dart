import 'package:food_delivery_app/models/food_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery_app/services/firebase_auth.dart';
import 'package:intl/intl.dart';

class FirebaseMethodsChef {
  static final firestore = FirebaseFirestore.instance;

  FirebaseServices _firebaseServices = FirebaseServices();
  Map timetable = {4: "Breakfast", 12: "Lunch", 17: "Dinner"};

  String tellMeType(int p) {
    if (p >= 4 && p <= 12) {
      return "Breakfast";
    } else if (p > 12 && p <= 17) {
      return "Lunch";
    } else {
      return "Dinner";
    }
  }

  String tellMeDay(String fromDate, String toDate) {
    DateTime now = new DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    DateTime from = new DateFormat("dd-MM-yyyy").parse(fromDate);
    DateTime to = new DateFormat("dd-MM-yyyy").parse(toDate);
    if (now.compareTo(from) >= 0 && now.compareTo(to) <= 0) return "today";
    return "";
  }

  String tellMeDay_daily(String fromDate, String toDate,String selectedDate) {
    DateTime select = new DateFormat("dd-MM-yyyy").parse(selectedDate);
    DateTime from = new DateFormat("dd-MM-yyyy").parse(fromDate);
    DateTime to = new DateFormat("dd-MM-yyyy").parse(toDate);
    if (select.compareTo(from) >= 0 && select.compareTo(to) <= 0) return "today";
    return "";
  }

  String tellMeDayTom(String fromDate, String toDate) {
    DateTime now = new DateTime.now();
    now = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    DateTime from = new DateFormat("dd-MM-yyyy").parse(fromDate);
    DateTime to = new DateFormat("dd-MM-yyyy").parse(toDate);

    if (tomorrow.compareTo(from) >= 0 && tomorrow.compareTo(to) <= 0)
      return "tomorrow";
    return "";
  }

  Stream<List<FoodItem>> getAllFoodItems() {
    print("[INFO] Getting all the food items from the database.");
    String path = "Food_items/";
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        snapshot.docs.map((doc) => FoodItem.fromMap(doc.data())).toList());
  }

  getAllFoodItemImages() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Food_images/").get();
    // var list = querySnapshot.docs;
    // print(list);

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    final allDataid = querySnapshot.docs.map((doc) => doc.id).toList();

    // print(allData);
    // print(allDataid);

    print("[INFO] Getting all the food item images from the database.");
    return [allData, allDataid];
  }

  Stream<List<FoodItem>> getAllFoodItemsForChef() {
    String chefId = _firebaseServices.getUserId();
    print(
        "[INFO] Getting all the food items for particular chef from the database.");
    String path = "Food_items/";
    final reference = FirebaseFirestore.instance.collection(path).where(
          "chefId",
          isEqualTo: chefId,
        );
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        snapshot.docs.map((doc) => FoodItem.fromMap(doc.data())).toList());
  }

  Stream<List<FoodItem>> getAllDailyFoodItemsForChef() {
    String chefId = _firebaseServices.getUserId();
    print(
        "[INFO] Getting all the food items for particular chef from the database.");
    String path = "Food_items/";
    final reference = FirebaseFirestore.instance.collection(path).where(
          "chefId",
          isEqualTo: chefId,
        );
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        snapshot.docs.map((doc) => FoodItem.fromMap(doc.data())).toList());
  }

  Future<void> addFoodItemToDb(FoodItem foodItem) async {
    try {
      print("[INFO] Storing new FoodItem details");
      await firestore.collection("Food_items").doc().set(foodItem.toMap());
      print("[INFO] Stored new FoodItem details");
    } on FirebaseException catch (e) {
      print("[ERROR] ${e.message}");
      throw FirebaseException(
        message: e.message,
        plugin: e.plugin,
        code: e.code,
      );
    } catch (e) {
      print("[ERROR] ${e.toString()}");
      throw e.toString();
    }
  }

  Future getUserDetails(String userId) async {
    try {
      String path = "User/$userId";
      final data = await firestore.doc(path).get().then((value) {
        print("[INFO] User Data = ${value.data()}");
        //print(value.data()['fname']+" "+value.data()['lname']);
        return value.data();
      });
      return data;
    } on FirebaseException catch (e) {
      print("[ERROR] Erro while fetching ${e.code}");
      throw FirebaseException(
          plugin: e.plugin, code: e.code, message: e.message);
    } catch (e) {
      print("[ERROR] Erro while fetching ${e.toString()}");
      throw e.toString();
    }
  }

  Future<void> getACarDetail(String carId) async {
    try {
      print("[INFO] Fetching FoodItem details for carId $carId");
      String path = "Food_items/$carId";
      final data = await firestore.doc(path).get().then((value) {
        print("[INFO] Car Data = ${value.data()}");
        return FoodItem.fromMap(value.data());
      });
      return data;
    } on FirebaseException catch (e) {
      print("[ERROR] Erro while fetching ${e.code}");
      throw FirebaseException(
          plugin: e.plugin, code: e.code, message: e.message);
    } catch (e) {
      print("[ERROR] Erro while fetching ${e.toString()}");
      throw e.toString();
    }
  }

  Future<DocumentSnapshot> fetchQCData(String uid) async {
    return await FirebaseFirestore.instance.collection('QCData').doc(uid).get();
  }

  Future<void> submitQCData(
      String uid, List values, String date, String chefName) async {
    await FirebaseFirestore.instance.collection('QCData').doc(uid).set({
      'name': chefName,
      'values': values,
      'status': 'Not Approved',
      'date': date,
      'comment': ""
    });
  }

  Future<DocumentSnapshot> getChefProfile(String uid) async {
    return FirebaseFirestore.instance.collection('Chef').doc('uid').get();
  }

  Future<void> updateDeliveryStatus(String id, List values) async {
    await FirebaseFirestore.instance
        .collection('Orders')
        .doc(id)
        .update({'isDelivered': values});
  }
}
