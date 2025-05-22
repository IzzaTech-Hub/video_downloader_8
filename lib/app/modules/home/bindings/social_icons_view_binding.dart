import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class SocialIconsViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    //   Get.lazyPut<GoogleAdsCTL>(
    //   () => GoogleAdsCTL(),
    // );
    // // Get.put(AppLovin_CTL());
  }
}
