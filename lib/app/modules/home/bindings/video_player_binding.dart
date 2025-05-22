import 'package:get/get.dart';
import '../controllers/video_player_ctls.dart';

class VideoPlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoPlayerCTL>(
      () => VideoPlayerCTL(),
    );
  }
}
