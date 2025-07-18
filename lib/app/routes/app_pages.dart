import 'package:get/get.dart';
import '../middleware/ad_middleware.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/bindings/settings_binding.dart';
import '../modules/home/bindings/social_icons_view_binding.dart';
import '../modules/home/bindings/splash_binding.dart';
import '../modules/home/bindings/tabs_binding.dart';
import '../modules/home/bindings/video_player_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/views/settings_scree.dart';
import '../modules/home/views/social_icons_view.dart';
import '../modules/home/views/splash_screen.dart';
import '../modules/home/views/tabs_screen_view.dart';
import '../modules/home/views/video_player_screen.dart';
import '../modules/how_to_screen/bindings/how_to_screen_binding.dart';
import '../modules/how_to_screen/views/how_to_screen_view.dart';
import '../modules/whatsapp_features/bindings/whatsapp_features_binding.dart';
import '../modules/whatsapp_features/views/whatsapp_features_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SplashScreen;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      middlewares: [AdMiddleware()],
    ),
    GetPage(
      name: _Paths.TabsScreenView,
      page: () => TabsScreenView(),
      binding: TabsBinding(),
      middlewares: [AdMiddleware()],
    ),
    GetPage(
      name: _Paths.SettingsScreen,
      page: () => SettingsScreen(),
      binding: SettingBinding(),
      middlewares: [AdMiddleware()],
    ),
    GetPage(
      name: _Paths.VideoPlayer,
      page: () => VideoPlayerScreen(),
      binding: VideoPlayerBinding(),
      middlewares: [AdMiddleware()],
    ),
    GetPage(
      name: _Paths.WHATSAPP_FEATURES,
      page: () => WhatsappFeaturesView(),
      binding: WhatsappFeaturesBinding(),
      middlewares: [AdMiddleware()],
    ),
    GetPage(
      name: _Paths.HOW_TO_SCREEN,
      page: () => HowToScreenView(),
      binding: HowToScreenBinding(),
    ),
    GetPage(
      name: _Paths.SplashScreen,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.SocialIconsView,
      page: () => SocialIconsView(),
      binding: SocialIconsViewBinding(),
      middlewares: [AdMiddleware()],
    ),
  ];
}
