import 'package:get/get.dart';

import '../controllers/download_progress_ctl.dart';
import '../controllers/downloaded_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/tabs_controller.dart';

class TabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabsController>(
      () => TabsController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<DownloadProgressCTL>(
      () => DownloadProgressCTL(),
    );
    Get.lazyPut<DownloadedCTL>(
      () => DownloadedCTL(),
    );
    // Get.lazyPut<WhatsappFeaturesController>(
    //   () => WhatsappFeaturesController(),
    // );
  }
}
