import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_downloader_8/app/provider/admob_ads_provider.dart';
import 'package:video_downloader_8/app/utils/app_strings.dart';

class TabsController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  //TODO: Implement HomeController

  var tabIndex = 0.obs;
//  AppLovin_CTL appLovin_CTL=Get.find();
  // GoogleAdsCTL googleAdsCTL = Get.find();

  final remoteConfig = FirebaseRemoteConfig.instance; //? Commented by jamal

  @override
  void onInit() async {
    //? Commented by jamal start
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 5),
    ));

    await remoteConfig.setDefaults(const {
      "isAdEnable": false,
      "native_ad": "ca-app-pub-3940256099942544/2247696110",
      "banner_ad": "ca-app-pub-3940256099942544/6300978111",
      "inter_ad": "ca-app-pub-3940256099942544/1033173712",
      "appopen_ad": "ca-app-pub-3940256099942544/3419835294",
      "app_id": "ca-app-pub-7919904592089531~9888122054"
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
}
