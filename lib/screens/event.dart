import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saketcourt/models/eventModel.dart';
import 'package:saketcourt/screens/Dashboard.dart';
import '../utils/constants.dart';

class Events extends StatefulWidget {
  const Events({super.key});
  static const String id = "events";

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  bool isLoading = true;
  List<Detail> events = [];

  @override
  void initState() {
    _getEvents();
    super.initState();
  }

  void _getEvents() async {
    var dio = Dio();
    dio.options.baseUrl = kAPIBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 5000);
    dio.options.receiveTimeout = const Duration(milliseconds: 5000);
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    dio.options.headers["Authorization"] = "Bearer $glbAuthToken";

    try {
      final response = await dio.get('get_events.php');

      if (response.statusCode == 200) {

        EventModel eventModel = EventModel.fromJson(response.data);

        setState(() {
          isLoading = false;
          events = eventModel.result.details;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load event data');
      }
    } catch (e) {

      setState(() {
        isLoading = false;
      });
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          iconSize: 20,
          color: kColorWhite,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
          },
        ),
        title: const Text(
          'Upcoming Events',
          style: TextStyle(color: kColorWhite, fontSize: 20),
        ),
        backgroundColor: kColorMidNightBlue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: events.map((event) => buildEventCard(event)).toList(),
          ),
        ),
      ),
    );
  }

  Widget buildEventCard(Detail event) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Colors.blueGrey,
                  width: 1.0,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: event.image != null
                    ? Image.network(
                  event.image!,
                  width: 80,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 100,
                      color: Colors.grey,
                      child: Icon(Icons.error, color: Colors.red),
                    );
                  },
                )
                    : Container(
                  width: 80,
                  height: 100,
                  color: Colors.grey,
                  child: Icon(Icons.image, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        const Text('Name: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(
                            event.eventName,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        const Text('Event Date: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(
                            showDate(event.eventDate.toString()),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Description: ',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          TextSpan(
                            text: event.description ?? '',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
