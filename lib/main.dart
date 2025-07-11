import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:video_downloader_8/firebase_options.dart';
import 'package:video_downloader_8/app/provider/app_open_admanager.dart';
import 'package:video_downloader_8/app/provider/app_lifecycle_reactor.dart';
import 'package:video_downloader_8/app/services/navigation_service.dart';
import 'package:video_downloader_8/app/utils/CM.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Initialize with the correct app ID
    await MobileAds.instance.initialize();
    print('AdMob initialized successfully');

    // Initialize AppOpenAdManager
    final appOpenAdManager = AppOpenAdManager();
    appOpenAdManager.loadAppOpenAd();

    // Initialize AppLifecycleReactor
    final appLifecycleReactor =
        AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    appLifecycleReactor.listenToAppStateChanges();

    // Initialize NavigationService
    NavigationService().init();

    // Initialize ComFunction ads
    ComFunction.initAds();

    print('App open ads initialized');
  } catch (e, s) {
    print('Error initializing AdMob or app open ads: $e\n$s');
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.landscapeRight,
  ]);

  // WidgetsFlutterBinding.ensureInitialized();
  // FlutterApplovinMax.initSDK();

  //? commented by jamal start
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      ); //? commented by jamal end

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  //? commented by jamal start
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
      analytics: analytics); //? commented by jamal end

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    analytics
        .setAnalyticsCollectionEnabled(kReleaseMode); //? commented by jamal
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Application",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        builder: EasyLoading.init(),
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
        ),
        // theme: Themes.lightTheme,
        // darkTheme: Themes.darkTheme,
        // themeMode: ThemeMode.light,
      ),
    );
  }
}
