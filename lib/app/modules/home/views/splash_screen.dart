import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/colors.dart';
import '../../../utils/images.dart';
import '../../../utils/size_config.dart';
import '../controllers/splash_ctl.dart';

class SplashScreen extends GetView<SplashController> {
  SplashScreen({Key? key}) : super(key: key);
  // Obtain shared preferences.
  bool? b;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    b = controller.isFirstTime;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight,
          color: Colors.white,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: SizeConfig.blockSizeVertical * 20,
                    left: SizeConfig.blockSizeHorizontal * 19),
                child: Image.asset(
                  AppImages.main_icon,
                  width: SizeConfig.blockSizeHorizontal * 60,
                  height: SizeConfig.blockSizeVertical * 30,
                  // fit: BoxFit.cover,
                ),
              ),
              // Opacity(
              //   opacity: 0.7,
              //   child: Container(
              //     width: SizeConfig.screenWidth,
              //     height: SizeConfig.screenHeight,
              //     color: Colors.black,
              //   ),
              // ),

              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // verticalSpace(SizeConfig.blockSizeVertical * 5),
                    Padding(
                      padding: EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical * 15),
                      child: Text("All Video Downloader",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: SizeConfig.blockSizeHorizontal * 6,
                              fontWeight: FontWeight.bold)),
                    ),
                    verticalSpace(SizeConfig.blockSizeVertical * 1),
                    Text("Lets download All videos free!",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: SizeConfig.blockSizeHorizontal * 3,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 5),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(() => controller.isLoaded.value
                          ? GestureDetector(
                              onTap: () {
                                if (controller.isFirstTime!) {
                                  controller.setFirstTime(false);
                                  Get.offAndToNamed(Routes.HOW_TO_SCREEN);
                                } else {
                                  Get.offAndToNamed(Routes.TabsScreenView);
                                }
                              },
                              child: Container(
                                height: SizeConfig.blockSizeVertical * 5.5,
                                width: SizeConfig.blockSizeHorizontal * 67,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 255, 105, 46),
                                        // Color(0xFFF8005C),
                                        Color(0xFFFE2C3B),
                                        // Color(0xffFF4800),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter),
                                  // borderRadius: BorderRadius.circular(
                                  //     SizeConfig.blockSizeHorizontal * 5),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        SizeConfig.blockSizeHorizontal * 5),
                                    bottomRight: Radius.circular(
                                        SizeConfig.blockSizeHorizontal * 3),
                                    topRight: Radius.circular(
                                        SizeConfig.blockSizeHorizontal * 15),
                                    bottomLeft: Radius.circular(
                                        SizeConfig.blockSizeHorizontal * 5),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(0.5), // Shadow color
                                      spreadRadius:
                                          1, // How far the shadow spreads
                                      blurRadius:
                                          2, // The blur radius for the shadow
                                      offset: Offset(
                                          0, 3), // Offset of the shadow (x, y)
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    "GET STARTED",
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal * 6,
                                        color: AppColors.white),
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.blockSizeVertical * 15,
                                  right: SizeConfig.blockSizeHorizontal * 15,
                                  left: SizeConfig.blockSizeHorizontal * 15),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Adjust the radius as per your requirement
                                  color: Colors.white,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      10), // Same radius as the container
                                  child: LinearProgressIndicator(
                                      minHeight: 6,
                                      backgroundColor: Colors.grey.shade100,
                                      color: Colors.orange),
                                ),
                              )))
                      // Container(
                      //   padding: EdgeInsets.symmetric(
                      //       horizontal: SizeConfig.blockSizeHorizontal * 15),
                      //   width: SizeConfig.screenWidth,
                      //   child: Center(
                      //     child: Obx(() => LinearPercentIndicator(
                      //           width: SizeConfig.screenWidth * .65,
                      //           lineHeight: SizeConfig.blockSizeVertical,
                      //           percent: controller.percent.value / 100,

                      //           // center: new Text("${controller.percent.value} %"),
                      //           backgroundColor: Colors.white,
                      //           progressColor: Colors.red,
                      //         )),
                      //   ),
                      // ),

                      // verticalSpace(SizeConfig.blockSizeVertical * 5),
                      // Text("All Video Downloader",
                      //     style: TextStyle(
                      //         color: Colors.black,
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.bold)),
                      // Text("(Download Your favorite videos)",
                      //     style: TextStyle(
                      //         color: Colors.black,
                      //         fontSize: 12,
                      //         fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              // _nativeAd(),
              // Align(
              //     alignment: Alignment.topCenter,
              //     child: Container(
              //       margin:
              //           EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
              //       child: Container(
              //           width: SizeConfig.screenWidth,
              //           height: controller
              //               .googleAdsCT.myBannersplashScreen!.size.height
              //               .toDouble(),
              //           child: Center(
              //             child: AdWidget(
              //               ad: controller.googleAdsCT.myBannersplashScreen!,
              //             ),
              //           )),

              //       // ),
              //     )),
            ],
          ),
        ),
      ),
      // floatingActionButton: Obx(() => controller.isLoaded.value
      //     ? FloatingActionButton(
      //         backgroundColor: Color(0xFFF12073),
      //         onPressed: () {
      //           print("Is First Time: ${controller.isFirstTime}");
      //           // controller.appLovin_CTL.showInterAd();

      //           if (controller.isFirstTime!) {
      //             controller.setFirstTime(false);
      //             Get.offAndToNamed(Routes.HOW_TO_SCREEN);
      //           } else {
      //             Get.offAndToNamed(Routes.TabsScreenView);
      //           }
      //         },
      //         child: Icon(
      //           Icons.arrow_forward,
      //           color: Colors.white,
      //         ),
      //       )
      //     : Container()),
    );
  }
}
