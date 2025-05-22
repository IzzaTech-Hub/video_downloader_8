import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:video_downloader_8/app/routes/app_pages.dart';
import 'package:video_downloader_8/app/utils/CM.dart';
import 'package:video_downloader_8/app/utils/images.dart';
import '../../../utils/colors.dart';
import '../../../utils/size_config.dart';
import '../controllers/home_controller.dart';
import '../controllers/tabs_controller.dart';
import 'download_progress_screen.dart';
import 'downloaded_screen.dart';
import 'home_view.dart';

class TabsScreenView extends GetView<TabsController> {
  HomeController homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    print("build function called");

    return WillPopScope(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        key: controller.scaffoldKey,
        drawer: Drawer(
          width: SizeConfig.blockSizeHorizontal * 75,
          child: Column(
            children: [
              Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.blockSizeVertical * 30,

                // color: AppColors.neonBorder,
                child: Image.asset(
                  AppImages.main_icon,
                  scale: 4,
                ),
              ),
              GestureDetector(
                  onTap: () {
                    LaunchReview.launch(
                      androidAppId:
                          "com.viddownloader.free.downloader.videodownloader",
                    );
                  },
                  child: drawer_widget(
                      CupertinoIcons.hand_thumbsup_fill, "Rate Us")),
              GestureDetector(
                  onTap: () {
                    controller.ShareApp();
                  },
                  child: drawer_widget(Icons.share, "Share")),
              // GestureDetector(
              //     onTap: () {
              //       controller.openURL(
              //           "https://sites.google.com/view/appgeniusx/home");
              //     },
              //     child: drawer_widget(Icons.privacy_tip, "Privacy Policy"))
            ],
          ),
        ),
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              controller.scaffoldKey.currentState!.openDrawer();
            },
            child: Image.asset(
              AppImages.menu,
              scale: 18,
              color: Colors.grey.shade200,
            ),
          ),
          backgroundColor: Color(0xFFFE2C3B),

          // Theme.of(context).scaffoldBackgroundColor,
          titleTextStyle: TextStyle(
              // color: AppColors.black,
              // color: Colors.white,
              fontSize: SizeConfig.blockSizeHorizontal * 5,
              fontWeight: FontWeight.bold),
          title: Text(
            "Video Downloader",
            style: TextStyle(color: Colors.grey.shade200),
            // style: GoogleFonts.pacifico(),
          ),
          actions: [
            Padding(
                padding:
                    EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 3),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.HOW_TO_SCREEN);
                    // Get.toNamed(Routes.SettingsScreen);
                    // LaunchReview.launch(
                    //   androidAppId: "com.hdvideodownloader.vymate.matevid",
                    // );
                  },
                  child: Icon(
                    Icons.help,
                    size: 32.0,
                    color: Colors.grey.shade200,
                  ),
                )),
            Padding(
              padding:
                  EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 4),
              child: GestureDetector(
                onTap: () {
                  LaunchReview.launch(
                    androidAppId:
                        "com.viddownloader.free.downloader.videodownloader",
                  );
                },
                child: Icon(
                  CupertinoIcons.hand_thumbsup_fill,
                  color: Colors.grey.shade200,
                  size: SizeConfig.blockSizeHorizontal * 7,
                ),
              ),
            ),
          ],
          elevation: 0.0,
        ),
        body: Obx(() => IndexedStack(
              index: controller.tabIndex.value,
              children: [
                HomeView(),
                DownloadProgressScreen(),
                DownloadedScreen(),
                // HomeView(),
                // DownloadProgressScreen(),
                // DownloadedScreen(),
                // WhatsappFeaturesView(),
                // BrowseView(),
              ],
            )),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Obx(() => controller.tabIndex.value != 0
            //     ? Container(
            //         margin: EdgeInsets.only(
            //             bottom: SizeConfig.blockSizeVertical * 2),
            //         child: BannerMaxView(
            //           (AppLovinAdListener? event) =>
            //               print("Banner Add Event: $event"),
            //           BannerAdSize.banner,
            //           AppStrings.MAX_BANNER_ID,
            //         )

            //         // ),
            //         )
            //     : Container()),
            Obx(() => Card(
                  color: Colors.white,
                  shadowColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  elevation: 10,
                  margin: EdgeInsets.all(0.0),
                  child: Container(
                    // decoration: BoxDecoration(),
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal * 3,
                        vertical: SizeConfig.blockSizeVertical * 1.2),
                    width: SizeConfig.blockSizeHorizontal * 100,
                    height: SizeConfig.blockSizeVertical * 7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            // radius: 5,
                            onTap: () {
                              controller.tabIndex.value = 0;
                              homeController.searchTextCTL.text = "";
                              homeController.isBrowsing.value = false;
                              homeController.videos.clear();
                              // controller.appLovin_CTL.showInterAd();
                            },
                            child: FittedBox(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.home_rounded,
                                    size: SizeConfig.blockSizeHorizontal * 20,
                                    color: controller.tabIndex.value == 0
                                        ? AppColors.themeColor
                                        : AppColors.grey,
                                  ),
                                  verticalSpace(
                                      SizeConfig.blockSizeVertical * 1),
                                  Text(
                                    "Home",
                                    style: TextStyle(
                                        color: controller.tabIndex.value == 0
                                            ? AppColors.themeColor
                                            : AppColors.grey,
                                        fontSize: controller.tabIndex.value == 0
                                            ? SizeConfig.blockSizeHorizontal *
                                                10
                                            : SizeConfig.blockSizeHorizontal *
                                                7),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              controller.tabIndex.value = 1;
                              // controller.appLovin_CTL.showInterAd();
                            },
                            child: FittedBox(
                              child: Column(
                                children: [
                                  Image.asset(AppImages.progressBar,
                                      height:
                                          SizeConfig.blockSizeHorizontal * 20,
                                      color: controller.tabIndex.value == 1
                                          ? AppColors.themeColor
                                          : null),
                                  // Icon(
                                  //   Icons.download,
                                  //   size: SizeConfig.blockSizeHorizontal * 20,
                                  //   color: controller.tabIndex.value == 1
                                  //       ? AppColors.themeColor
                                  //       : AppColors.grey,
                                  // ),
                                  verticalSpace(
                                      SizeConfig.blockSizeVertical * 1),
                                  Text(
                                    "Progress",
                                    style: TextStyle(
                                        color: controller.tabIndex.value == 1
                                            ? AppColors.themeColor
                                            : AppColors.grey,
                                        fontSize: controller.tabIndex.value == 1
                                            ? SizeConfig.blockSizeHorizontal *
                                                10
                                            : SizeConfig.blockSizeHorizontal *
                                                7),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              controller.tabIndex.value = 2;
                              // controller.appLovin_CTL.showInterAd();
                              // controller.googleAdsCTL.showInterstitialAd();
                            },
                            child: FittedBox(
                              child: Column(
                                children: [
                                  Image.asset(AppImages.downloads,
                                      height:
                                          SizeConfig.blockSizeHorizontal * 20,
                                      color: controller.tabIndex.value == 2
                                          ? AppColors.themeColor
                                          : AppColors.grey),
                                  // Icon(
                                  //   Icons.cloud_download,
                                  //   size: SizeConfig.blockSizeHorizontal * 20,
                                  //   color: controller.tabIndex.value == 2
                                  //       ? AppColors.themeColor
                                  //       : AppColors.grey,
                                  // ),
                                  verticalSpace(
                                      SizeConfig.blockSizeVertical * 1),
                                  Text(
                                    "Downloads",
                                    style: TextStyle(
                                        color: controller.tabIndex.value == 2
                                            ? AppColors.themeColor
                                            : AppColors.grey,
                                        fontSize: controller.tabIndex.value == 2
                                            ? SizeConfig.blockSizeHorizontal *
                                                10
                                            : SizeConfig.blockSizeHorizontal *
                                                7),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        //! Browser
                        // Expanded(
                        //   child: InkWell(
                        //     borderRadius: BorderRadius.circular(50),
                        //     onTap: () {
                        //       controller.tabIndex.value = 5;
                        //       // controller.appLovin_CTL.showInterAd();
                        //       // controller.googleAdsCTL.showInterstitialAd();
                        //     },
                        //     child: FittedBox(
                        //       child: Column(
                        //         children: [
                        //           Icon(
                        //             Icons.travel_explore,
                        //             color: controller.tabIndex.value == 5
                        //                 ? AppColors.navColors
                        //                 : AppColors.white,
                        //           ),
                        //           verticalSpace(
                        //               SizeConfig.blockSizeVertical * 1),
                        //           Text(
                        //             "Browse",
                        //             style: TextStyle(
                        //                 color: controller.tabIndex.value == 5
                        //                     ? AppColors.navColors
                        //                     : AppColors.white,
                        //                 fontSize: controller.tabIndex.value == 5
                        //                     ? 15
                        //                     : 13),
                        //           )
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  Future<bool> _onWillPop() async {
    if (controller.tabIndex.value != 0) {
      controller.tabIndex.value = 0;
      return false;
    } else {
      if (homeController.searchTextCTL.text.isNotEmpty) {
        homeController.searchTextCTL.text = "";
        homeController.isBrowsing.value = false;

        return false;
      } else {
        ComFunction.showExitDialog(title: "Exit", msg: "Do You want to exit?");
      }
    }
    return false;
  }

  Padding drawer_widget(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 5,
          top: SizeConfig.blockSizeVertical * 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: SizeConfig.blockSizeHorizontal * 7,
            color: AppColors.themeColor,
          ),
          horizontalSpace(SizeConfig.blockSizeHorizontal * 6),
          Text(
            text,
            style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 4),
          ),
          Icon(
            Icons.arrow_forward_ios_outlined,
            color: Colors.transparent,
          )
        ],
      ),
    );
  }
}
