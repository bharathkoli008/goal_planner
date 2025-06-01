import 'package:flutter/material.dart';

import '../constants/constants.dart';

AppBar customAppBar(String name){
  return       AppBar(title:  Text(name,style: appFont(16, Colors.white),),backgroundColor: appColor,
  iconTheme: IconThemeData(color: Colors.white
  ));
}