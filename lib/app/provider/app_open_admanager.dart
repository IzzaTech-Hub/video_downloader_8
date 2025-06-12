import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../utils/app_strings.dart';

class AppOpenAdManager {
  // Singleton instance
  static final AppOpenAdManager _instance = AppOpenAdManager._internal();

  factory AppOpenAdManager() {
    return _instance;
  }

  AppOpenAdManager._internal();

  AppOpenAd? appOpenAd;
  bool _isShowingAd = false;
  bool _isLoadingAd = false;

  // Track when the app open ad was last shown
  DateTime? _lastAppOpenAdTime;

  // Minimum time between app open ads (in seconds)
  final int _minSecondsBetweenAppOpenAds = 30;

  /// Whether an ad is available to be shown.
  bool get isAdAvailable {
    return appOpenAd != null;
  }

  /// Check if enough time has passed to show another app open ad
  bool get canShowAppOpenAd {
    if (_lastAppOpenAdTime == null) return true;

    final now = DateTime.now();
    final difference = now.difference(_lastAppOpenAdTime!);
    return difference.inSeconds >= _minSecondsBetweenAppOpenAds;
  }

  void loadAppOpenAd() {
    if (_isLoadingAd) return;

    _isLoadingAd = true;

    AppOpenAd.load(
      adUnitId: AppStrings.ADMOB_APP_OPEN,
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          appOpenAd = ad;
          _isLoadingAd = false;
          print('AppOpenAd loaded successfully');
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
          _isLoadingAd = false;
          // Retry loading after a delay
          Future.delayed(Duration(minutes: 1), () {
            loadAppOpenAd();
          });
        },
      ),
    );
  }

  void showAdIfAvailable() {
    print("ShowAdIfAvailable Called");

    // Don't show if ad isn't loaded yet
    if (!isAdAvailable) {
      print('Tried to show ad before available.');
      loadAppOpenAd();
      return;
    }

    // Don't show if an ad is already showing
    if (_isShowingAd) {
      print('Tried to show ad while already showing an ad.');
      return;
    }

    // Don't show if it's too soon since the last app open ad
    if (!canShowAppOpenAd) {
      print('Too soon to show another app open ad.');
      return;
    }

    // Set the fullScreenContentCallback and show the ad.
    appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        _lastAppOpenAdTime = DateTime.now();
        print('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        appOpenAd = null;
        loadAppOpenAd();
      },
      onAdDismissedFullScreenContent: (ad) {
        print('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        appOpenAd = null;
        loadAppOpenAd();
      },
    );

    appOpenAd!.show();
  }

  // Force show app open ad regardless of timing
  void forceShowAppOpenAd() {
    if (!isAdAvailable) {
      print('No app open ad available to force show.');
      loadAppOpenAd();
      return;
    }

    if (_isShowingAd) {
      print('Already showing an ad, cannot force show.');
      return;
    }

    // Set the fullScreenContentCallback and show the ad.
    appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        _lastAppOpenAdTime = DateTime.now();
        print('$ad onAdShowedFullScreenContent (forced)');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        appOpenAd = null;
        loadAppOpenAd();
      },
      onAdDismissedFullScreenContent: (ad) {
        print('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        appOpenAd = null;
        loadAppOpenAd();
      },
    );

    appOpenAd!.show();
  }
}
