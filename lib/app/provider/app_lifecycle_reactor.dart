import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app_open_admanager.dart';

class AppLifecycleReactor {
  final AppOpenAdManager appOpenAdManager;
  
  // Track when the app went to background
  DateTime? _appBackgroundedTime;
  
  // Minimum time in background to show app open ad (in seconds)
  // This prevents showing an ad if the user quickly switches apps
  final int _minBackgroundTimeForAd = 5;

  AppLifecycleReactor({required this.appOpenAdManager});

  void listenToAppStateChanges() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream
        .forEach((state) => _onAppStateChanged(state));
  }

  void _onAppStateChanged(AppState appState) {
    print("AppState Changed: $appState");
    
    if (appState == AppState.background) {
      // App went to background, record the time
      _appBackgroundedTime = DateTime.now();
    } 
    else if (appState == AppState.foreground) {
      // App came to foreground
      if (_shouldShowAppOpenAd()) {
        appOpenAdManager.showAdIfAvailable();
      }
    }
  }
  
  // Determine if we should show an app open ad based on time in background
  bool _shouldShowAppOpenAd() {
    if (_appBackgroundedTime == null) return false;
    
    final now = DateTime.now();
    final timeInBackground = now.difference(_appBackgroundedTime!);
    
    // Only show ad if app was in background for at least the minimum time
    return timeInBackground.inSeconds >= _minBackgroundTimeForAd;
  }
  
  // Force show an app open ad regardless of timing
  void forceShowAppOpenAd() {
    appOpenAdManager.forceShowAppOpenAd();
  }
}
