import 'package:flutter/material.dart';

const kMainColor = Color(0xFFFF785B);
const kSubMainColor = Color(0xFFDEE8FF);
const headingColor = Color(0xFF002140);

class TempPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kSubMainColor,
      //  child: Text("hhii")
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Users:"),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/chef');
            },
            child: Text("Chef"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/chefs');
            },
            child: Text("Chef Ninja"),
          ),
        ],
      ),
    );
  }
}
