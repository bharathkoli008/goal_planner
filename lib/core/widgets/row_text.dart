import 'package:flutter/cupertino.dart';

import '../constants/constants.dart';

Widget rowText (String left, String right){
  return   Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [

      Text(left,style: appFont(13, appPurple,weight: FontWeight.w400),),
      Text(right,style: appFont(14, appPurple,weight: FontWeight.w600))


    ],
  );
}

Widget rowWhiteText (String left, String right){
  return   Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [

      Expanded(child: Text(left,style: appFont(12, appGrey,weight: FontWeight.w400),maxLines: 1,overflow: TextOverflow.ellipsis,)),
      Text(right,style: appFont(13, appGrey,weight: FontWeight.w600))


    ],
  );
}