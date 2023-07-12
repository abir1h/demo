import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_school_bd/screens/LiveCourse/success.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../LiveCourse/Failed.dart';
import 'ModuleController.dart';

class PaymentView extends StatefulWidget {
  final String ammount, id, userid;
  const PaymentView(
      {Key? key, required this.ammount, required this.id, required this.userid})
      : super(key: key);

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final controller = Get.put(ModuleController());
  var UserId;
  getUserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');
    setState(() {
      UserId = id;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserdata();
    //print('https://lsb.bestaid.com.bd/api/live-class-payment/'+widget.ammount+'/'+widget.id+"/"+widget.userid);
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          if (kDebugMode) {
            print(message.message);
          }
        });
  }

  bool isloaded = false;
  bool isLoading = true;
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: false, // Don't show the leading button

          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: Text(
            "Payment",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16),
          )),
      body: Builder(builder: (BuildContext context) {
        return Stack(
          children: [
            WebView(
              key: _key,
              initialUrl: 'https://lsb.bestaid.com.bd/api/live-class-payment/' +
                  widget.ammount +
                  '/' +
                  widget.id +
                  "/" +
                  widget.userid,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onProgress: (int progress) {
                print('WebView is loading (progress : $progress%)');
                if(progress==100){
                  setState(() {
                    isLoading = false;
                  });
                }

              },
              javascriptChannels: <JavascriptChannel>{
                _toasterJavascriptChannel(context),
              },
              navigationDelegate: (NavigationRequest request) {
                if (request.url.startsWith(
                    'https://lsb.bestaid.com.bd/api/payment-end-failed')) {
                  print('blocking navigation to $request}');
                  Get.to(() => PaymentFaild());
                } else if (request.url.startsWith(
                    'https://lsb.bestaid.com.bd/api/payment-end-success')) {
                  Get.to(() => PaymentSuccess());
                }
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                print('Page started loading: $url');
              },
              onPageFinished: (String url) {
                print('Page finished loading: $url');

              },
              gestureNavigationEnabled: true,
              backgroundColor: const Color(0x00000000),
            ),
            isLoading?Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height/3,),
                Center(child: CircularProgressIndicator(),),
                Center(child: Text('Please wait...',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w400,fontSize: 14),),)
              ],
            )
                : Stack(),
          ],
        );
      }),
    ));
  }
}
