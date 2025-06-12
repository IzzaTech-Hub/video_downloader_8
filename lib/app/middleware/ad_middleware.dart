import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_downloader_8/app/provider/admob_ads_provider.dart';

class AdMiddleware extends GetMiddleware {
  // Track last ad show time to limit frequency
  static DateTime? _lastAdShowTime;

  // Minimum seconds between ads - important for compliance
  static final int _minSecondsBetweenAds = 20;

  @override
  RouteSettings? redirect(String? route) {
    return null; // No redirection needed
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    // Don't show ads for certain pages that already have their own ad logic
    bool skipAdForThisPage = page?.name?.contains('splash') == true ||
        page?.name?.contains('how_to') == true;

    if (!skipAdForThisPage) {
      _showAdIfEligible();
    }

    return page;
  }

  // Show ad if enough time has passed since last ad
  static void _showAdIfEligible() {
    if (_shouldShowAd()) {
      AdMobAdsProvider.instance.showInterstitialAd();
      _lastAdShowTime = DateTime.now();
    }
  }

  // Check if we should show an ad based on time since last ad
  static bool _shouldShowAd() {
    if (_lastAdShowTime == null) return true;

    Duration timeSinceLastAd = DateTime.now().difference(_lastAdShowTime!);
    return timeSinceLastAd.inSeconds >= _minSecondsBetweenAds;
  }
}
