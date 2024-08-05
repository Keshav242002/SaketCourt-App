import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saketcourt/utils/MySnackBar.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../models/searchModel.dart';
import '../utils/constants.dart';
import 'Dashboard.dart';


class myVisibleIndicator extends StatelessWidget {
  const myVisibleIndicator({Key? key, required this.isVisible}) : super(key: key);

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: const Padding(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kColorMidNightBlue),
          ),
        ),
      ),
    );
  }
}

class SearchMembers extends StatefulWidget {
  const SearchMembers({super.key});
  static const String id = 'search_member';

  @override
  State<SearchMembers> createState() => _SearchMembersState();
}

class _SearchMembersState extends State<SearchMembers> {
  TextEditingController _searchController = TextEditingController();
  SearchModel? _searchResult;
  bool _isEmptyResult = false;
  bool _isLoading = false;
  List<Details> _allMembersDetails = [];
  List<Details> _membersDetails = [];
  int _currentPage = 1;
  int _totalPages = 1;
  static const int _itemsPerPage = 15;

  @override
  void initState() {
    super.initState();
  }

  String showDate(String rideDate) {
    DateTime now = DateTime.parse(rideDate);
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    String formatted = formatter.format(now);
    return formatted;
  }

  int calculateTotalPages(int totalCount, int itemsPerPage) {
    return (totalCount / itemsPerPage).ceil();
  }

  void _updateDisplayedMembers() {
    int start = (_currentPage - 1) * _itemsPerPage;
    int end = start + _itemsPerPage;
    setState(() {
      _membersDetails = _allMembersDetails.sublist(start, end > _allMembersDetails.length ? _allMembersDetails.length : end);
    });
  }

  void _searchMember() async {
    if (_searchController.text.length < 3) {
      _showAlert('Enter at least 3 or more characters to search.');
      return;
    }

    setState(() {
      _isLoading = true;
      _isEmptyResult = false;
      _searchResult = null;
      _allMembersDetails = [];
      _membersDetails = [];
    });

    var dio = Dio();
    dio.options.baseUrl = kAPIBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 5000);
    dio.options.receiveTimeout = const Duration(milliseconds: 5000);
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    dio.options.headers["Authorization"] = "Bearer $glbAuthToken";

    String url = 'search_member.php';
    FormData formData = FormData.fromMap({
      "search": _searchController.text,
    });

    try {
      final response = await dio.post(url, data: formData);


      if (response.statusCode == 200 && response.data['status']) {

        SearchModel searchResult = SearchModel.fromJson(response.data);

        if (searchResult.result.details.isEmpty) {
          setState(() {
            _isEmptyResult = true;
            _isLoading = false;
          });
        } else {
          setState(() {
            _searchResult = searchResult;
            _isEmptyResult = false;
            _isLoading = false;
            _allMembersDetails = searchResult.result.details;
            _totalPages = calculateTotalPages(searchResult.totalCount, _itemsPerPage); // Calculate total pages
            _updateDisplayedMembers();
          });
        }
      } else {
        setState(() {
          _isEmptyResult = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      mySnackBar(context: context, widget: Text(e.toString()), backGroundColor: kColorRed);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResult = null;
      _isEmptyResult = false;
      _isLoading = false;
      _allMembersDetails = [];
      _membersDetails = [];
      _currentPage = 1;
      _totalPages = 1;
    });
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Icon(
            Icons.error,
            color: Colors.red,
            size: 50,
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
          'Search Members',
          style: TextStyle(color: kColorWhite, fontSize: 18),
        ),
        backgroundColor: kColorMidNightBlue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: kColorBlue),
                  ),
                  hintText: 'Search Member ',
                  prefixIcon: Icon(
                    Icons.search,
                    color: kColorOrange,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: _clearSearch,
                    color: kColorBase,
                  ),
                ),
                onSubmitted: (value) {
                  setState(() {
                    _searchController.text = value;
                    _searchMember();
                  });
                },
              ),
              const SizedBox(height: 20),
              myVisibleIndicator(isVisible: _isLoading),
              if (_isEmptyResult)
                Text(
                  'No member found.',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              if (_searchResult != null && !_isEmptyResult) ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _membersDetails.length,
                  itemBuilder: (context, index) {
                    Details details = _membersDetails[index];
                    return GestureDetector(
                      onTap: () => _showMemberDetails(context, details),
                      child: Card(
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
                                  child: Image.network(
                                    '$kImagePath${details.image}',
                                    width: 80,
                                    height: 115,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                      return Container(
                                        width: 80,
                                        height: 115,
                                        child: Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 50,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded( // Add Expanded here
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Row(
                                        children: [
                                          const Text('Name: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                          Expanded( // Add Expanded here
                                            child: Text(
                                              details.memName ?? '',
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
                                          const Text('Mem No: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                          Expanded( // Add Expanded here
                                            child: Text(
                                              details.memNo ?? '',
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
                                          const Text('Enrl No:', style: TextStyle(fontWeight: FontWeight.bold)),
                                          Expanded( // Add Expanded here
                                            child: Text(
                                              details.enrlNo ?? '',
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
                                          const Text('Mobile:', style: TextStyle(fontWeight: FontWeight.bold)),
                                          Expanded( // Add Expanded here
                                            child: Text(
                                              details.mobile1 ?? '',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align buttons on opposite ends
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: _currentPage > 1
                            ? () {
                          setState(() {
                            _currentPage--;
                            _updateDisplayedMembers();
                          });
                        }
                            : null,
                      ),
                      Text('Page $_currentPage of $_totalPages'),
                      IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: _currentPage < _totalPages
                            ? () {
                          setState(() {
                            _currentPage++;
                            _updateDisplayedMembers();
                          });
                        }
                            : null,
                      ),
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  void _showMemberDetails(BuildContext context, Details details) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.only(top: 8, left: 16, right: 8), // Custom padding
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
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
                    child: Image.network(
                      '$kImagePath${details.image}',
                      width: 120,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return Container(
                          width: 80,
                          height: 115,
                          child: Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 50,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ListBody(
                  children: <Widget>[
                    _buildDetailRow('Name: ', details.memName),
                    _buildDetailRow('DOB: ', showDate(details.dob!),),
                    _buildDetailRow('Father\'s Name: ', details.fatherName),
                    _buildDetailRow('Membership No: ', details.memNo),
                    _buildDetailRow('Membership Date: ', details.membershipDate != null ? showDate(details.membershipDate!) : ''),
                    _buildDetailRow('Enrl No: ', details.enrlNo),
                    _buildDetailRow('Enrollment Date: ', details.enrlDate != null ? showDate(details.enrlDate!) : ''),
                    _buildDetailRow('Email: ', details.email),
                    _buildDetailRow('Mobile: ', details.mobile1),
                    _buildDetailRow('Office Address: ', '${details.officeAdd1}, ${details.officeAdd2}, ${details.officeAdd3}'),
                    _buildDetailRow('Residence Address: ', '${details.resAdd1}, ${details.resAdd2}, ${details.resAdd3}'),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CircleAvatar(
                        radius: 28, // Adjust the size of the circle
                        backgroundColor: kColorGreen, // Use your predefined color constant for background
                        child: IconButton(
                          icon: const Icon(Icons.call, color: Colors.white), // Icon with white color
                          onPressed: () => launchUrlString("tel:${details.mobile1}"), // Launch call function
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: label,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            TextSpan(
              text: value ?? '',
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
