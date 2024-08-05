import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:saketcourt/screens/Dashboard.dart';
import '../components/my_button.dart';
import '../components/my_text_field_white.dart';
import '../components/my_visible_indicator.dart';
import '../utils/constants.dart';
import '../utils/my_logo_alert.dart';
import 'login_screen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});
  static const String id = 'forgot_password';

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var fireApp;
  bool isLoading = false;
  double scrWidth = 0;
  String myPwd = '';
  TextEditingController uMobile = TextEditingController();

  @override
  void initState() {
    super.initState();
    fireApp = Firebase.initializeApp();
  }
  bool checkFields() {
    if (uMobile.text.isEmpty) {
      return false;
    } else if (uMobile.text.length != 10) {
      myLogoAlert(
        context: context,
        message: 'Enter a 10 digit number',
        navigateEnabled: false,
        route: '',
      );
      return false;
    }
    return true;
  }

  void procLoginSuccess() {
    Navigator.pop(context);
    Navigator.pushNamed(context, Dashboard.id);
  }

  void _loginUser() async {
    var dio = Dio();
    dio.options.baseUrl = kAPIBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 5000);
    dio.options.receiveTimeout = const Duration(milliseconds: 5000);
    dio.interceptors.add(LogInterceptor(requestBody: false));
    dio.options.headers["Authorization"] = "Bearer $glbAuthToken";

    String url = 'login.php';

    FormData formData = FormData.fromMap(
      {
        "mobile": uMobile.text,
        "password": myPwd,
        "notifcation_token": glbToken,
      },
    );
    await dio.post(url, data: formData).then((value) {
      setState(() {
        isLoading = false;
        if (value.data["status"]) {

          glbMemName = value.data["data"][0]["mem_name"];
          glbID = value.data["data"][0]["id"];
          glbMobNo = uMobile.text;
          glbPwd = myPwd;

          procLoginSuccess();
        } else {
          setState(() {
            isLoading = false;
            myLogoAlert(
                message: value.data["message"],
                context: context,
                navigateEnabled: false,
                route: '');
          });
        }
      });
    }).catchError((e) {
      setState(() {
        isLoading = false;
        myLogoAlert(
            context: context,
            navigateEnabled: false,
            route: '',
            message: e.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    scrWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [

            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 150.0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage("images/playstore.png"),
                      backgroundColor: Colors.white,
                      radius: 50,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    'FORGOT PASSWORD',
                    style: kHeadingStyle,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
                    child: Text(
                      'We will first validate your number',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                    ),
                  ),
                  MyTextFieldWhite(
                    displayIcon: const Icon(
                      FontAwesomeIcons.phone,
                      color: Colors.blue,
                    ),
                    isPassword: false,
                    controller: uMobile,
                    isNumber: true,
                    isLast: true,
                    displayLabel: 'Enter Phone',
                    onChanged: (value) {
                      uMobile.text = value;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MyButton(
                          title: 'Cancel',
                          color: Colors.red.shade600,
                          onPressed: () {
                            String rt = LoginScreen.id;
                            Navigator.pop(context);
                            Navigator.pushNamed(context, rt);
                          },
                          width: 130),
                      MyButton(
                          title: 'Submit',
                          color: kColorGreen,
                          onPressed: () {
                            setState(() {
                              if (uMobile.text == '') {
                                myLogoAlert(
                                    context: context,
                                    navigateEnabled: false,
                                    route: '',
                                    message: 'Please enter a valid number');
                              } else {

                                if (checkFields()) {
                                  isLoading=true;
                                  _validateNumber(uMobile.text, context);

                                }

                              }
                            });
                          },
                          width: 130),
                    ],
                  ),
                  myVisibleIndicator(isVisible: isLoading),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _validateNumber(String phone, BuildContext context) async {
    var dio = Dio();
    dio.options.baseUrl = kAPIBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 5000);
    dio.options.receiveTimeout = const Duration(milliseconds: 5000);
    dio.interceptors.add(LogInterceptor(requestBody: false));
    dio.options.headers["Authorization"] = "Bearer $glbAuthToken";

    String url = 'forget_password.php';

    FormData formData = FormData.fromMap({"mobile": phone}); // validate phone number

    await dio.post(url, data: formData).then((value) async {
      if (value.data["status"]) {
        // Proceed with Firebase phone number verification
        final FirebaseAuth fbAuth = FirebaseAuth.instance;
        phone = '+91$phone';

        fbAuth.verifyPhoneNumber(
            phoneNumber: phone,
            timeout: const Duration(seconds: 60),
            verificationCompleted: (AuthCredential authCred) {
              fbAuth.signInWithCredential(authCred).then((UserCredential result) async {
                // Retrieve password and log in
                await _retrievePassword();
                _loginUser();
                isLoading=true;
              }).catchError((e) {
                setState(() {
                  isLoading = false;
                  myLogoAlert(
                      context: context,
                      navigateEnabled: false,
                      route: '',
                      message: e.toString());
                });
              });
            },
            verificationFailed: (FirebaseAuthException ex) {
              setState(() {
                isLoading = false;
                myLogoAlert(
                    context: context,
                    navigateEnabled: false,
                    route: '',
                    message: ex.toString());
              });
            },
            codeSent: (String verificationId, int? forceResendingToken) {
              final code = TextEditingController();

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: const Column(
                    children: [
                      Center(child: Text("Enter Verification Code",
                        textAlign:TextAlign.center,)),
                      Padding(
                        padding: EdgeInsets.only(top: 4.0, left: 10.0),
                        child: Text(
                          '*Wait for 5 seconds to auto submit',
                          style: kDialogStyle,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          '*OTP expires in 60 seconds',
                          style: kDialogStyle,
                        ),
                      ),
                    ],
                  ),
                  content: MyTextFieldWhite(
                    displayIcon: const Icon(
                      Icons.password,
                      color: Colors.blue,
                    ),
                    isPassword: false,
                    controller: code,
                    isNumber: true,
                    displayLabel: 'Enter OTP',
                    isLast: true,
                    onChanged: (val) {
                      code.text = val;
                    },
                  ),
                  actions: [
                    MyButton(
                        title: 'Submit',
                        color: kColorGreen,
                        onPressed: () {
                          if (code.text == '') {
                            //do nothing
                          } else {
                            var cred = PhoneAuthProvider.credential(
                                verificationId: verificationId,
                                smsCode: code.text);
                            fbAuth.signInWithCredential(cred).then((UserCredential result) async {
                              Navigator.pop(context);
                              // Retrieve password and log in
                              isLoading=true;
                              await _retrievePassword();
                              _loginUser();
                            }).catchError((e) {
                              Navigator.pop(context);
                              setState(() {
                                isLoading = false;
                                myLogoAlert(
                                    context: context,
                                    navigateEnabled: false,
                                    route: '',
                                    message: e.toString());
                              });
                            });
                          }
                        },
                        width: 100),
                  ],
                ),
              );
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              verificationId = verificationId;
            });
      } else {
        setState(() {
          isLoading = false;
          myLogoAlert(
              context: context,
              navigateEnabled: false,
              route: '',
              message: value.data["message"]);
        });
      }
    }).catchError((e) {
      setState(() {
        isLoading = false;
        myLogoAlert(
            context: context,
            navigateEnabled: false,
            route: '',
            message: e.toString());
      });
    });
  }

  Future<void> _retrievePassword() async {
    var dio = Dio();
    dio.options.baseUrl = kAPIBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 5000);
    dio.options.receiveTimeout = const Duration(milliseconds: 5000);
    dio.interceptors.add(LogInterceptor(requestBody: false));
    dio.options.headers["Authorization"] = "Bearer $glbAuthToken";

    String url = 'forget_password.php';

    FormData formData = FormData.fromMap({"mobile": uMobile.text});
    await dio.post(url, data: formData).then((value) {
      if (value.data["status"]) {
        myPwd = value.data["data"][0]["password"];

      } else {
        setState(() {
          isLoading = false;
          myLogoAlert(
              message: value.data["message"],
              context: context,
              navigateEnabled: false,
              route: '');
        });
      }
    }).catchError((e) {
      setState(() {
        isLoading = false;
        myLogoAlert(
            context: context,
            navigateEnabled: false,
            route: '',
            message: e.toString());
      });
    });
  }
}

