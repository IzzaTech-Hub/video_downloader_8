import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_downloader_8/app/provider/admob_ads_provider.dart';
import 'package:video_downloader_8/app/provider/app_open_admanager.dart';
import 'package:video_downloader_8/app/routes/app_pages.dart';
import 'package:video_downloader_8/app/services/navigation_service.dart';

class SplashController extends GetxController {
  //TODO: Implement HomeControlle

  bool? isFirstTime = true;
  final prefs = SharedPreferences.getInstance();
  // AppLovin_CTL appLovin_CTL = Get.find();
  // GoogleAdsCTL googleAdsCT=Get.find();

  var tabIndex = 0.obs;
  Rx<int> percent = 0.obs;
  Rx<bool> isLoaded = false.obs;

  // Flag to prevent multiple navigation attempts
  bool isNavigating = false;

  // App open ad manager reference
  final AppOpenAdManager _appOpenAdManager = AppOpenAdManager();

  @override
  void onInit() async {
    super.onInit();
    try {
      await AdMobAdsProvider.instance.initialize(); //? commented by jamal

      // Load app open ad
      _appOpenAdManager.loadAppOpenAd();
    } catch (e) {
      debugPrint("Error in SplashController: $e");
    }

    Timer? timer;
    timer = Timer.periodic(Duration(milliseconds: 500), (_) {
      int n = Random().nextInt(10) + 5;
      percent.value += n;
      if (percent.value >= 100) {
        percent.value = 100;
        isLoaded.value = true;

        timer!.cancel();
      }
    });

    prefs.then((SharedPreferences pref) {
      isFirstTime = pref.getBool('first_time') ?? true;

      print("Is First Time from Init: $isFirstTime");
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void setFirstTime(bool bool) {
    prefs.then((SharedPreferences pref) {
      pref.setBool('first_time', bool);
      print("Is First Time: $isFirstTime");
    });
  }

  // Navigate with ad
  void navigateWithAd() {
    if (isNavigating) return; // Prevent multiple navigation attempts
    isNavigating = true;

    // First try to show an app open ad if available
    if (_appOpenAdManager.isAdAvailable) {
      _appOpenAdManager.showAdIfAvailable();

      // Delay navigation slightly to ensure ad has time to appear
      Future.delayed(Duration(milliseconds: 500), () {
        _proceedWithNavigation();
      });
    } else {
      // Fall back to interstitial ad if app open ad not available
      AdMobAdsProvider.instance.showInterstitialAd();

      // Delay navigation slightly to ensure ad has time to appear
      Future.delayed(Duration(milliseconds: 500), () {
        _proceedWithNavigation();
      });
    }
  }

  // Proceed with navigation after showing ad
  void _proceedWithNavigation() {
    if (isFirstTime!) {
      setFirstTime(false);
      Get.offAndToNamed(Routes.HOW_TO_SCREEN);
      // Get.offAndToNamed(Routes.HOW_TO_SCREEN);
    } else {
      Get.offAndToNamed(Routes.TabsScreenView);
    }
    isNavigating = false;
  }
}
