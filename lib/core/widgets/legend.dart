import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goal_planner/core/constants/constants.dart';

Widget legend(String name, Color nameColor){
  return Container(
    child: Row(
      
      children: [

        Container(
          height: 8,
          width: 8,
          color: nameColor,
        ),

        SizedBox(
          width: 5,
        ),
        
        Text(name,style: appFont(10, Colors.white),)
        
      ],
      
    ),
  );
}

Widget legendSpacer(){
  return   Container(
    height: 16,
    width: 16,
    child: Center(
      child: Container(
        height: 2,
        width: 2,
        color: appGrey,
      ),
    ),
  );
}