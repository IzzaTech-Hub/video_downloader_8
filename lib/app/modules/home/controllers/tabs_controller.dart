import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_downloader_8/app/provider/admob_ads_provider.dart';
import 'package:video_downloader_8/app/provider/app_open_admanager.dart';
import 'package:video_downloader_8/app/utils/app_strings.dart';

class TabsController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  //TODO: Implement HomeController

  var tabIndex = 0.obs;
//  AppLovin_CTL appLovin_CTL=Get.find();
  // GoogleAdsCTL googleAdsCTL = Get.find();

  final remoteConfig = FirebaseRemoteConfig.instance; //? Commented by jamal

  // Track last ad show time to limit frequency
  DateTime? lastAdShowTime;

  // Reference to app open ad manager
  final AppOpenAdManager _appOpenAdManager = AppOpenAdManager();

  // Minimum seconds between ads
  final int minSecondsBetweenAds = 30;

  @override
  void onInit() async {
    //? Commented by jamal start
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 5),
    ));

    // Use AppStrings values as defaults instead of hardcoded test IDs
    await remoteConfig.setDefaults({
      "isAdEnable": false,
      "native_ad": AppStrings.ADMOB_NATIVE,
      "banner_ad": AppStrings.ADMOB_BANNER,
      "inter_ad": AppStrings.ADMOB_INTERSTITIAL,
      "appopen_ad": AppStrings.ADMOB_APP_OPEN,
      "app_id": AppStrings.ADMOB_APP_ID // Use the constant from AppStrings
    });

    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();

      // Use the new config values here.
    });

    await remoteConfig.fetchAndActivate().then((value) {
      bool isAdEnable = remoteConfig.getBool("isAdEnable");
      if (kReleaseMode) {
        AdMobAdsProvider.instance.isAdEnable.value = isAdEnable;
      }

      AppStrings.ADMOB_APP_OPEN = remoteConfig.getString("appopen_ad");
      AppStrings.ADMOB_NATIVE = remoteConfig.getString("native_ad");
      AppStrings.ADMOB_INTERSTITIAL = remoteConfig.getString("inter_ad");
      AppStrings.ADMOB_BANNER = remoteConfig.getString("banner_ad");

      if (isAdEnable) {
        AdMobAdsProvider.instance.initialize();
      }

      print("Remote Ads: ${AppStrings.ADMOB_APP_OPEN}");
    });
    //? Commented by jamal end
    super.onInit();
    lastAdShowTime = DateTime.now().subtract(Duration(seconds: 60));

    // Ensure app open ad is loaded
    _appOpenAdManager.loadAppOpenAd();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  ShareApp() {
    Share.share(
        "Consider downloading this exceptional app, available on the Google Play Store at the following link: https://play.google.com/store/apps/details?id=com.viddownloader.free.downloader.videodownloader");
  }

  Future openURL(String ur) async {
    final Uri _url = Uri.parse(ur);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  void changeTabIndex(int index) {
    // Show ad if enough time has passed since last ad
    if (shouldShowAd()) {
      // Try to use app open ad first if available
      if (_appOpenAdManager.isAdAvailable &&
          _appOpenAdManager.canShowAppOpenAd) {
        _appOpenAdManager.showAdIfAvailable();
      } else {
        // Fall back to interstitial ad
        AdMobAdsProvider.instance.showInterstitialAd();
      }
      lastAdShowTime = DateTime.now();
    }

    tabIndex.value = index;
  }

  bool shouldShowAd() {
    if (lastAdShowTime == null) return true;

    Duration timeSinceLastAd = DateTime.now().difference(lastAdShowTime!);
    return timeSinceLastAd.inSeconds >= minSecondsBetweenAds;
  }
}
