import 'dart:io' as io;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:saketcourt/components/my_text_field_no_icon.dart';
import 'package:saketcourt/models/updateImageModel.dart';
import 'package:saketcourt/screens/Dashboard.dart';
import 'package:saketcourt/utils/MySnackBar.dart';
import 'package:saketcourt/utils/my_logo_alert.dart';
import '../components/my_text_field_text_no_icon.dart';
import '../models/profileModel.dart';
import '../models/updateModel.dart';
import '../utils/constants.dart';
import '../utils/constants.dart' as saketConstants;

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});
  static const String id = "my_profile";

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool isLoading = true;
  String imageUrl = '';
  String memName = '';
  String fatherName = '';
  String memDate = '';
  String enrlDate = '';
  String enrlNum = '';
  String mobile1 = '';
  String mobile2 = '';
  String email = '';
  String offAdd1 = '';
  String offAdd2 = '';
  String offAdd3 = '';
  String resAdd1 = '';
  String resAdd2 = '';
  String resAdd3 = '';
  String memNo = '';
  String offTel = '';
  String resTel = '';
  String pwd = '';
  XFile? _pickedFile;
  late io.File _imageFile;
  bool isFile = false;

  TextEditingController _mobile1Controller = TextEditingController();
  TextEditingController _mobile2Controller = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _officeAddressStreetController = TextEditingController();
  TextEditingController _officeAddressCityController = TextEditingController();
  TextEditingController _officeAddressStateController = TextEditingController();
  TextEditingController _residenceAddressStreetController = TextEditingController();
  TextEditingController _residenceAddressCityController = TextEditingController();
  TextEditingController _residenceAddressStateController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  @override
  void initState() {
    _fetchProfile();
    super.initState();
  }



  void _updateProfile({
    String? newMobile1,
    String? newMobile2,
    String? newEmail,
    String? newOfficeStreet,
    String? newOfficeCity,
    String? newOfficeState,
    String? newResidenceStreet,
    String? newResidenceCity,
    String? newResidenceState,
    String? newPwd,
    required BuildContext context,
  }) async {
    var dio = Dio();
    dio.options.baseUrl = kAPIBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 5000);
    dio.options.receiveTimeout = const Duration(milliseconds: 5000);
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    dio.options.headers["Authorization"] = "Bearer $glbAuthToken";

    FormData formData = FormData.fromMap({
      'id': glbID,
      'mobile1': newMobile1 ?? mobile1,
      'mobile2': newMobile2 ?? mobile2,
      'email': newEmail ?? email,
      'office_address': [newOfficeStreet ?? offAdd1, newOfficeCity ?? offAdd2, newOfficeState ?? offAdd3].join(', '),
      'residence_address': [newResidenceStreet ?? resAdd1, newResidenceCity ?? resAdd2, newResidenceState ?? resAdd3].join(', '),
      'password': newPwd ?? pwd,
    });




      final response = await dio.post('update_profile.php', data: formData);



      if (response.statusCode == 200) {
        UpdateModel updateModel = UpdateModel.fromJson(response.data);
        if (updateModel.status) {
          setState(() {
            mobile1 = newMobile1 ?? mobile1;
            mobile2 = newMobile2 ?? mobile2;
            email = newEmail ?? email;
            offAdd1 = newOfficeStreet ?? offAdd1;
            offAdd2 = newOfficeCity ?? offAdd2;
            offAdd3 = newOfficeState ?? offAdd3;
            resAdd1 = newResidenceStreet ?? resAdd1;
            resAdd2 = newResidenceCity ?? resAdd2;
            resAdd3 = newResidenceState ?? resAdd3;
            pwd = newPwd ?? pwd;
          });
        } else {
          mySnackBar(context: context, widget: Text(response.data["message"]), backGroundColor: kColorRed);
        }
      } else {
   mySnackBar(context: context, widget: Text(response.data["message"]), backGroundColor: kColorRed);
      }

  }

  void _fetchProfile() async {

    var dio = Dio();
    dio.options.baseUrl = kAPIBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 5000);
    dio.options.receiveTimeout = const Duration(milliseconds: 5000);
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    dio.options.headers["Authorization"] = "Bearer $glbAuthToken";


      final response = await dio.get('get_profile.php/$glbID');

      if (response.statusCode == 200) {

        var profileData = response.data;
        ProfileModel profile = ProfileModel.fromJson(profileData);

        String? ImageUrl = profile.result.details.first.image;
        String? MemName = profile.result.details.first.memName;
        String? FatherName = profile.result.details.first.fatherName;
        String? MemDate = profile.result.details.first.memDate;
        String? EnrlDate = profile.result.details.first.enrlDate;
        String? EnrlNum = profile.result.details.first.enrlNum;
        String? Mobile1 = profile.result.details.first.mobile1;
        String? Mobile2 = profile.result.details.first.mobile2;
        String? Email = profile.result.details.first.email;
        String? OffAdd1 = profile.result.details.first.offAdd1;
        String? OffAdd2 = profile.result.details.first.offAdd2;
        String? OffAdd3 = profile.result.details.first.offAdd3;
        String? ResAdd1 = profile.result.details.first.resAdd1;
        String? ResAdd2 = profile.result.details.first.resAdd2;
        String? ResAdd3 = profile.result.details.first.resAdd3;
        String? MemNo = profile.result.details.first.memNo;
        String? OffTel = profile.result.details.first.offTel;
        String? ResTel = profile.result.details.first.resTel;
        String? Pwd = profile.result.details.first.pwd;


        setState(() {
          isLoading = false;
          imageUrl = ImageUrl != null ? "${saketConstants.kImagePath}$ImageUrl" : '';
          fatherName = FatherName ?? '';
          memName = MemName ?? '';
          memDate = MemDate ?? '';
          enrlDate = EnrlDate ?? '';
          enrlNum = EnrlNum ?? '';
          mobile1 = Mobile1 ?? '';
          mobile2 = Mobile2 ?? '';
          email = Email ?? '';
          offAdd1 = OffAdd1 ?? '';
          offAdd2 = OffAdd2 ?? '';
          offAdd3 = OffAdd3 ?? '';
          resAdd1 = ResAdd1 ?? '';
          resAdd2 = ResAdd2 ?? '';
          resAdd3 = ResAdd3 ?? '';
          memNo = MemNo ?? '';
          offTel = OffTel ?? '';
          resTel = ResTel ?? '';
          pwd = Pwd ?? '';


          _mobile1Controller.text = mobile1;
          _mobile2Controller.text = mobile2;
          _emailController.text = email;
          _officeAddressStreetController.text = offAdd1;
          _officeAddressCityController.text = offAdd2;
          _officeAddressStateController.text = offAdd3;
          _residenceAddressStreetController.text = resAdd1;
          _residenceAddressCityController.text = resAdd2;
          _residenceAddressStateController.text = resAdd3;
          _pwdController.text = pwd;
        });
      } else {
        setState(() {
          isLoading = false;
         // mySnackBar(context: context, widget: widget, backGroundColor: kColorRed);
        });
        throw Exception('Failed to load profile data');
      }

  }


  String showDate(String rideDate) {
    DateTime now = DateTime.parse(rideDate);
    DateFormat formatter = DateFormat('dd-MM-yyyy');
    String formatted = formatter.format(now);
    return formatted;
  }



  void _updateImage(BuildContext context) async {
    var dio = Dio();
    dio.options.baseUrl = kAPIBaseURL;
    dio.options.connectTimeout = Duration(milliseconds: 5000);
    dio.options.receiveTimeout = Duration(milliseconds: 5000);
    dio.interceptors.add(LogInterceptor(requestBody: false));
    dio.options.headers["Authorization"] = "Bearer $glbAuthToken";
    dio.options.headers[Headers.contentTypeHeader] = 'multipart/form-data';

    String url = 'update_member_image.php';

    FormData formData = FormData.fromMap({
      "id":glbID,
      "member_image": await MultipartFile.fromFile(_imageFile.path,
          filename: basename(_imageFile.path),
          contentType: MediaType.parse('image/jpeg')),

    });

    await dio.post(url, data: formData).then((value) {

      UpdateImageModel generalModel = UpdateImageModel.fromJson(value.data);

      setState(() {
        isLoading = false;
        if (generalModel.status) {

          myLogoAlert(
              context: context,
              navigateEnabled: true,
              message: 'New Image Uploaded Successfully',
              route: MyProfile.id);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${generalModel.message} - ${generalModel.code}',
              ),
            ),
          );
        }
      });
    });
  }
  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    try {
      _pickedFile = await ImagePicker().pickImage(source: source);
      if (_pickedFile == null) return;

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        maxHeight: 512,
        maxWidth: 512,
      );

      if (croppedFile == null) return;

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        croppedFile.path,
        '${io.Directory.systemTemp.path}/${DateTime.now().millisecondsSinceEpoch}.jpg',
        quality: 60,
      );

      if (compressedFile == null) return;

      setState(() {
        _imageFile = io.File(compressedFile.path);
        isFile = true;
        _updateImage(context);
      });

    } catch (e) {

      mySnackBar(context: context, widget: Text(e.toString()), backGroundColor: kColorRed);
    }
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
        title: const Text('My Profile', style: TextStyle(color: kColorWhite, fontSize: 20)),
        backgroundColor: kColorMidNightBlue,
      ),
      backgroundColor: kColorWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 5),
            if (isLoading)
              CircularProgressIndicator()
            else
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              height: 180,
                              width: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18.0),
                                border: Border.all(
                                  color: Colors.blueGrey,
                                  width: 1.0,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: isFile
                                  ? Image.file(
                                _imageFile,
                                fit: BoxFit.cover,
                              )
                                  : (imageUrl == ''
                                  ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.error, size: 50, color: Colors.red),
                                  SizedBox(height: 7),
                                  Text('Failed to load image'),
                                ],
                              )
                                  : Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.error, size: 50, color: Colors.red),
                                      SizedBox(height: 7),
                                      Text('Failed to load image'),
                                    ],
                                  );
                                },
                              )),
                            ),
                          ),
                          Positioned(
                            bottom: -10,
                            left: 295,
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return Dialog(
                                      backgroundColor: Colors.grey[850],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              "Choose option",
                                              style: TextStyle(color: Colors.white, fontSize: 18),
                                            ),
                                            const SizedBox(height: 20),
                                            SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(dialogContext).pop();
                                                  _pickImage(ImageSource.camera, context);
                                                },
                                                child: const Text("Camera"),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(dialogContext).pop();
                                                  _pickImage(ImageSource.gallery, context);
                                                },
                                                child: const Text("Choose from Gallery"),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(dialogContext).pop();
                                              },
                                              child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: kColorMidNightBlue, // Text color
                              ),
                              child: const Text("Upload New"),
                            ),
                          ),
                        ],
                      ),
                    ),






                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: (MediaQuery.of(context).size.width),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: kColorRed, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Name:  " + memName, style: kListNameStyle),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: (MediaQuery.of(context).size.width),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: kColorRed, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Father's Name:  " + fatherName, style: kListNameStyle),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: (MediaQuery.of(context).size.width),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: kColorRed, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Membership Date:  " + showDate(memDate), style: kListNameStyle),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: (MediaQuery.of(context).size.width),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: kColorRed, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Membership Number:  " + memNo, style: kListNameStyle),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: (MediaQuery.of(context).size.width),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: kColorRed, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Enrollment Date:  " + showDate(enrlDate), style: kListNameStyle),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: (MediaQuery.of(context).size.width),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: kColorRed, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Enrollment Number:  " + enrlNum, style: kListNameStyle),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: (MediaQuery.of(context).size.width),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: kColorRed, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Mobile Number 1:  " + mobile1, style: kListNameStyle),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: (MediaQuery.of(context).size.width),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: kColorRed, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Mobile Number 2:  " + mobile2, style: kListNameStyle),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: (MediaQuery.of(context).size.width),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: kColorGreen, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Email Address: $email",
                                  style: kListNameStyle,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _emailController.text = email;
                                  showEmailEdit(context);
                                });
                              },
                              child: const Icon(Icons.edit, color: kColorBlue),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: kColorGreen, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Office Address: $offAdd1",
                                  style: kListNameStyle,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _officeAddressStreetController.text = offAdd1;
                                  _officeAddressCityController.text = offAdd2;
                                  _officeAddressStateController.text = offAdd3;
                                  showOfficeAddressEdit(context);
                                });
                              },
                              child: const Icon(Icons.edit, color: kColorBlue),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: kColorGreen, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Residence Address: $resAdd1",
                                  style: kListNameStyle,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _residenceAddressStreetController.text = resAdd1;
                                  _residenceAddressCityController.text = resAdd2;
                                  _residenceAddressStateController.text = resAdd3;
                                  showResidenceAddressEdit(context);
                                });
                              },
                              child: const Icon(Icons.edit, color: kColorBlue),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: (MediaQuery.of(context).size.width),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: kColorRed, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Office Number:  " + offTel, style: kListNameStyle),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: (MediaQuery.of(context).size.width),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: kColorRed, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Residence Number:  " + resTel, style: kListNameStyle),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: (MediaQuery.of(context).size.width),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: kColorGreen, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Set Password: $pwd",
                                  style: kListNameStyle,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _pwdController.text = pwd;
                                  showPasswordEdit(context);

                                });
                              },
                              child: const Icon(Icons.edit, color: kColorBlue),
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

  void showMobile1Edit(BuildContext context) {
    Alert(
      context: context,
      content: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: MyTextFieldNoIcon(
          isPassword: false,
          controller: _mobile1Controller,
          isNumber: true,
          isLast: true,
          displayLabel: 'Mobile No 1',
          onChanged: (val) {
            _mobile1Controller.text = val;
          },
        ),
      ),
      buttons: [
        DialogButton(
          color: kColorGreen,
          onPressed: () {
            setState(() {
              Navigator.pop(context);
              _updateProfile(newMobile1: _mobile1Controller.text, newMobile2: _mobile2Controller.text, newEmail: _emailController.text, newOfficeStreet: _officeAddressStreetController.text, newOfficeCity: _officeAddressCityController.text, newOfficeState: _officeAddressStateController.text, newResidenceStreet: _residenceAddressStreetController.text, newResidenceCity: _residenceAddressCityController.text, newResidenceState: _residenceAddressStateController.text, newPwd: _pwdController.text,context: context);
            });
          },
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    ).show();
  }

  void showMobile2Edit(BuildContext context) {
    Alert(
      context: context,
      content: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: MyTextFieldNoIcon(
          isPassword: false,
          controller: _mobile2Controller,
          isNumber: true,
          isLast: true,
          displayLabel: 'Mobile No 2',
          onChanged: (val) {
            _mobile2Controller.text = val;
          },
        ),
      ),
      buttons: [
        DialogButton(
          color: kColorGreen,
          onPressed: () {
            setState(() {
              Navigator.pop(context);
              _updateProfile(newMobile1: _mobile1Controller.text, newMobile2: _mobile2Controller.text, newEmail: _emailController.text, newOfficeStreet: _officeAddressStreetController.text, newOfficeCity: _officeAddressCityController.text, newOfficeState: _officeAddressStateController.text, newResidenceStreet: _residenceAddressStreetController.text, newResidenceCity: _residenceAddressCityController.text, newResidenceState: _residenceAddressStateController.text, newPwd: _pwdController.text,context: context);
            });
          },
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    ).show();
  }

  void showEmailEdit(BuildContext context) {
    Alert(
      context: context,
      content: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: MyTextFieldTextNoIcon(
          isPassword: false,
          controller: _emailController,
          isText: true,
          isLast: true,
          displayLabel: 'Email Address',
          onChanged: (val) {
            _emailController.text = val;
          },
        ),
      ),
      buttons: [
        DialogButton(
          color: kColorGreen,
          onPressed: () {
            setState(() {
              Navigator.pop(context);
              _updateProfile(newMobile1: _mobile1Controller.text, newMobile2: _mobile2Controller.text, newEmail: _emailController.text, newOfficeStreet: _officeAddressStreetController.text, newOfficeCity: _officeAddressCityController.text, newOfficeState: _officeAddressStateController.text, newResidenceStreet: _residenceAddressStreetController.text, newResidenceCity: _residenceAddressCityController.text, newResidenceState: _residenceAddressStateController.text, newPwd: _pwdController.text,context: context);
            });
          },
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    ).show();
  }

  void showPasswordEdit(BuildContext context) {
    Alert(
      context: context,
      content: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: MyTextFieldTextNoIcon(
          isPassword: false,
          controller: _pwdController,
          isText: true,
          isLast: true,
          displayLabel: 'Set Password',
          onChanged: (val) {
            _pwdController.text = val;
          },
        ),
      ),
      buttons: [
        DialogButton(
          color: kColorGreen,
          onPressed: () {
            setState(() {
              Navigator.pop(context);
              _updateProfile(newMobile1: _mobile1Controller.text, newMobile2: _mobile2Controller.text, newEmail: _emailController.text, newOfficeStreet: _officeAddressStreetController.text, newOfficeCity: _officeAddressCityController.text, newOfficeState: _officeAddressStateController.text, newResidenceStreet: _residenceAddressStreetController.text, newResidenceCity: _residenceAddressCityController.text, newResidenceState: _residenceAddressStateController.text, newPwd: _pwdController.text,context: context);
            });
          },
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    ).show();
  }

  void showOfficeAddressEdit(BuildContext context) {
    Alert(
      context: context,
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: MyTextFieldTextNoIcon(
              isPassword: false,
              controller: _officeAddressStreetController,
              isText: true,
              isLast: true,
              displayLabel: 'Street Address',
              onChanged: (val) {
                _officeAddressStreetController.text = val;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: MyTextFieldTextNoIcon(
              isPassword: false,
              controller: _officeAddressCityController,
              isText: true,
              isLast: true,
              displayLabel: 'City',
              onChanged: (val) {
                _officeAddressCityController.text = val;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: MyTextFieldTextNoIcon(
              isPassword: false,
              controller: _officeAddressStateController,
              isText: false,
              isLast: true,
              displayLabel: 'State',
              onChanged: (val) {
                _officeAddressStateController.text = val;
              },
            ),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          color: kColorGreen,
          onPressed: () {
            setState(() {
              Navigator.pop(context);
              _updateProfile(newMobile1: _mobile1Controller.text, newMobile2: _mobile2Controller.text, newEmail: _emailController.text, newOfficeStreet: _officeAddressStreetController.text, newOfficeCity: _officeAddressCityController.text, newOfficeState: _officeAddressStateController.text, newResidenceStreet: _residenceAddressStreetController.text, newResidenceCity: _residenceAddressCityController.text, newResidenceState: _residenceAddressStateController.text, newPwd: _pwdController.text,context: context);
            });
          },
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    ).show();
  }

  void showResidenceAddressEdit(BuildContext context) {
    Alert(
      context: context,
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: MyTextFieldTextNoIcon(
              isPassword: false,
              controller: _residenceAddressStreetController,
              isText: true,
              isLast: true,
              displayLabel: 'Street Address',
              onChanged: (val) {
                _residenceAddressStreetController.text = val;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: MyTextFieldTextNoIcon(
              isPassword: false,
              controller: _residenceAddressCityController,
              isText: true,
              isLast: true,
              displayLabel: 'City',
              onChanged: (val) {
                _residenceAddressCityController.text = val;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: MyTextFieldTextNoIcon(
              isPassword: false,
              controller: _residenceAddressStateController,
              isText: true,
              isLast: true,
              displayLabel: 'State',
              onChanged: (val) {
                _residenceAddressStateController.text = val;
              },
            ),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          color: kColorGreen,
          onPressed: () {
            setState(() {
              Navigator.pop(context);
              _updateProfile(newMobile1: _mobile1Controller.text, newMobile2: _mobile2Controller.text, newEmail: _emailController.text, newOfficeStreet: _officeAddressStreetController.text, newOfficeCity: _officeAddressCityController.text, newOfficeState: _officeAddressStateController.text, newResidenceStreet: _residenceAddressStreetController.text, newResidenceCity: _residenceAddressCityController.text, newResidenceState: _residenceAddressStateController.text, newPwd: _pwdController.text,context: context);
            });
          },
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    ).show();
  }
}
