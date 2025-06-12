import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/size_config.dart';
import '../controllers/how_to_screen_controller.dart';

class HowToScreenView extends GetView<HowToScreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // backgroundColor: Color(0xFF1E1E1E),
        body: Container(
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 5),
          child: Column(
            children: [
              verticalSpace(SizeConfig.blockSizeVertical * 6),
              Container(
                child: Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        // Use the new navigation method with ad
                        controller.navigateToHomeWithAd();
                      },
                      child: Icon(
                        Icons.skip_next_rounded,
                        color: Colors.black,
                        size: SizeConfig.screenHeight * 0.05,
                      )
                      // Text(
                      //   "Skip",
                      //   style: TextStyle(
                      //       color: Colors.white,
                      //       fontSize: SizeConfig.blockSizeVertical * 3),
                      // )
                      ,
                    )
                  ],
                ),
              ),
              verticalSpace(SizeConfig.blockSizeVertical * 2),
              Container(
                height: SizeConfig.blockSizeVertical * 70,
                child: PageView(
                  controller: controller.pageController,
                  children: [
                    _screens_view("Discover Your Video",
                        "Paste a video URL or browse using the search bar to snag your next favorite clip."),
                    _screens_view("Ready, Set, Stream!",
                        "Jump right in and hit play to enjoy your video instantly. Once the action starts, the download button will light up like a magic trick. Just wait for it to unlock its power before grabbing your copy."),
                    _screens_view("Save Now, Watch Later! Tap Download.",
                        "Watch offline anytime! Download this video to your device with a tap."),
                    // _screens_view(AppImages.how_to_3, "View WhatsApp Status",
                    //     "View WhatsApp status to show them into downloader and then save them into gallery"),
                  ],
                  onPageChanged: (value) {
                    controller.currentPageNotifier.value = value;
                    controller.pageIndex.value = value;
                  },
                ),
              ),
              // Container(
              //     margin:
              //         EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 2),
              //     child:
              //     BannerMaxView(
              //       (AppLovinAdListener? event) =>
              //           print("Banner Add Event: $event"),
              //       BannerAdSize.banner,
              //       "60a8c3532e7256a9",
              //     )

              //     // ),
              //     ),
              _buildCircleIndicator(),
            ],
          ),
        ));
  }

  _buildCircleIndicator() {
    return Padding(
      padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
      child: CirclePageIndicator(
        selectedDotColor: Colors.black,
        dotColor: Colors.grey,
        itemCount: 3,
        currentPageNotifier: controller.currentPageNotifier,
      ),
    );
  }

  Container _screens_view(String title, String description) {
    return Container(
      child: Stack(
        children: [
          // Container(
          //   height: SizeConfig.blockSizeVertical * 50,
          //   decoration: BoxDecoration(color: Colors.greenAccent[100]),
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container(
              //   // color: Colors.white,
              //   width: SizeConfig.blockSizeHorizontal * 80,
              //   height: SizeConfig.blockSizeVertical * 50,
              //   child: ClipRRect(
              //       borderRadius: BorderRadius.circular(35),
              //       child: Image.asset(
              //         image,
              //       )),
              // ),
              // verticalSpace(SizeConfig.blockSizeVertical * 1),
              Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 28,
                      color: Color(0xFFF8005C),
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFFF8005C),
                      fontWeight: FontWeight.bold)),
              verticalSpace(SizeConfig.blockSizeVertical * 1),
              Text(description,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade900,
                      fontWeight: FontWeight.bold)),
              verticalSpace(SizeConfig.blockSizeVertical * 1),
              Obx(
                () => controller.pageIndex.value == 3
                    ? RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: 'Note: ',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      ' If the status is not showing, compleately close the app and open it again',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade200,
                                      fontWeight: FontWeight.bold))
                            ]),
                      )
                    // Text(
                    //     "Note: If the status is not showing, compleately close the app and open it again",
                    //     overflow: TextOverflow.clip,
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(
                    //         fontSize: 14,
                    //         color: Colors.grey.shade200,
                    //         fontWeight: FontWeight.bold))
                    : Container(),
              )
            ],
          ),
        ],
      ),
    );
  }
}
