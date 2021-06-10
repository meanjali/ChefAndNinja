import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:lottie/lottie.dart';
import 'package:date_format/date_format.dart';
import 'package:food_delivery_app/chef_screens/view_images.dart';
import 'package:food_delivery_app/widgets/chef_appbar_form.dart';
import 'package:food_delivery_app/widgets/chef_dialog.dart';
import 'package:food_delivery_app/services/firebase_auth.dart';
import 'package:food_delivery_app/widgets/chef_custom_form_field.dart';
import 'package:food_delivery_app/services/firebase_db_chef.dart';
import 'package:food_delivery_app/models/food_item.dart';

const kMainColor = Color(0xFFFF785B);
const kSubMainColor = Color(0xFFDEE8FF);
const headingColor = Color(0xFF002140);

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay addHour(int hour) {
    return this.replacing(hour: this.hour + hour, minute: this.minute);
  }
}

class AddItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: ChefAppbar('Add Food Item'),
        backgroundColor: kSubMainColor,
        body: MyCustomForm(context));
  }
}

class MyCustomForm extends StatefulWidget {
  final BuildContext context1;
  MyCustomForm(this.context1);
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  FirebaseMethodsChef _firebaseMethods = FirebaseMethodsChef();
  Map arguments = {};
  double _height, _width;
  int _count;
  int _price;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _mealType, _dishName, _cuisineType, _eatTimeType;
  bool self_delivery = false;
  String dateTime;
  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();
  File _selectedImage;
  String _selectedImageUrl = "";
  String textToSend;

  TimeOfDay selectedFromTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedToTime = TimeOfDay(hour: 00, minute: 00);

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat('HH:mm');
    return format.format(dt);
  }

  String calculateToTime(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat('HH:mm');
    return format.format(dt);
  }

  TextEditingController _dateControllerFrom = TextEditingController();
  TextEditingController _dateControllerTo = TextEditingController();

  TextEditingController _timeControllerFrom = TextEditingController();
  TextEditingController _timeControllerTo = TextEditingController();
  FirebaseServices _firebaseServices = FirebaseServices();

  List<String> mealType = <String>['Breakfast', 'Lunch', "Dinner"];

  List<String> eatTimeType = <String>[
    "Eat Now",
    "Eat Later",
    "Eat Tomorrow",
    'Meal Daily'
  ];

  Map<String, String> eatTimeTypeDict = {
    "Eat Now": "eat-now",
    "Eat Later": 'eat-later',
    "Eat Tomorrow": 'eat-tomorow',
    'Meal Daily': 'meal-daily'
  };

  List<String> cuisineType = <String>[
    'North Indian',
    'West Indian',
    'Maharashtrian',
    'South Indian',
    'North East Indian',
    'Bengali'
  ];
  bool _loading = false;

  bool validateForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      return true;
    }
    return false;
  }

  Future<void> _submit(BuildContext context) async {
    try {
      setState(() {
        _loading = true;
      });
      // if (_selectedImage != null || _selectedImageUrl != "") {
      // if (_selectedImage != null) {
      //   _selectedImageUrl = await _getDownLoadUrl(context);
      // }

      FoodItem foodDetails = FoodItem(
        imageUrl: _selectedImageUrl,
        chefId: _firebaseServices.getUserId(),
        dishName: _dishName,
        price: _price,
        count: _count,
        mealType: _mealType == null ? "NA" : _mealType,
        eatTimeType: eatTimeTypeDict[_eatTimeType],
        timeStamp: DateTime.now().toString(),
        fromTime: formatTimeOfDay(selectedFromTime),
        toTime: formatTimeOfDay(selectedToTime),
        fromDate: DateFormat('dd-MM-yyyy').format(selectedFromDate).toString(),
        toDate: DateFormat('dd-MM-yyyy').format(selectedToDate).toString(),
        rating: 3.5,
        cuisineType: _cuisineType,
        self_delivery: self_delivery,
      );
      _firebaseMethods.addFoodItemToDb(foodDetails);
      print("[INFO] Successfully Registered");
      Toast.show("Food item added.", context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
          textColor: Colors.white,
          backgroundColor: Colors.green);
      Navigator.pop(context);
      Navigator.of(context).pushNamed('/my_listings');
    } on FirebaseException catch (e) {
      print("[FIREBASE ERROR]");
      await showDialog(
          context: context,
          builder: (context) {
            return DialogBox(
              title: "ERROR",
              buttonText1: 'OK',
              button1Func: () {
                Navigator.of(context).pop();
              },
              icon: Icons.clear,
              description: '${e.message}',
              iconColor: Colors.red,
            );
          });
    } catch (e) {
      print("[ERROR N] ${e.toString()}");
      await showDialog(
          context: context,
          builder: (context) {
            return DialogBox(
              title: "ERROR",
              buttonText1: 'OK',
              button1Func: () {
                Navigator.of(context).pop();
              },
              icon: Icons.clear,
              description: '${e.toString()}',
              iconColor: Colors.red,
            );
          });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  // _uploadImage() async {
  //   var tempImage = await ImagePicker().getImage(source: ImageSource.gallery);
  //   setState(() {
  //     _selectedImage = File(tempImage.path);
  //   });
  // }

  Future<String> _getDownLoadUrl(BuildContext context) async {
    try {
      final Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('food_images/${basename(_selectedImage.path)}');
      final TaskSnapshot task =
          await firebaseStorageRef.putFile(_selectedImage);
      print("[INFO] Successfully stored image in firebase storage.");
      String url = await task.ref.getDownloadURL();
      return url;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Null> _selectDate(BuildContext context, int a) async {
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
        if (a == 0) {
          selectedFromDate = picked;
          _dateControllerFrom.text = DateFormat.yMd().format(selectedFromDate);
        } else {
          selectedToDate = picked;
          _dateControllerTo.text = DateFormat.yMd().format(selectedToDate);
        }
      });
  }

  Future<Null> _selectTime(BuildContext context, int a) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: (a == 0) ? selectedFromTime : selectedToTime,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: kMainColor,
              onPrimary: Colors.white,
              onSurface: kMainColor,
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null)
      setState(() {
        if (a == 0) {
          selectedFromTime = picked;
          _timeControllerFrom.text = formatDate(
              DateTime(
                  2019, 08, 1, selectedFromTime.hour, selectedFromTime.minute),
              [hh, ':', nn, " ", am]).toString();
          if (selectedFromTime.hour > 12) {
            selectedToTime = selectedFromTime.addHour(3);
            _timeControllerTo.text = formatDate(
                DateTime(2019, 08, 1, selectedFromTime.hour + 3,
                    selectedFromTime.minute),
                [hh, ':', nn, " ", am]).toString();
          } else {
            selectedToTime = selectedFromTime.addHour(2);
            _timeControllerTo.text = formatDate(
                DateTime(2019, 08, 1, selectedFromTime.hour + 2,
                    selectedFromTime.minute),
                [hh, ':', nn, " ", am]).toString();
          }
        } else {
          selectedToTime = picked;
          _timeControllerTo.text = formatDate(
              DateTime(2019, 08, 1, selectedToTime.hour, selectedToTime.minute),
              [hh, ':', nn, " ", am]).toString();
        }
      });
  }

  @override
  void initState() {
    super.initState();
    _dateControllerTo.text = DateFormat.yMd().format(DateTime.now());
    _dateControllerFrom.text = DateFormat.yMd().format(DateTime.now());
    _timeControllerFrom.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    _timeControllerTo.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour + 2, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
  }

  final FocusScopeNode _node = FocusScopeNode();
  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());

    return SafeArea(
      child: Stack(
        children: [
          Form(
              key: _formKey,
              child: FocusScope(
                node: _node,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          child: DropdownButtonFormField<String>(
                            hint: Text("Select Eat time type"),
                            value: _eatTimeType,
                            isExpanded: true,
                            onChanged: (String val) {
                              setState(() {
                                _eatTimeType = val;
                              });
                            },
                            validator: (value) => value == null
                                ? 'Eat Time type is required'
                                : null,
                            icon: Icon(Icons.keyboard_arrow_down,
                                color: kMainColor),
                            items: eatTimeType.map((String eattype) {
                              return DropdownMenuItem<String>(
                                value: eattype,
                                child: Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.food_bank,
                                          color: kMainColor,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          eattype,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    )),
                              );
                            }).toList(),
                          ),
                        ),
                        AbsorbPointer(
                          absorbing: _eatTimeType != "Meal Daily",
                          child: Stack(
                            children: [
                              (_eatTimeType != "Meal Daily")
                                  ? new Container(
                                      height: 35,
                                      alignment: Alignment.center,
                                      color: Colors.grey[300],
                                      child: Text("----"))
                                  : Container(),
                              DropdownButtonFormField<String>(
                                hint: Text("Select Meal type"),
                                value: _mealType,
                                isExpanded: true,
                                onChanged: (String val) {
                                  setState(() {
                                    _mealType = val;
                                  });
                                },
                                validator: (value) => (value == null) &&
                                        (_eatTimeType == "Meal Daily")
                                    ? 'Eat Time type is required'
                                    : null,
                                icon: Icon(Icons.keyboard_arrow_down,
                                    color: kMainColor),
                                items: mealType.map((String mealtype) {
                                  return DropdownMenuItem<String>(
                                    value: mealtype,
                                    child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.food_bank,
                                              color: kMainColor,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              mealtype,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ],
                                        )),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          hint: Text("Select Meal Cuisine"),
                          value: _cuisineType,
                          isExpanded: true,
                          onChanged: (String val) {
                            setState(() {
                              _cuisineType = val;
                              textToSend = val;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Cuisine Type is required' : null,
                          icon: Icon(Icons.keyboard_arrow_down,
                              color: kMainColor),
                          items: cuisineType.map((String cuisinetype) {
                            return DropdownMenuItem<String>(
                              value: cuisinetype,
                              child: Container(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.restaurant_menu,
                                        color: kMainColor,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        cuisinetype,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  )),
                            );
                          }).toList(),
                        ),
                        CustomFormField(
                            node: _node,
                            labelText: "Dish Name",
                            validatorStr: "Please enter dish name",
                            prefixicon: Icons.fastfood,
                            onChanged: (val) => _dishName = val),
                        SizedBox(
                          height: 10,
                        ),
                        CustomFormField(
                            node: _node,
                            labelText: "Price per plate" + '\u{20B9}',
                            validatorStr: "Please enter price",
                            prefixicon: Icons.search,
                            type: "num",
                            onChanged: (val) => _price = int.parse(val)),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomFormField(
                            node: _node,
                            labelText: "Count of available plates",
                            validatorStr: "Please enter count",
                            prefixicon: Icons.countertops_sharp,
                            type: "num",
                            onChanged: (val) => _count = int.parse(val)),
                        SizedBox(
                          height: 10,
                        ),
                        CheckboxListTile(
                          secondary: const Icon(Icons.delivery_dining,
                              color: kMainColor, size: 30),
                          title: const Text('Self-delivery'),
                          activeColor: kMainColor,
                          checkColor: kSubMainColor,
                          value: this.self_delivery,
                          onChanged: (bool value) {
                            setState(() {
                              this.self_delivery = value;
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                _selectDate(context, 0);
                              },
                              child: CustomDateTimeContainer(
                                  width: _width,
                                  height: _height,
                                  icon: Icons.calendar_today,
                                  timeController: _dateControllerFrom,
                                  title: "From Date"),
                            ),
                            InkWell(
                              onTap: () {
                                _selectDate(context, 1);
                              },
                              child: CustomDateTimeContainer(
                                  width: _width,
                                  height: _height,
                                  icon: Icons.calendar_today,
                                  timeController: _dateControllerTo,
                                  title: "To Date"),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                _selectTime(context, 0);
                              },
                              child: CustomDateTimeContainer(
                                  width: _width,
                                  height: _height,
                                  timeController: _timeControllerFrom,
                                  icon:Icons.alarm,
                                  title: "From time"),
                            ),
                            AbsorbPointer(
                              absorbing: true,
                              child: CustomDateTimeContainer(
                                  width: _width,
                                  height: _height,
                                  icon:Icons.alarm,
                                  timeController: _timeControllerTo,
                                  title: "To time"),
                            ),
                          ],
                        ),
                        imageUploadWidget(),
                        Center(
                            child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(45, 12, 45, 12),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0),
                              ),
                              primary: kMainColor),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              if (_selectedImageUrl == "") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Please select image')));
                              } else {
                                showAlertDialog(context);
                              }
                            }
                          },
                          child: Text(
                            'Submit',
                            style:
                                TextStyle(fontSize: 16.9, color: Colors.white),
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
              )),
          _loading == true
              ? Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Lottie.asset(
                      "assets/images/food-loading-animation.json",
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget imageUploadWidget() {
    return Column(children: [
      Container(
          margin: EdgeInsets.all(15),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(2, 2),
                spreadRadius: 2,
                blurRadius: 1,
              ),
            ],
          ),
          child:
              // (_selectedImage != null)
              //     ? Image.file(_selectedImage)
              //     : (_selectedImageUrl != "")
              //         ? Image.network(_selectedImageUrl)
              //         :
              //         Image.asset('assets/images/thali.png')

              (_selectedImageUrl != "")
                  ? Image.network(_selectedImageUrl)
                  : Image.asset('assets/images/thali.png')),

      // ignore: deprecated_member_use
      RaisedButton(
        child: Text("Select Image",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14)),
        onPressed: () async {
          final str = await Navigator.push(
              widget.context1,
              MaterialPageRoute(
                  builder: (context) => GalleryScreen(
                        text: textToSend,
                      )));
          setState(() {
            _selectedImageUrl = str;
          });
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.blue)),
        elevation: 5.0,
        color: Colors.blue,
        textColor: Colors.white,
        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        splashColor: Colors.grey,
      ),
      // RaisedButton(
      //   child: Text("Upload Image",
      //       style: TextStyle(
      //           color: Colors.white,
      //           fontWeight: FontWeight.bold,
      //           fontSize: 20)),
      //   onPressed: () {
      //     _uploadImage();
      //   },
      //   shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(18.0),
      //       side: BorderSide(color: Colors.blue)),
      //   elevation: 5.0,
      //   color: Colors.blue,
      //   textColor: Colors.white,
      //   padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      //   splashColor: Colors.grey,
      // ),
    ]);
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        // If the form is valid, display a Snackbar.
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Processing Data')));
        _submit(context);
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Attentions"),
      content: Text("Are you sure , you want to add this food item ?"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class CustomDateTimeContainer extends StatelessWidget {
  final String _title;
  final IconData _icon;
  const CustomDateTimeContainer({
    Key key,
    @required double width,
    @required double height,
    @required TextEditingController timeController,
    @required String title,
     @required IconData icon,
  })  : _width = width,
        _height = height,
        _timeController = timeController,
        _title = title,
        _icon=icon,
        super(key: key);

  final double _width;
  final double _height;
  final TextEditingController _timeController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width / 2.4,
      height: _height / 10,
      alignment: Alignment.center,
      child: TextFormField(
          textAlign: TextAlign.center,
          enabled: false,
          keyboardType: TextInputType.text,
          controller: _timeController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(5),
            prefixIcon: Icon(
              _icon,
              color: kMainColor,
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(color: kMainColor, width: 1.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: kMainColor),
            ),
            focusedBorder: new OutlineInputBorder(
              borderSide: BorderSide(color: kMainColor),
            ),
            labelStyle: new TextStyle(color: headingColor, fontSize: 15),
            labelText: _title,
          )),
    );
  }
}
