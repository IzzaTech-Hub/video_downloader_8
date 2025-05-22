import 'dart:io';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_downloader_8/app/provider/admob_ads_provider.dart';
import 'package:video_downloader_8/app/utils/app_strings.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
import '../../../utils/images.dart';
import '../../../utils/size_config.dart';
import '../controllers/home_controller.dart';

class DownloadedScreen extends GetView<HomeController> {
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
  }
  //? Commented by jamal end

  /// Banner Ad Implementation End ///
  @override
  Widget build(BuildContext context) {
    initBanner(); //? Commented by jamal
    print("Downloaded Screen");
    controller.getDir();
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
            controller.downloadedVideos.isEmpty
                ? _noDownloaded()
                : _downloadedItems()
          ],
        ));
  }

  Widget _downloadedItems() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 2),
        child: Obx(() => ListView.builder(
            itemCount: controller.downloadedVideos.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                  onTap: () {
                    Get.toNamed(Routes.VideoPlayer,
                        arguments: [controller.downloadedVideos[index].path]);
                  },
                  child: _downloadedItem(index));
            })),
      ),
    );
  }

  Widget _downloadedItem(int index) {
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
              offset: Offset(0, 3), // Offset of the shadow (x, y)
            ),
          ],
          color: AppColors.inputFieldColor,
          borderRadius:
              BorderRadius.circular(SizeConfig.blockSizeHorizontal * 5)
          // borderRadius: BorderRadius.only(
          //   topLeft: Radius.circular(SizeConfig.blockSizeHorizontal * 5),
          //   bottomRight: Radius.circular(SizeConfig.blockSizeHorizontal * 5),
          // )
          // BorderRadius.all(Radius.circular(10))
          ),
      child: Row(
        children: [
          Container(
            width: SizeConfig.blockSizeHorizontal * 20,
            height: SizeConfig.blockSizeVertical * 7,
            // color: Colors.amber,
            child: Stack(
              children: [
                Container(
                  width: SizeConfig.blockSizeHorizontal * 20,
                  height: SizeConfig.blockSizeVertical * 7,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FutureBuilder(
                        future:
                            _getImage(controller.downloadedVideos[index].path),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              return Hero(
                                tag: controller.downloadedVideos[index].name,
                                child: Image.file(
                                  File(snapshot.data.toString()),
                                  fit: BoxFit.cover,
                                ),
                              );
                            } else {
                              return Center(
                                child: Image.asset(
                                  AppImages.thumbnail_demo,
                                  fit: BoxFit.cover,
                                ),
                              );
                            }
                          } else {
                            return Center(
                              child: Image.asset(
                                AppImages.thumbnail_demo,
                                fit: BoxFit.fitHeight,
                              ),
                            );
                          }
                        }),

                    //  Image.asset(
                    //   img,
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.blockSizeVertical * 0.25,
                        horizontal: SizeConfig.blockSizeHorizontal),
                    decoration: BoxDecoration(
                        color: AppColors.themeColor,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            topLeft: Radius.circular(10))),
                    child: Text(
                      "${controller.downloadedVideos[index].duration}",
                      style: TextStyle(color: AppColors.white, fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(SizeConfig.blockSizeHorizontal * 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: SizeConfig.blockSizeHorizontal * 50,
                child: Text(
                  "${controller.downloadedVideos[index].name}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                      fontWeight: FontWeight.bold),
                ),
              ),
              verticalSpace(SizeConfig.blockSizeVertical * 0.5),
              Text(
                "Size ${controller.downloadedVideos[index].size}",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ],
          ),
          Spacer(),
          PopupMenuButton(
              elevation: 20,
              // offset: Offset.infinite,
              offset: Offset.fromDirection(
                380,
              ),
              onSelected: (value) {
                if (value == 0) {
                  controller.shareVideo(controller.downloadedVideos[index]);
                } else if (value == 1) {
                  // controller.shareVideo(controller.downloadedVideos[index]);
                  controller.deleteVideo(controller.downloadedVideos[index]);
                }
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("Share"),
                      value: 0,
                    ),
                    PopupMenuItem(
                      child: Text("Delete"),
                      value: 1,
                    ),
                    // PopupMenuItem(
                    //   child: Text("Rename"),
                    //   value: 2,
                    // ),
                    // PopupMenuItem(
                    //   child: Text("Copy URL"),
                    //   value: 2,
                    // ),
                    // PopupMenuItem(
                    //   child: Text("Go to website"),
                    //   value: 2,
                    // ),
                  ])
          // GestureDetector(
          //   onTap: (){

          //   },
          //   child: Icon(Icons.more_vert))
        ],
      ),
    );
  }

  Widget _noDownloaded() {
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
              "Your video vault is waiting!",
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 5,
                  color: Colors.grey),
            ),
            verticalSpace(SizeConfig.blockSizeVertical * 1),
            // Text(
            //   "No current downloads in progress",
            //   style: TextStyle(
            //       color: Colors.grey,
            //       fontSize: SizeConfig.blockSizeHorizontal * 4),
            // ),
          ],
        ),
      ),
    );
  }

  _getImage(videoPathUrl) async {
    await Future.delayed(Duration(milliseconds: 500));
    String? thumb = await VideoThumbnail.thumbnailFile(
      video: videoPathUrl,
      thumbnailPath: (await getTemporaryDirectory()).path,

      imageFormat: ImageFormat.JPEG,
      maxHeight:
          64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    );
    return thumb;
  }
}
