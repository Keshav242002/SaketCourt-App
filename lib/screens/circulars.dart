import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:saketcourt/components/new_drawrer.dart';
import 'package:saketcourt/screens/Dashboard.dart';
import 'package:saketcourt/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/circularModel.dart';

class Circulars extends StatefulWidget {
  const Circulars({super.key});
  static const String id = "circulars";

  @override
  State<Circulars> createState() => _CircularsState();
}

class _CircularsState extends State<Circulars> {
  bool isLoading = true;
  List<Detail> circularsList = [];

  @override
  void initState() {
    super.initState();
    fetchCirculars();
  }

  void fetchCirculars() async {
    var dio = Dio();
    dio.options.baseUrl = kAPIBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 5000);
    dio.options.receiveTimeout = const Duration(milliseconds: 5000);
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    dio.options.headers["Authorization"] = "Bearer $glbAuthToken";
    String url = 'get_circular.php';

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        CircularModel circularModel = circularModelFromJson(json.encode(response.data));
        setState(() {
          circularsList = circularModel.result.details;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load circulars');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load circulars');
    }
  }

  Future<void> _launchURL(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  String showDate(String? date) {
    if (date == null || date.isEmpty) {
      return 'Invalid date';
    }
    DateTime now = DateTime.parse(date);
    DateFormat formatter = DateFormat('dd-MMM-yy');
    String formatted = formatter.format(now);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text(
          'Circulars',
          style: TextStyle(color: kColorWhite, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, Dashboard.id);
            },
          ),
        ],
        backgroundColor: kColorMidNightBlue,
        iconTheme: IconThemeData(color: Colors.white),

      ),
      drawer: const NewDrawer(),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (circularsList.isEmpty)
                const Center(child: Text('No circulars found.'))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: circularsList.length,
                    itemBuilder: (context, index) {
                      Detail detail = circularsList[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundImage: AssetImage("images/playstore.png"),
                          ),
                          title: Text('Circular Date: ${showDate(detail.dateOfUploading.toString())}'),
                          trailing: Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red.shade600,
                          ),
                          onTap: () {
                            _launchURL(Uri.parse(detail.uploadCircular));
                          },
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
