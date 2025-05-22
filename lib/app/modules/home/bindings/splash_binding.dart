import 'package:get/get.dart';

import '../controllers/splash_ctl.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(),
    );
    //   Get.lazyPut<GoogleAdsCTL>(
    //   () => GoogleAdsCTL(),
    // );
    // // Get.put(AppLovin_CTL());
  }
}
