//import 'package:custom_dialog_flutter_demo/custom_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/auth_screens/temp.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:food_delivery_app/services/firebase_auth.dart';
import 'package:food_delivery_app/services/firebase_db_chef.dart';

const kMainColor = Color(0xFFFF785B);
const kSubMainColor = Color(0xFFDEE8FF);
const headingColor = Color(0xFF002140);

_makingPhoneCall(String phoneNum) async {
  String url = 'tel:' + phoneNum;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 55;
}

class CustomDialogBox extends StatefulWidget {
  final String userName, address, phone, orderId;
  final bool selfDelivery;
  final Image img;
  final int indexNo;
  final List deliveryArray;

  const CustomDialogBox(
      {Key key,
      this.userName,
      this.address,
      this.phone,
      this.img,
      this.selfDelivery,
      this.indexNo,
      this.orderId,
      this.deliveryArray})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  FirebaseServices _firebaseServices = FirebaseServices();
  final FirebaseMethodsChef _firebaseMethodsChef = FirebaseMethodsChef();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              widget.selfDelivery
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "SELF - DELIVERY ",
                          style: TextStyle(
                              color: headingColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        Icon(Icons.check, color: Colors.green[700], size: 30.0)
                      ],
                    )
                  : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        "SELF - DELIVERY ",
                        style: TextStyle(
                            color: headingColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      Icon(Icons.close_outlined,
                          color: Colors.red[800], size: 30.0)
                    ]),
              SizedBox(
                height: screenHeight / 200,
              ),
              Text(
                widget.userName,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: screenHeight / 100,
              ),
              Text(
                widget.address,
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: screenHeight / 100,
              ),
              GestureDetector(
                onTap: () {
                  _makingPhoneCall(widget.phone);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone, color: Colors.green),
                    Text(
                      widget.phone,
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight / 150,
              ),
               widget.selfDelivery
                  ?Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Is Food Delivered ?   ",
                    style: TextStyle(
                        color: headingColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  Checkbox(
                    activeColor: kMainColor,
                    checkColor: kSubMainColor,
                    value: widget.deliveryArray[widget.indexNo],
                    onChanged: (value) async {
                      widget.deliveryArray[widget.indexNo] =
                          !widget.deliveryArray[widget.indexNo];
                      await _firebaseMethodsChef.updateDeliveryStatus(
                          widget.orderId, widget.deliveryArray);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ):Row(),
              Align(
                alignment: Alignment.bottomRight,
                // ignore: deprecated_member_use
                child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Close",
                      style: TextStyle(fontSize: 15),
                    )),
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child: Lottie.network(
                  "https://assets7.lottiefiles.com/packages/lf20_BuxiUX.json",
                  fit: BoxFit.cover,
                )),
          ),
        ),
      ],
    );
  }
}
