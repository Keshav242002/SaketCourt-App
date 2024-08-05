import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:saketcourt/components/new_drawrer.dart';
import 'package:saketcourt/screens/Dashboard.dart';
import 'package:saketcourt/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/linksModel.dart';
class Links extends StatefulWidget {
  const Links({super.key});
  static const String id=" links";

  @override
  State<Links> createState() => _LinksState();
}

class _LinksState extends State<Links> {

  bool isLoading = true;
  List<Detail> linkList = [];

  @override
  void initState() {
    fetchLinks();
    super.initState();

  }
  void fetchLinks() async {
    var dio = Dio();
    dio.options.baseUrl = kAPIBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 5000);
    dio.options.receiveTimeout = const Duration(milliseconds: 5000);
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    dio.options.headers["Authorization"] = "Bearer $glbAuthToken";
    String url = 'get_important_link.php';

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        LinksModel links = linksModelFromJson(json.encode(response.data));
        setState(() {
          linkList = links.result.details;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load links');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load links');
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
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Important Links',
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
        iconTheme: const IconThemeData(color: Colors.white),

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
              else if (linkList.isEmpty)
                const Center(child: Text('No Links found.'))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: linkList.length,
                    itemBuilder: (context, index) {
                      Detail detail = linkList[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundImage: AssetImage("images/playstore.png"),
                          ),
                          title: Text(detail.name),
                          trailing: const Icon(
                            Icons.link,
                            color: Colors.indigo,
                            size: 30,
                          ),

                          onTap: () {
                            _launchURL(Uri.parse(detail.importantLink));
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
