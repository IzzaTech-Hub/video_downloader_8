import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:video_downloader_8/app/provider/admob_ads_provider.dart';
import 'package:video_downloader_8/app/provider/app_open_admanager.dart';
import 'package:video_downloader_8/app/utils/size_config.dart';
import 'colors.dart';

class ComFunction {
  static bool validateEmail(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

  static hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  // Last time an ad was shown
  static DateTime? _lastAdShowTime;
  
  // Reference to app open ad manager
  static final AppOpenAdManager _appOpenAdManager = AppOpenAdManager();
  
  // Minimum seconds between ads to avoid excessive ads
  static final int _minSecondsBetweenAds = 20;
  
  // Initialize ad components
  static void initAds() {
    _lastAdShowTime = DateTime.now().subtract(Duration(seconds: 30));
    _appOpenAdManager.loadAppOpenAd();
  }
  
  // Navigate to a new page with ad
  static Future<dynamic> navigateWithAd(String routeName, {dynamic arguments}) async {
    _showAdIfEligible();
    return await Get.toNamed(routeName, arguments: arguments);
  }
  
  // Navigate and replace current page with ad
  static Future<dynamic> navigateAndReplaceWithAd(String routeName, {dynamic arguments}) async {
    _showAdIfEligible();
    return await Get.offAndToNamed(routeName, arguments: arguments);
  }
  
  // Navigate back with ad
  static void navigateBackWithAd() {
    _showAdIfEligible();
    Get.back();
  }
  
  // Show ad if enough time has passed since last ad
  static void _showAdIfEligible() {
    if (_shouldShowAd()) {
      // Prefer app open ad if available
      if (_appOpenAdManager.isAdAvailable && _appOpenAdManager.canShowAppOpenAd) {
        _appOpenAdManager.showAdIfAvailable();
      } else {
        // Fall back to interstitial ad
        AdMobAdsProvider.instance.showInterstitialAd();
      }
      _lastAdShowTime = DateTime.now();
    }
  }
  
  // Check if we should show an ad based on time since last ad
  static bool _shouldShowAd() {
    if (_lastAdShowTime == null) return true;
    
    Duration timeSinceLastAd = DateTime.now().difference(_lastAdShowTime!);
    return timeSinceLastAd.inSeconds >= _minSecondsBetweenAds;
  }

  static showExitDialog({
    required String title,
    required String msg,
  }) {
    Get.defaultDialog(
        title: title,
        middleText: msg,
        textConfirm: "Yes",
        textCancel: "No",
        onCancel: () {
          // Get.back();
        },
        onConfirm: () {
          // Show an ad before exiting if possible
          if (_appOpenAdManager.isAdAvailable) {
            _appOpenAdManager.forceShowAppOpenAd();
            // Give the ad time to show before exiting
            Future.delayed(Duration(milliseconds: 500), () {
              SystemNavigator.pop();
            });
          } else {
            SystemNavigator.pop();
          }
        },
        titleStyle: TextStyle(color: Colors.blue),
        confirmTextColor: AppColors.white);
  }

  static showInfoDialog({
    required String title,
    required String msg,
  }) {
    Get.defaultDialog(
        title: title,
        middleText: msg,
        radius: 10,
        textConfirm: "OK",
        onConfirm: () {
          Get.back();
        },
        titleStyle: TextStyle(color: Colors.blue),
        confirmTextColor: AppColors.white);
  }

  // static showToast(String message) {
  //   Fluttertoast.showToast(
  //       msg: message,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       backgroundColor: AppColor.primaryBlue,
  //       textColor: AppColor.white,
  //       fontSize: 16.0);
  // }

  static showProgressLoader(String msg) {
    EasyLoading.show(status: msg);
  }

  static hideProgressLoader() {
    EasyLoading.dismiss();
  }

  static void initializeLoader() {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 60
      ..radius = 20
      ..backgroundColor = AppColors.white
      ..indicatorColor = Colors.blue
      ..textColor = Colors.white
      ..userInteractions = true
      ..dismissOnTap = false
      ..indicatorType = EasyLoadingIndicatorType.circle;
  }
}

// //? Commented by jamal start
Container NativeAdMethed(NativeAd? nativeAd, RxBool isNativeAdLoaded) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 1.5),
    child: Obx(() => isNativeAdLoaded.value
        ? Container(width: 320, height: 280, child: AdWidget(ad: nativeAd!))
        : Container(
            width: 320,
            height: 280,
            // color: Colors.grey,

            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey)),
            child: Center(
                child: Text(
              "Ads Placement",
              style: TextStyle(color: Colors.white, fontSize: 22),
            )),
          )),
  );
}
//? Commented by jamal end
