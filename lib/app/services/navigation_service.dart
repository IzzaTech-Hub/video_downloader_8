import 'package:get/get.dart';
import 'package:video_downloader_8/app/provider/admob_ads_provider.dart';
import 'package:video_downloader_8/app/provider/app_open_admanager.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();

  factory NavigationService() {
    return _instance;
  }

  NavigationService._internal();

  // Track last ad show time to limit frequency
  DateTime? _lastAdShowTime;

  // Reference to app open ad manager
  final AppOpenAdManager _appOpenAdManager = AppOpenAdManager();

  // Minimum seconds between ads - important for compliance
  // Google's policy generally recommends not showing interstitial ads too frequently
  final int _minSecondsBetweenAds = 20;

  // Initialize
  void init() {
    _lastAdShowTime = DateTime.now().subtract(Duration(seconds: 30));
    // Ensure app open ad is loaded
    _appOpenAdManager.loadAppOpenAd();
  }

  // Navigate to a new page with ad
  Future<dynamic> navigateToWithAd(String routeName,
      {dynamic arguments}) async {
    _showAdIfEligible();
    return await Get.toNamed(routeName, arguments: arguments);
  }

  // Navigate and replace current page with ad
  Future<dynamic> navigateAndReplaceWithAd(String routeName,
      {dynamic arguments}) async {
    _showAdIfEligible();
    return await Get.offAndToNamed(routeName, arguments: arguments);
  }

  // Navigate back with ad
  void navigateBackWithAd() {
    if (Get.previousRoute.isNotEmpty) {
      _showAdIfEligible();
    }
    Get.back();
  }

  // Show ad if enough time has passed since last ad
  void _showAdIfEligible() {
    if (_shouldShowAd()) {
      // Prefer app open ad if available
      if (_appOpenAdManager.isAdAvailable &&
          _appOpenAdManager.canShowAppOpenAd) {
        _appOpenAdManager.showAdIfAvailable();
      } else {
        // Fall back to interstitial ad
        AdMobAdsProvider.instance.showInterstitialAd();
      }
      _lastAdShowTime = DateTime.now();
    }
  }

  // Check if we should show an ad based on time since last ad
  bool _shouldShowAd() {
    if (_lastAdShowTime == null) return true;

    Duration timeSinceLastAd = DateTime.now().difference(_lastAdShowTime!);
    return timeSinceLastAd.inSeconds >= _minSecondsBetweenAds;
  }
}
