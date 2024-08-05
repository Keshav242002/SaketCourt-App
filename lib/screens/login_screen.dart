import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:saketcourt/screens/Dashboard.dart';
import 'package:saketcourt/screens/forget_password.dart';
import '../components/my_button.dart';
import '../components/my_text_field_white.dart';
import '../components/my_visible_indicator.dart';
import '../utils/constants.dart';
import '../utils/my_logo_alert.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  TextEditingController mobileTEC = TextEditingController();
  TextEditingController passTEC = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  bool checkFields() {
    if (mobileTEC.text.isEmpty) {
      return false;
    } else if (mobileTEC.text.length != 10) {
      return false;
    } else if (passTEC.text.isEmpty) {
      return false;
    }
    return true;
  }

  bool checkEmpty() {
    if (mobileTEC.text.isEmpty || passTEC.text.isEmpty) {
      return false;
    }
    return true;
  }

  void procLoginSuccess() {
    Navigator.pop(context);
    Navigator.pushNamed(context, Dashboard.id);
  }

  void _loginUser() async {
    setState(() {
      isLoading = true;
    });

    var dio = Dio();
    dio.options.baseUrl = kAPIBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 5000);
    dio.options.receiveTimeout = const Duration(milliseconds: 5000);
    dio.interceptors.add(LogInterceptor(requestBody: false));
    dio.options.headers["Authorization"] = "Bearer $glbAuthToken";

    String url = 'login.php';

    FormData formData = FormData.fromMap(
      {
        "mobile": mobileTEC.text,
        "password": passTEC.text,
        "notifcation_token": glbToken,
      },
    );

    try {
      final response = await dio.post(url, data: formData);
      if (response.data["status"]) {
        setState(() {
          isLoading = false;
          glbMemName = response.data["data"][0]["mem_name"];
          glbID = response.data["data"][0]["id"];
          glbMemCode = response.data["data"][0]["mem_code"];
          glbMobNo = mobileTEC.text;
          glbPwd = passTEC.text;
          procLoginSuccess();
        });
      } else {
        setState(() {
          isLoading = false;
          myLogoAlert(
            message: response.data["message"],
            context: context,
            navigateEnabled: false,
            route: '',
          );
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        myLogoAlert(
          message: 'Login failed. Please try again later.',
          context: context,
          navigateEnabled: false,
          route: '',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorWhite,
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.2,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/DSC_2806.JPG"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: ((MediaQuery.of(context).size.height) / 3) - 50 > 0
                      ? ((MediaQuery.of(context).size.height) / 3) - 50
                      : 0,
                ),
                myVisibleIndicator(isVisible: isLoading),
                const Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 100,
                    child: Image(
                      image: AssetImage('images/playstore.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Text( glbVersion, style: kListNameStyle,),
                const SizedBox(
                  height: 10.0,
                ),
                MyTextFieldWhite(
                  displayIcon: const Icon(
                    Icons.phone,
                    color: kColorMidNightBlue,
                  ),
                  isPassword: false,
                  controller: mobileTEC,
                  isNumber: true,
                  isLast: false,
                  displayLabel: 'Enter Mobile No',
                  onChanged: (val) {
                    setState(() {
                      mobileTEC.text = val;
                    });
                  },
                  labelTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                MyTextFieldWhite(
                  displayIcon: const Icon(
                    Icons.key,
                    color: kColorMidNightBlue,
                  ),
                  isPassword: true,
                  controller: passTEC,
                  isNumber: false,
                  isLast: true,
                  displayLabel: 'Enter Password',
                  onChanged: (val) {
                    setState(() {
                      passTEC.text = val;
                    });
                  },
                  labelTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                MyButton(
                  title: 'Login',
                  color: kColorGreen,
                  onPressed: () {
                    if (!checkEmpty()) {
                      myLogoAlert(
                        context: context,
                        message: 'Username / Password Cannot Be Blank',
                        navigateEnabled: false,
                        route: '',
                      );
                    } else if (mobileTEC.text.length != 10) {
                      myLogoAlert(
                        context: context,
                        message: 'Enter a 10 digit number',
                        navigateEnabled: false,
                        route: '',
                      );
                    } else if (!checkFields()) {
                      myLogoAlert(
                        context: context,
                        message: 'Wrong Username / Password Entered',
                        navigateEnabled: false,
                        route: '',
                      );
                    } else {
                      _loginUser();
                    }
                  },
                  width: 100,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: GestureDetector(
                    child: const Text(
                      'Forgot Password',
                      style: TextStyle(color: Colors.blue, fontSize: 14),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, ForgotPassword.id);
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
