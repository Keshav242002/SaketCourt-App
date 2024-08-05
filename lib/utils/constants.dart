import 'package:flutter/material.dart';

const String kAPIBaseURL = 'https://iif.wtllp.co.in/saket_court/api/';
const String kImagePath = 'https://iif.wtllp.co.in/saket_court/';

String glbAuthToken = '';
String glbToken = '';
String glbID = ''; //registration id
String glbEmail = ''; // email
String glbCity = '';
String glbState = '';
String glbCountry = '';
String glbPinCode = '';
String glbProfilePic = '';
String glbPassword = '';
String glbUserId = '';
String glbPostPic = '';
String glbPlatform = '';
String glbCompany = '';
String glbType = '1';
String glbCustomerId = '';
String glbDesignation = '';
String glbServer='';
String glbMobNo='';
String glbMemName='';
String glbPwd='';
String glbMemCode='';
String glbImage='';
String glbRzpId='rzp_live_bQmqihGpmJxmqt';
String glbVersion = 'V1.2';



const kListNameStyle =
TextStyle(fontSize: 14.0, color: kColorBase, fontWeight: FontWeight.bold);

const kHeadingStyle =
TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: kColorBase);

const kTextFieldStyle =
TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: kColorBase);

const kListNumberStyle = TextStyle(
  fontSize: 12.0,
  color: kColorText,
);

const kPostDetailsStyle = TextStyle(
  fontSize: 10.0,
  color: kColorText,
);

const kCardStyle = TextStyle(
  fontSize: 14.0,
  color: kColorBlue,
);

const kColorText = Color(0xFF90A4AE);
const kColorBlue = Color(0xFF1E88E5);
const kColorGreen = Color(0xFF43A047);
const kColorRed = Color(0xFFDC1817);
const kColorBase = Color(0xFF1B1B1F);
const kColorWhite = Color(0xFFFFFFFF);
const kColorGrey = Color(0xFF727277);
const kColorBrown = Color(0xFF46291E);
const kColorOrange = Color(0xFFDE8661);
const kColorAmber = Color(0xFFFFC107);
const kLogoBlue = Color(0xFF052348);
const kColorMidNightBlue=Color(0xFF002E6E);

const kDialogStyle = TextStyle(
  fontSize: 12.0,
  color: kColorGrey,
);

const kDBTextStyle = TextStyle(
    fontSize: 13,
    //color: Color(0xFF3F51B5),
    color: kColorBase);

const kAlertTextStyle = TextStyle(
    fontSize: 13,
    //color: Color(0xFF3F51B5),
    color: Colors.black);

class Constants {
  Constants._();
  static const double padding = 10;
  static const double avatarRadius = 35;
}
