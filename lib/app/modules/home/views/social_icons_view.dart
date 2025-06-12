import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:video_downloader_8/app/provider/admob_ads_provider.dart';
import 'package:video_downloader_8/app/utils/app_strings.dart';
import '../../../utils/CM.dart';
import '../../../utils/colors.dart';
import '../../../utils/size_config.dart';
import '../controllers/home_controller.dart';

class SocialIconsView extends GetView<HomeController> {
  SocialIconsView({super.key});

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

  // // // Native Ad Implementation start // // //

  //? Commented by jamal start
  NativeAd? nativeAd;
  RxBool nativeAdIsLoaded = false.obs;

  initNative() {
    nativeAd = NativeAd(
      adUnitId: AppStrings.ADMOB_NATIVE,
      request: AdRequest(),
      // factoryId: ,
      nativeTemplateStyle:
          NativeTemplateStyle(templateType: TemplateType.medium),
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          print('$NativeAd loaded.');

          nativeAdIsLoaded.value = true;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$NativeAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
      ),
    )..load();
  }
  //? Commented by jamal end

  /// Native Ad Implemntation End ///

  @override
  Widget build(BuildContext context) {
    initBanner(); //? Commented by jamal
    initNative(); //? Commented by jamal
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.themeColor,
        //  Theme.of(context).scaffoldBackgroundColor,
        titleTextStyle: TextStyle(
            color: AppColors.black,
            // color: Colors.white,
            fontSize: SizeConfig.blockSizeHorizontal * 6),
        title: Text(
          "All Video Downloader",
          style: TextStyle(
              color: Colors.grey.shade200,
              fontSize: SizeConfig.blockSizeHorizontal * 5,
              fontWeight: FontWeight.bold),
          // style: GoogleFonts.pacifico(),
        ),
        leading: GestureDetector(
            onTap: () {
              // Use ComFunction to show ad and navigate back
              controller.searchTextCTL.clear();
              ComFunction.navigateBackWithAd();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey.shade200,
            )),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //? Commented by jamal start
            Obx(() => isBannerLoaded.value &&
                    AdMobAdsProvider.instance.isAdEnable.value
                ? Container(
                    height: AdSize.banner.height.toDouble(),
                    child: AdWidget(ad: myBanner))
                : Container()),
            //? Commented by jamal end
            verticalSpace(SizeConfig.blockSizeVertical),
            verticalSpace(SizeConfig.blockSizeVertical * 5),
            _textInput(controller.searchTextCTL, "Paste your URL here",
                TextInputType.text, false),
            verticalSpace(SizeConfig.blockSizeVertical * 10),
            //? Commented by jamal start
            AdMobAdsProvider.instance.isAdEnable.value
                ? Center(
                    child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeHorizontal * 5),
                        child: NativeAdMethed(nativeAd, nativeAdIsLoaded)),
                  )
                : Container() //? Commented by jamal end
          ],
        ),
      ),
    );
  }

  Future<void> getClipboardData() async {
    try {
      var clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      String copiedLink = clipboardData?.text ??
          ''; // Provide a default value if clipboardData is null
      controller.searchTextCTL.text = copiedLink;
      print('Copied Link: $copiedLink');
    } on PlatformException catch (e) {
      print('Error getting clipboard data: $e');
    }
  }

  Widget _textInput(TextEditingController ctl, String hint,
      TextInputType inputType, isPassword) {
    return Center(
      child: Stack(
        children: [
          Column(
            children: [
              verticalSpace(SizeConfig.blockSizeVertical * 1),
              Container(
                height: SizeConfig.blockSizeVertical * 7,
                margin: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 5,
                    right: SizeConfig.blockSizeHorizontal * 5),
                // padding: EdgeInsets.symmetric(
                //     horizontal: SizeConfig.blockSizeHorizontal * 2),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange),

                  // borderRadius:
                  //     BorderRadius.circular(SizeConfig.blockSizeHorizontal * 5),
                  borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(SizeConfig.blockSizeHorizontal * 5),
                    bottomRight:
                        Radius.circular(SizeConfig.blockSizeHorizontal * 3),
                    topRight:
                        Radius.circular(SizeConfig.blockSizeHorizontal * 30),
                    bottomLeft:
                        Radius.circular(SizeConfig.blockSizeHorizontal * 5),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 1, // How far the shadow spreads
                      blurRadius: 2, // The blur radius for the shadow
                      offset: Offset(0, 3), // Offset of the shadow (x, y)
                    ),
                  ],
                ),
                child:
                    // horizontalSpace(SizeConfig.blockSizeHorizontal * 3),
                    TextFormField(
                  controller: ctl,
                  obscureText: isPassword,
                  keyboardType: inputType,
                  cursorColor: Colors.black,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 4,
                        top: SizeConfig.blockSizeVertical * 2),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: hint,
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Container(
                      margin: EdgeInsets.only(
                          right: SizeConfig.blockSizeHorizontal * 3),
                      height: SizeConfig.screenHeight,
                      width: SizeConfig.blockSizeHorizontal * 14,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          border: Border.all(color: Colors.amber),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              SizeConfig.blockSizeHorizontal * 3,
                            ),
                            bottomLeft: Radius.circular(
                                SizeConfig.blockSizeHorizontal * 3),
                            topRight: Radius.circular(
                                SizeConfig.blockSizeHorizontal * 15),
                            bottomRight: Radius.circular(
                                SizeConfig.blockSizeHorizontal * 3),
                          )
                          // borderRadius: BorderRadius.only(
                          //   topLeft: Radius.circular(
                          //       SizeConfig.blockSizeHorizontal * 5),
                          //   bottomRight: Radius.circular(
                          //       SizeConfig.blockSizeHorizontal * 5),
                          // )
                          ),
                      child: Icon(
                        Icons.content_paste_rounded,
                        color: Colors.white,
                      ),
                    ),
                    // suffixIcon: controller.isBrowsing.value
                    //     ? InkWell(
                    //         onTap: () {
                    //           controller.searchTextCTL.text = "";
                    //           controller.isBrowsing.value = false;
                    //           controller.videos.clear();
                    //         },
                    //         child: Icon(Icons.close),
                    //       )
                    //     : InkWell(
                    //         onTap: () {
                    //           String link = controller.searchTextCTL.text;

                    //           if (controller.selectedIndex.value == 0) {
                    //             print(
                    //                 "selectedIndex ${controller.selectedIndex.value}");
                    //             if (link.contains("facebook") ||
                    //                 link.contains("fb")) {
                    //               controller.callFacebookApi(link);
                    //               print("facebookApi");
                    //             } else {
                    //               ComFunction.showInfoDialog(
                    //                 title: "Invalid URL",
                    //                 msg: "Please enter Facebook URL",
                    //               );
                    //             }
                    //           } else if (controller.selectedIndex.value == 1) {
                    //             if (link.contains("l.likee")) {
                    //               controller.callLikeeApi(link);
                    //             } else {
                    //               ComFunction.showInfoDialog(
                    //                 title: "Invalid URL",
                    //                 msg: "Please enter Likee URL",
                    //               );
                    //             }
                    //           } else if (controller.selectedIndex.value == 2) {
                    //             if (link.contains("instagram")) {
                    //               controller.callInstagramApi(link);
                    //             } else {
                    //               ComFunction.showInfoDialog(
                    //                 title: "Invalid URL",
                    //                 msg: "Please enter Instagram URL",
                    //               );
                    //             }
                    //           } else if (controller.selectedIndex.value == 3) {
                    //             if (link.contains("tiktok")) {
                    //               controller.callTiktokApi(link);
                    //             } else {
                    //               ComFunction.showInfoDialog(
                    //                 title: "Invalid URL",
                    //                 msg: "Please enter TikTok URL",
                    //               );
                    //             }
                    //           } else if (controller.selectedIndex.value == 4) {
                    //             if (link.contains("pin")) {
                    //               controller.callPinterestApi(link);
                    //             } else {
                    //               ComFunction.showInfoDialog(
                    //                 title: "Invalid URL",
                    //                 msg: "Please enter Pinterest URL",
                    //               );
                    //             }
                    //           } else if (controller.selectedIndex.value == 5) {
                    //             if (link.contains("twitter")) {
                    //               controller.callTwitterApi(link);
                    //             } else {
                    //               ComFunction.showInfoDialog(
                    //                 title: "Invalid URL",
                    //                 msg: "Please enter Twitter URL",
                    //               );
                    //             }
                    //           } else if (controller.selectedIndex.value == 6) {
                    //             if (link.contains("vimeo.com")) {
                    //               controller.callVimeoApi(link);
                    //             } else {
                    //               ComFunction.showInfoDialog(
                    //                   title: "Invalid URL",
                    //                   msg: "Please Enter Vimeo URL");
                    //             }
                    //           } else if (controller.selectedIndex.value == 7) {
                    //             if (link.contains("facebook") ||
                    //                 link.contains("fb")) {
                    //               controller.callFacebookApi(link);
                    //             } else {
                    //               ComFunction.showInfoDialog(
                    //                 title: "Invalid URL",
                    //                 msg: "Please enter FB Watch URL",
                    //               );
                    //             }
                    //           }
                    //           controller.searchTextCTL.clear();
                    //         },
                    //         child: Icon(
                    //           Icons.search,
                    //           color: Colors.grey.shade600,
                    //         )),
                  ),
                ),
              ),
              verticalSpace(SizeConfig.blockSizeVertical * 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // GestureDetector(
                  //   onTap: () {
                  //     getClipboardData();
                  //   },
                  //   child: Container(
                  //     height: SizeConfig.blockSizeVertical * 5,
                  //     width: SizeConfig.blockSizeHorizontal * 40,
                  //     decoration: BoxDecoration(
                  //         color: Colors.grey.shade300,
                  //         borderRadius: BorderRadius.circular(
                  //             SizeConfig.blockSizeHorizontal * 2)),
                  //     child: Center(child: Text("Paste Link")),
                  //   ),
                  // ),
                  controller.isBrowsing.value
                      ? InkWell(
                          onTap: () {
                            controller.searchTextCTL.text = "";
                            controller.isBrowsing.value = false;
                            controller.videos.clear();
                          },
                          child: Icon(Icons.close),
                        )
                      : InkWell(
                          onTap: () {
                            String link = controller.searchTextCTL.text;

                            if (controller.selectedIndex.value == 0) {
                              print(
                                  "selectedIndex ${controller.selectedIndex.value}");
                              if (link.contains("facebook") ||
                                  link.contains("fb")) {
                                controller.callFacebookApi(link);
                                print("facebookApi");
                              } else {
                                ComFunction.showInfoDialog(
                                  title: "Invalid URL",
                                  msg: "Please enter Facebook URL",
                                );
                              }
                            } else if (controller.selectedIndex.value == 1) {
                              if (link.contains("l.likee")) {
                                controller.callLikeeApi(link);
                              } else {
                                ComFunction.showInfoDialog(
                                  title: "Invalid URL",
                                  msg: "Please enter Likee URL",
                                );
                              }
                            } else if (controller.selectedIndex.value == 2) {
                              if (link.contains("instagram")) {
                                controller.callInstagramApi(link);
                              } else {
                                ComFunction.showInfoDialog(
                                  title: "Invalid URL",
                                  msg: "Please enter Instagram URL",
                                );
                              }
                            } else if (controller.selectedIndex.value == 3) {
                              if (link.contains("tiktok")) {
                                controller.callTiktokApi(link);
                              } else {
                                ComFunction.showInfoDialog(
                                  title: "Invalid URL",
                                  msg: "Please enter TikTok URL",
                                );
                              }
                            } else if (controller.selectedIndex.value == 4) {
                              if (link.contains("pin")) {
                                controller.callPinterestApi(link);
                              } else {
                                ComFunction.showInfoDialog(
                                  title: "Invalid URL",
                                  msg: "Please enter Pinterest URL",
                                );
                              }
                            } else if (controller.selectedIndex.value == 5) {
                              if (link.contains("twitter")) {
                                controller.callTwitterApi(link);
                              } else {
                                ComFunction.showInfoDialog(
                                  title: "Invalid URL",
                                  msg: "Please enter Twitter URL",
                                );
                              }
                            } else if (controller.selectedIndex.value == 6) {
                              if (link.contains("vimeo.com")) {
                                controller.callVimeoApi(link);
                              } else {
                                ComFunction.showInfoDialog(
                                    title: "Invalid URL",
                                    msg: "Please Enter Vimeo URL");
                              }
                            } else if (controller.selectedIndex.value == 7) {
                              if (link.contains("snapchat") ||
                                  link.contains("fb")) {
                                controller.callSnapchatApi(link);
                              } else {
                                ComFunction.showInfoDialog(
                                  title: "Invalid URL",
                                  msg: "Please enter Snapchat URL",
                                );
                              }
                            }
                            controller.searchTextCTL.clear();
                          },
                          child: Container(
                            height: SizeConfig.blockSizeVertical * 6,
                            width: SizeConfig.blockSizeHorizontal * 45,
                            decoration: BoxDecoration(
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
                                gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 255, 105, 46),
                                      Color(0xFFFE2C3B),
                                      // Color(0xFFF8005C),
                                      // Color(0xFFD02F3F),
                                      // Color(0xFFEB443E)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter),
                                // borderRadius: BorderRadius.circular(
                                //     SizeConfig.blockSizeHorizontal * 5)
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                      SizeConfig.blockSizeHorizontal * 3),
                                  bottomRight: Radius.circular(
                                      SizeConfig.blockSizeHorizontal * 2),
                                  topRight: Radius.circular(
                                      SizeConfig.blockSizeHorizontal * 10),
                                  bottomLeft: Radius.circular(
                                      SizeConfig.blockSizeHorizontal * 3),
                                )),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: SizeConfig.blockSizeHorizontal * 2),
                                  child: Icon(
                                    Icons.download,
                                    color: Colors.white,
                                    size: SizeConfig.blockSizeHorizontal * 7,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: SizeConfig.blockSizeHorizontal * 5),
                                  child: Text(
                                    "Download",
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal * 4,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          )),
                ],
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     GestureDetector(
              //       onTap: () {
              //         getClipboardData();
              //       },
              //       child: Container(
              //         height: SizeConfig.blockSizeVertical * 5,
              //         width: SizeConfig.blockSizeHorizontal * 40,
              //         decoration: BoxDecoration(
              //             color: Colors.grey.shade300,
              //             borderRadius: BorderRadius.circular(
              //                 SizeConfig.blockSizeHorizontal * 2)),
              //         child: Center(child: Text("Paste Link")),
              //       ),
              //     ),
              //     controller.isBrowsing.value
              //         ? InkWell(
              //             onTap: () {
              //               controller.searchTextCTL.text = "";
              //               controller.isBrowsing.value = false;
              //               controller.videos.clear();
              //             },
              //             child: Icon(Icons.close),
              //           )
              //         : InkWell(
              //             onTap: () {
              //               String link = controller.searchTextCTL.text;

              //               if (link.contains("youtube") ||
              //                   link.contains("google") ||
              //                   link.contains("googlevideo") ||
              //                   link.contains("youtu.be") ||
              //                   link.contains("ytimg")) {
              //                 ComFunction.showInfoDialog(
              //                   title: "Invalid URL",
              //                   msg: "Please enter a valid URL",
              //                 );
              //               } else {
              //                 if (link.contains("tiktok")) {
              //                   controller.callTiktokApi(link);
              //                   // controller.searchTextCTL.text = link;
              //                   // controller.isBrowsing.value = true;
              //                 } else {
              //                   if (link.contains("facebook") ||
              //                       link.contains("fb")) {
              //                     controller.searchTextCTL.text = link;
              //                     controller.isBrowsing.value = true;
              //                     // controller.callFacebookApi(link);
              //                   } else {
              //                     if (link.contains("instagram")) {
              //                       controller.searchTextCTL.text = link;
              //                       controller.isBrowsing.value = true;
              //                       // controller.callInstagramApi(link);
              //                     } else {
              //                       if (link.contains("pin")) {
              //                         controller.callPinterestApi(link);
              //                         // controller.searchTextCTL.text = link;
              //                         // controller.isBrowsing.value = true;
              //                       } else {
              //                         if (link.contains("l.likee")) {
              //                           // controller.searchTextCTL.text = link;
              //                           // controller.isBrowsing.value = true;
              //                           controller.callLikeeApi(link);
              //                         } else {
              //                           if (link.contains("x.com")) {
              //                             controller.callTwitterApi(link);
              //                           } else {
              //                             if (link.contains("vimeo.com")) {
              //                               controller.callVimeoApi(link);
              //                             }
              //                           }
              //                         }
              //                       }
              //                     }
              //                   }
              //                 }
              //               }
              //               // controller.searchTextCTL.clear();
              //             },
              //             child: Container(
              //               height: SizeConfig.blockSizeVertical * 5,
              //               width: SizeConfig.blockSizeHorizontal * 40,
              //               decoration: BoxDecoration(
              //                   color: Colors.green,
              //                   borderRadius: BorderRadius.circular(
              //                       SizeConfig.blockSizeHorizontal * 2)),
              //               child: Center(
              //                   child: Text(
              //                 "Download",
              //                 style: TextStyle(color: Colors.white),
              //               )),
              //             )),
              //   ],
              // ),

              // SizedBox(
              //     height:
              //         16), // Add some space between the TextFormField and the button
            ],
          ),
        ],
      ),
    );
  }
}
