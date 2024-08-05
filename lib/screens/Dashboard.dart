import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:saketcourt/components/new_drawrer.dart';
import 'package:saketcourt/screens/event.dart';
import 'package:saketcourt/screens/profile.dart';
import 'package:saketcourt/screens/searchMember.dart';
import 'package:saketcourt/screens/subscriptions.dart';
import 'package:saketcourt/utils/constants.dart';
import 'package:shimmer/shimmer.dart';
import '../components/sl_slider.dart';
import '../models/bannerModel.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  static const String id = 'Dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isLoading = true;
  List displayBanner = [];
  double width = 0;
  double height = 0;
  double dlgWidth = 0;
  double bannerHeight = 0;

  @override
  void _importBanners() async {
    var dio = Dio();
    dio.options.baseUrl = kAPIBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 5000);
    dio.options.receiveTimeout = const Duration(milliseconds: 5000);
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    dio.options.headers["Authorization"] = "Bearer $glbAuthToken";
    String url = 'get_banner.php';

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        BannerModel bannerModel = BannerModel.fromJson(response.data);
        setState(() {
          isLoading = false;
          if (bannerModel.status) {
            displayBanner.clear();
            for (var banner in bannerModel.result.details) {
              displayBanner.add(banner.image);
            }
          }
        });
      } else {
        throw Exception('Failed to load banners');
      }
    } catch (e) {

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _importBanners();
  }

  @override
  Widget build(BuildContext context) {
    width = (MediaQuery.of(context).size.width) - 165;
    dlgWidth = (MediaQuery.of(context).size.width) - 15;
    height = (MediaQuery.of(context).size.height / 3) / 2;
    bannerHeight = (MediaQuery.of(context).size.height / 3 - 50);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saket Bar Association',
          style: TextStyle(color: kColorWhite, fontSize: 20),
        ),
        backgroundColor: kColorMidNightBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const NewDrawer(),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [

          SingleChildScrollView(
            child: Column(
              children: [
                displayBanner.isEmpty
                    ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Shimmer.fromColors(
                    baseColor: const Color(0xFFCFD8DC),
                    highlightColor: Colors.white,
                    child: const SLSlider(),
                  ),
                )
                    : CarouselSlider(
                  options: CarouselOptions(
                    height: bannerHeight,
                    viewportFraction: 1,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: displayBanner
                      .map((item) => SizedBox(
                    width: double.infinity,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(2.0),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Image.network(
                              item,
                              fit: BoxFit.cover,
                              width: 1000.0,
                              height: 300.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
                      .toList(),
                ),
                Padding(
                   padding: const EdgeInsets.only(top: 5),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            child: Container(
                              height: height,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                color: Colors.transparent,
                                border: Border.all(color: kColorBase),
                              ),
                              child: const Column(

                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  Icon(
                                    FontAwesomeIcons.solidAddressCard,
                                    size: 30,
                                    color: kColorGreen,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      'My Profile',
                                      style: TextStyle(fontSize: 13, color: kColorGreen),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.pushNamed(context, MyProfile.id);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            child: Container(
                              height: height,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                color: Colors.transparent,
                                border: Border.all(color: kColorBase),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search,
                                    size: 30,
                                    color: kColorOrange,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      'Search',
                                      style: TextStyle(fontSize: 13, color: kColorOrange),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.pushNamed(context, SearchMembers.id);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            child: Container(
                              height: height,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                color: Colors.transparent,
                                border: Border.all(color: kColorBase),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.event,
                                    size: 30,
                                    color: kColorRed,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      'Events',
                                      style: TextStyle(fontSize: 13, color: kColorRed),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.pushNamed(context, Events.id);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            child: Container(
                              height: height,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                color: Colors.transparent,
                                border: Border.all(color: kColorBase),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.subscriptions,
                                    size: 30,
                                    color: kColorBlue,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      'My Subscriptions',
                                      style: TextStyle(fontSize: 13, color: kColorBlue),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.pushNamed(context, Subscriptions.id);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
