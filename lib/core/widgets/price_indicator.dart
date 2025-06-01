import 'package:flutter/cupertino.dart';
import 'package:goal_planner/core/constants/constants.dart';

Widget priceIndicator(String header, String price){
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(header,
      style: appFont(8, appPurple),),
      
      SizedBox(
        height: 5,
      ),
      
      
      Text('${currency}${price}',style: appFont(8, CupertinoColors.white),)
    ],
  );
}