import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_school_bd/screens/LiveCourse/success.dart';
import 'package:learning_school_bd/screens/MainHome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../LiveCourse/Failed.dart';
import '../Module/ModuleController.dart';

class Meeting extends StatefulWidget {
  final String MeetindUrl;
  const Meeting(
      {Key? key, required this.MeetindUrl})
      : super(key: key);

  @override
  State<Meeting> createState() => _MeetingState();
}

class _MeetingState extends State<Meeting> {
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
  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("Yes"),
      onPressed: () { Get.to(()=>Main_home(indexof: 0)); },
    );Widget no = TextButton(
      child: Text("No"),
      onPressed: () {Get.back();},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure!!"),
      content: Text("Press yes if you want to stay on the page"),
      actions: [
        no,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        showAlertDialog(context);
        return true;
      },
      child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                automaticallyImplyLeading: false, // Don't show the leading button

                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    showAlertDialog(context);

                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                title: Text(
                  "Live Class",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16),
                )),
            body: Builder(builder: (BuildContext context) {
              return Stack(
                children: [
                  WebView(
                    key: _key,
                    
                    initialUrl:
                        widget.MeetindUrl,
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
                          'https://meet.jit.si/static/close3.html')) {

                        Get.to(() => PaymentFaild());
                      }

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
          )),
    );
  }
}
