import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:saketcourt/components/my_visible_indicator.dart';
import 'package:saketcourt/models/duesModel.dart';
import 'package:saketcourt/models/orderIdModel.dart';
import 'package:saketcourt/models/subscriptionModel.dart';
import 'package:saketcourt/screens/Dashboard.dart';
import 'package:saketcourt/utils/MySnackBar.dart';
import 'package:saketcourt/utils/my_logo_alert.dart';
import '../utils/constants.dart';

class Subscriptions extends StatefulWidget {
  const Subscriptions({super.key});
  static const String id = "subscription";

  @override
  State<Subscriptions> createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  List<Detail> details = [];
  String? receiptDate;
  String? receiptNo;
  String? bankName;
  String? totalAmt;
  String? remark;
  int? totalDues;
  final razorpay = Razorpay();
  bool isLoading = true;
  int enteredAmount = 0;
  String _orderId = '';
  String paymentId='';
  String verificationId='';

  @override
  void initState() {
    super.initState();
    _mydues();
    _mysubscriptions();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPGSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerPGFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerPGWallet);

  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void handlerPGSuccess(PaymentSuccessResponse response) {

    setState(() {
      isLoading = true;
      paymentId = response.paymentId!;
      verificationId = response.signature!;
      orderIdUpdate();


    });
  }

  void handlerPGFailure(PaymentFailureResponse response) {
    Clipboard.setData(const ClipboardData(text: 'failure')).then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.message!)));
    });
  }

  void handlerPGWallet(ExternalWalletResponse response) {
    Clipboard.setData(const ClipboardData(text: 'wallet')).then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.walletName!)));
    });
  }


  void openCheckout(int? amount) {
    var options = {
      "key": glbRzpId,
      "amount": enteredAmount*100,
      "name": glbMemName,
      "order_id": _orderId,
      "description": 'Subscription Fees',
      "timeout":180 ,
      "prefill": {"contact": glbMobNo,},
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      Clipboard.setData(const ClipboardData(text: 'ERROR')).then((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  String showDate(String? date) {
    if (date == null || date.isEmpty) {
      return 'Invalid date';
    }

    try {
      date = date.trim();

      DateFormat inputFormat = DateFormat('dd-MM-yyyy');
      DateTime parsedDate = inputFormat.parse(date);

      DateFormat outputFormat = DateFormat('dd-MMM-yy');
      String formatted = outputFormat.format(parsedDate);
      return formatted;
    } catch (e) {

      return 'Invalid date';
    }
  }

 void orderIdUpdate() async{
   var dio = Dio();
   dio.options.baseUrl = kAPIBaseURL;
   dio.options.connectTimeout = const Duration(milliseconds: 5000);
   dio.options.receiveTimeout = const Duration(milliseconds: 5000);
   dio.interceptors.add(LogInterceptor(requestBody: false));
   dio.options.headers["Authorization"] = "Bearer $glbAuthToken";

   String url = 'update_orderid_status.php';
   FormData formData = FormData.fromMap(
     {
       "orderid":_orderId,
       "transid": paymentId,
       "verification_code": verificationId,
     },
   );
   await dio.post(url, data: formData).then((value) {
     if (value.data["status"]){
       mySnackBar(context: context, widget: const Text('Payment successfully done'), backGroundColor: kColorGreen);
       setState(() {
         isLoading=true;
         _mysubscriptions();
         _mydues();

       });
     }else{
       mySnackBar(context: context, widget: Text(value.data["message"]), backGroundColor: kColorRed);
     }
   });



 }


  void getOrderId() async{
    var dio = Dio();
    dio.options.baseUrl = kAPIBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 5000);
    dio.options.receiveTimeout = const Duration(milliseconds: 5000);
    dio.interceptors.add(LogInterceptor(requestBody: false));
    dio.options.headers["Authorization"] = "Bearer $glbAuthToken";

    String url = 'orderId.php';
    FormData formData = FormData.fromMap(
      {
        "member_id":glbID,
        "amount": enteredAmount * 100,
      },
    );
    await dio.post(url, data: formData).then((value) {
      OrderIdModel generalModel = OrderIdModel.fromJson(value.data);

      setState(() {
        isLoading = false;
        if (generalModel.status) {
          _orderId = generalModel.message;
          openCheckout(enteredAmount);
        } else {
          myLogoAlert(
              context: context,
              navigateEnabled: false,
              route: '',
              message: 'Server Not Responding - try again later');
        }
      });
    });

  }

  void _mydues() async {
    var dio = Dio();
    dio.options.baseUrl = kAPIBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 5000);
    dio.options.receiveTimeout = const Duration(milliseconds: 5000);
    dio.interceptors.add(LogInterceptor(requestBody: false));
    dio.options.headers["Authorization"] = "Bearer $glbAuthToken";

    String url = 'member_dues.php';

    FormData formData = FormData.fromMap({
      "id": glbID,
    });

    final response = await dio.post(url, data: formData);
    if (response.statusCode == 200) {

      DuesModel dues = DuesModel.fromJson(response.data);

      setState(() {
        totalDues = dues.totalDues;
        enteredAmount=dues.totalDues!;


      });
    } else {
      mySnackBar(context: context, widget: Text("Failed to load Dues Amount"), backGroundColor: kColorRed);
    }
  }

  void _mysubscriptions() async {
    var dio = Dio();
    dio.options.baseUrl = kAPIBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 5000);
    dio.options.receiveTimeout = const Duration(milliseconds: 5000);
    dio.interceptors.add(LogInterceptor(requestBody: false));
    dio.options.headers["Authorization"] = "Bearer $glbAuthToken";

    String url = 'payment_history.php';

    FormData formData = FormData.fromMap({
      "membership_no": glbMemCode,
    });

    final response = await dio.post(url, data: formData);
    if (response.statusCode == 200) {
      PaymentModel payment = PaymentModel.fromJson(response.data);

      setState(() {
        details = payment.result.details;
        isLoading=false;
      });
    } else {
      mySnackBar(context: context, widget: Text("Failed to load Receipt Data"), backGroundColor: kColorRed);
    }
  }



  void _showEnterAmountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController amountController = TextEditingController();

        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          titlePadding: EdgeInsets.zero,
          title: Container(
            decoration: const BoxDecoration(
              color: kColorMidNightBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: const Center(
              child: Text(
                'Enter Amount',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'To Make Advance Payment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Amount',
                ),
                onChanged: (val){
                  setState(() {
                    amountController.text=val;
                  });
                }
                ,
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kColorRed,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel', style: TextStyle(color: kColorWhite)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kColorGreen,
                  ),
                  onPressed: () {
                    setState(() {
                     // mySnackBar(context: context, widget: Text(amountController.text), backGroundColor: kColorGreen);
                      enteredAmount = int.tryParse(amountController.text) ?? 0;
                      Navigator.of(context).pop();
                      getOrderId();
                    });

                    //openCheckout(enteredAmount);
                  },
                  child: const Text('Pay', style: TextStyle(color: kColorWhite)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  void _showEnterAmountDialogWithDues() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController amountController = TextEditingController();

        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          titlePadding: EdgeInsets.zero,
          title: Container(
            decoration: const BoxDecoration(
              color: kColorMidNightBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: const Center(
              child: Text(
                'Enter Amount',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Your Total Dues are: Rs $totalDues',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Amount',
                ),
                onChanged: (val) {
                  setState(() {
                    amountController.text = val;
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kColorRed,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel', style: TextStyle(color: kColorWhite)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kColorGreen,
                  ),
                  onPressed: () {
                    setState(() {
                      enteredAmount = int.tryParse(amountController.text) ?? 0;
                      Navigator.of(context).pop();
                      getOrderId();
                    });
                  },
                  child: const Text('Pay', style: TextStyle(color: kColorWhite)),
                ),
              ],
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
          'Payment History',
          style: TextStyle(color: kColorWhite, fontSize: 18),
        ),
        backgroundColor: kColorMidNightBlue,
        actions: [
          TextButton(
            onPressed: () {
              if (totalDues == 0) {
                _showEnterAmountDialog();
              } else {
                _showEnterAmountDialogWithDues();
                //openCheckout(totalDues);
              }
            },
            child: const Text(
              'PAY',
              style: TextStyle(
                color: kColorWhite,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (totalDues != null && totalDues! > 0)
                      Text(
                        'Your Total Dues are: Rs $totalDues',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      )
                    else
                      const Text(
                        'You Have No Dues',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                  ],

                ),
              ),
              myVisibleIndicator(isVisible: isLoading),
              ...details.map((detail) {
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
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  children: [
                                    const Text('Receipt No: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                        detail.receiptNo ?? '',
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
                                    const Text('Receipt Date: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                        showDate(detail.receiptDate) ?? 'No date available',
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
                                    const Text('Bank Name: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                        detail.bankName ?? '',
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
                                    const Text('Amount: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Expanded(
                                      child: Text(
                                        detail.totalAmt ?? '',
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
                                        text: 'Remarks: ',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: detail.remark ?? '',
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
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
