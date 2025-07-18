import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:video_downloader_8/app/provider/admob_ads_provider.dart';
import 'package:video_downloader_8/app/utils/app_strings.dart';
import '../../../utils/colors.dart';
import '../../../utils/images.dart';
import '../../../utils/size_config.dart';
import '../controllers/home_controller.dart';

class DownloadProgressScreen extends GetView<HomeController> {
  // // // Banner Ad Implementation start // // //
//? Commented by jamal start
  late BannerAd myBanner;
  RxBool isBannerLoaded = false.obs;

  initBanner() {
    BannerAdListener listener = BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) {
        print('Ad loaded.');
        isBannerLoaded.value = true;
      },
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) {
        print('Ad opened.');
      },
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) {
        print('Ad closed.');
      },
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) {
        print('Ad impression.');
      },
    );

    myBanner = BannerAd(
      adUnitId: AppStrings.ADMOB_BANNER,
      size: AdSize.banner,
      request: AdRequest(),
      listener: listener,
    );
    myBanner.load();
  } //? Commented by jamal end

  /// Banner Ad Implementation End ///
  @override
  Widget build(BuildContext context) {
    initBanner(); //? Commented by jamal
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            //? Commented by jamal start
            Obx(() => isBannerLoaded.value &&
                    AdMobAdsProvider.instance.isAdEnable.value
                ? Container(
                    height: AdSize.banner.height.toDouble(),
                    child: AdWidget(ad: myBanner))
                : Container()), //? Commented by jamal end
            controller.downloadingVideos.length <= 0
                ? _noDownloadInProgress()
                : downloadInProgress()
          ],
        ));
  }

  Widget downloadInProgress() {
    return Expanded(
      child: Obx(() => ListView.builder(
          itemCount: controller.downloadingVideos.length,
          itemBuilder: (BuildContext context, int index) {
            // double downSize = controller.downloadingVideos[index].size /
            //     controller.downloadingVideos[0].progress.value;
            return _downloadingItem(
                AppImages.thumbnail_demo,
                "${controller.downloadingVideos[index].name}",
                // controller.downloadingVideos[index].size
                //     .toStringAsFixed(2),
                "${controller.downloadingVideos[index].progress.value}",
                index);
          })),
    );
  }

  Widget _downloadingItem(String img, String name, String progress, int index) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 2,
          vertical: SizeConfig.blockSizeVertical),
      margin: EdgeInsets.symmetric(
          // horizontal: SizeConfig.blockSizeHorizontal * 2,
          vertical: SizeConfig.blockSizeVertical * 0.75),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 1, // How far the shadow spreads
              blurRadius: 2, // The blur radius for the shadow
              offset: Offset(0, 2), // Offset of the shadow (x, y)
            ),
          ],
          color: Colors.grey.shade300,
          borderRadius:
              BorderRadius.circular(SizeConfig.blockSizeHorizontal * 5)
          // borderRadius: BorderRadius.only(
          //     topLeft: Radius.circular(SizeConfig.blockSizeHorizontal * 5),
          //     bottomRight:
          //         Radius.circular(SizeConfig.blockSizeHorizontal * 5))
          ),
      child: Row(
        children: [
          Container(
            width: SizeConfig.blockSizeHorizontal * 20,
            height: SizeConfig.blockSizeVertical * 7,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                img,
                fit: BoxFit.cover,
              ),
            ),
          ),
          horizontalSpace(SizeConfig.blockSizeHorizontal * 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: SizeConfig.blockSizeHorizontal * 55,
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                      fontWeight: FontWeight.bold),
                ),
              ),
              // verticalSpace(SizeConfig.blockSizeVertical * 0.5),
              // Obx(() => Container(
              //       width: SizeConfig.blockSizeHorizontal * 50,
              //       child: Text(
              //         " ${controller.downloadingVideos[index].downloadedSize} / ${controller.downloadingVideos[index].size} MBs",
              //         style: TextStyle(
              //             fontSize: 14,
              //             fontWeight: FontWeight.bold,
              //             overflow: TextOverflow.fade,
              //             color: Colors.grey),
              //       ),
              //     )),
              verticalSpace(SizeConfig.blockSizeVertical),
              Row(
                children: [
                  Obx(() => Container(
                        width: SizeConfig.blockSizeHorizontal * 50,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.grey[400],
                          color: AppColors.themeColor,
                          value: controller
                              .downloadingVideos[index].progress.value,
                        ),
                      )),
                  horizontalSpace(SizeConfig.blockSizeHorizontal * 5),
                  // InkWell(
                  //   onTap: () {},
                  //   child: Icon(
                  //     Icons.pause,
                  //     color: Colors.grey[400],
                  //   ),
                  // ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _noDownloadInProgress() {
    return Expanded(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.empty,
              width: SizeConfig.blockSizeHorizontal * 40,
            ),
            verticalSpace(SizeConfig.blockSizeVertical * 2),
            Text(
              "No Video In Progress!",
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 5,
                  color: Colors.grey),
            ),
            verticalSpace(SizeConfig.blockSizeVertical * 1),
            // Text(
            //   "No current downloads in progress",
            //   style: TextStyle(
            //       fontSize: SizeConfig.blockSizeHorizontal * 4,
            //       color: Colors.grey),
            // ),
          ],
        ),
      ),
    );
  }
}
