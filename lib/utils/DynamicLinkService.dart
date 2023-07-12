/*
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
class DynamicLinkService {
  Future handleDynamicLinks() async {
    // 1. Get the initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData? data =
    await FirebaseDynamicLinks.instance.getInitialLink();

    // 2. handle link that has been retrieved
    _handleDeepLink(data!);

    // 3. Register a link callback to fire if the app is opened up from the background
    // using a dynamic link.
   */
/* FirebaseDynamicLinks.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          // 3a. handle link that has been retrieved
          _handleDeepLink(dynamicLink);
        }, onError: (e) async {
      print('Link Failed: ${e.message}');
    });*//*

  }

  void _handleDeepLink(PendingDynamicLinkData data) {
    final Uri? deepLink = data.link;
    if (deepLink != null) {

      print('_handleDeepLink | deeplink: $deepLink');
    }
  }
}*/
