import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:video_downloader_8/app/provider/admob_ads_provider.dart';
import 'package:video_downloader_8/app/provider/app_open_admanager.dart';
import 'package:video_downloader_8/app/routes/app_pages.dart';
import 'package:video_downloader_8/app/services/navigation_service.dart';

class HowToScreenController extends GetxController {
  //TODO: Implement HowToScreenController
  final count = 0.obs;
  late PageController pageController;
  final currentPageNotifier = ValueNotifier<int>(0);
  var pageIndex = 0.obs;
  bool isNavigating = false;

  // App open ad manager reference
  final AppOpenAdManager _appOpenAdManager = AppOpenAdManager();

  @override
  void onInit() {
    pageController = PageController();

    // Make sure app open ad is loaded
    _appOpenAdManager.loadAppOpenAd();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void increment() => count.value++;

  // Navigate to home with ad
  void navigateToHomeWithAd() {
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
      // print("ad watched");

      // Delay navigation slightly to ensure ad has time to appear
      Future.delayed(Duration(milliseconds: 500), () {
        _proceedWithNavigation();
      });
    }
  }

  // Proceed with navigation after showing ad
  void _proceedWithNavigation() {
    Get.offAllNamed(Routes.TabsScreenView);
    isNavigating = false;
  }
}
