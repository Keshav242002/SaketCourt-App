import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/authorizeModel.dart';
import '../utils/constants.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Dio _dio;

  @override
  void initState() {
    super.initState();

    _authorize();
  }



  void _authorize() async {
    _dio = Dio();
    _dio.options.baseUrl = kAPIBaseURL;
    _dio.options.connectTimeout = const Duration(milliseconds: 5000);
    _dio.options.receiveTimeout = const Duration(milliseconds: 5000);
    const String url = 'authorize.php';
    final formData = FormData.fromMap({
      "clientId": "b50699dc2c1aee1cd0abfa75ac14e3ee",
      "clientSecret": "922c67a32613d40f1c5cf84e474d0314",
    });

    try {
      final response = await _dio.post(url, data: formData);
      var authModel = AuthorizeModel.fromJson(response.data);
      if (authModel.status) {
        glbAuthToken = authModel.token;
        _navigateToLogin(authModel.token);
      } else {
        _showAlert(authModel.message);
      }
    } catch (e) {
      _showAlert('Failed to authorize: $e');
    }
  }

  void _navigateToLogin(String token) {
    Navigator.pushReplacementNamed(context, LoginScreen.id, arguments: token);
  }

  void _showAlert(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();  // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                const Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 100,
                    child: Image(
                      image: AssetImage('images/playstore.png'),  // Ensure you have this asset
                    ),
                  ),
                ),
                const Text(
                  'Saket Court Bar Association',
                  style: kHeadingStyle,
                ),
                Text( glbVersion, style: kListNumberStyle,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
