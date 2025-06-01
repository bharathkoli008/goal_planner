import 'dart:ui';

import 'package:flutter/src/painting/text_style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

const appColor = Color(0xff171616);
const appGrey = Color(0xff888888);
const appDarkGrey = Color(0xff1A1919);
const appGrey950 = Color(0xff1A1919);
const appGrey970 = Color(0xff1A1919);
const appGrey600 = Color(0xff5D5D5D);
const appGrey50 = Color(0xffF6F6F6);
const appGrey200 = Color(0xffD1D1D1);
const appPurple = Color(0xffAF52DE);
const appTeal = Color(0xff30B0C7);
const appBlue = Color(0xff3D54AD);

const currency = '₹';

TextStyle appFont(double size, Color color,{FontWeight weight = FontWeight.w500}) {
  return GoogleFonts.poppins(
    fontSize: size,
    color: color
  );
}

var logger = Logger();

var indiaFormat = NumberFormat.compactCurrency(locale: 'en_IN',symbol: currency,decimalDigits: 2);