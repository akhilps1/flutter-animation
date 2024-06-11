import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gsl_student_app/core/app_constants.dart';
import 'package:gsl_student_app/helper/local_storage.dart';
import 'package:gsl_student_app/modules/screens/university/controller/university_provider.dart';
import 'package:gsl_student_app/modules/screens/university/model/university_detail_model.dart';

import 'package:gsl_student_app/modules/screens/university/widgets/about_widget.dart';
import 'package:gsl_student_app/modules/screens/university/widgets/accommodation_w_idget.dart';
import 'package:gsl_student_app/modules/screens/university/widgets/brochures.dart';
import 'package:gsl_student_app/modules/screens/university/widgets/contact_info_widget.dart';
import 'package:gsl_student_app/modules/screens/university/widgets/course_offered.dart';

import 'package:gsl_student_app/modules/screens/university/widgets/facilities_widget.dart';

import 'package:gsl_student_app/modules/screens/university/widgets/icon_text_center.dart';

import 'package:gsl_student_app/modules/screens/university/widgets/images_widget.dart';
import 'package:gsl_student_app/modules/screens/university/widgets/media_widgets.dart';

import 'package:gsl_student_app/modules/screens/university/widgets/scholarship_details_widget.dart';

import 'package:gsl_student_app/modules/screens/university/widgets/university_affiliations.dart';
import 'package:gsl_student_app/modules/screens/university/widgets/university_ranking.dart';
import 'package:gsl_student_app/modules/screens/university/widgets/university_screen_tab_bar.dart';

import 'package:gsl_student_app/modules/screens/university/widgets/videos_widget.dart';
import 'package:gsl_student_app/utils/error_widget.dart';
import 'package:gsl_student_app/utils/url_launchers.dart';
import 'package:gsl_student_app/widgets/debouncer.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../theme/color_resources.dart';
import '../../../../theme/dimensions.dart';
import '../../../../theme/t_style.dart';
import '../../../../utils/dommy_data.dart';

import '../../../../widgets/custom_form_elements.dart';

List<String> universityTabTiles = [
  "About",
  "Contact info",
  "Courses Offered",
  "Facilities",
  "University Ranking",
  "University Affiliations",
  "Scholarship Details",
  "Brochures",
  "Accommodation",
  "Photos",
  "Videos",
];

class DetailUniversityScreen extends StatefulWidget {
  static const String path = "/detailed-University-screen";
  const DetailUniversityScreen({super.key, required this.id});
  final int id;

  @override
  State<DetailUniversityScreen> createState() => _DetailUniversityScreenState();
}

class _DetailUniversityScreenState extends State<DetailUniversityScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController =
      TabController(length: universityTabTiles.length, vsync: this);

  ScrollController? _scrollController;

  bool lastStatus = true;
  double height = 100;

  void _scrollListener() {
    if (_scrollController!.offset == kToolbarHeight) {}

    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController != null &&
        _scrollController!.hasClients &&
        _scrollController!.offset > (height - kToolbarHeight);
  }

  bool silverCollapsed = false;
  bool isCollap = false;
  bool isCollapsed = false;

  ScrollOffsetController scrollOffsetController = ScrollOffsetController();

  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  ItemScrollController itemScrollController = ItemScrollController();

  ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();

  void tabcontroll() {
    tabController.addListener(() {
      _scrollController?.animateTo(0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn);
      tabsScrollController.addListener(() {});

      tabsScrollController.animateTo(0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn);
      if (_scrollController?.position.userScrollDirection ==
          ScrollDirection.forward) {
        // print('down');
      } else if (_scrollController?.position.userScrollDirection ==
          ScrollDirection.reverse) {
        //  print('up');
      }
    });
  }

  DebouncerFunc debouncer =
      DebouncerFunc(delay: const Duration(milliseconds: 500));

  bool isInnerScrolled = true;

  @override
  void initState() {
    Provider.of<UniversityProvider>(context, listen: false)
        .univeristyDetailApi(widget.id);
    tabcontroll();
    _scrollController = ScrollController()..addListener(_scrollListener);
    _scrollController!.addListener(() {
      silverCollapsed = _scrollController!.offset >= kToolbarHeight;

      if (_scrollController!.offset > 200 &&
          !_scrollController!.position.outOfRange) {
        if (!silverCollapsed) {
          silverCollapsed = true;

          setState(() {});
        } else if (silverCollapsed) {
          silverCollapsed = true;

          setState(() {});
        }
      }
      itemPositionsListener.itemPositions.addListener(() {});
      final firstVisibleItemIndex =
          itemPositionsListener.itemPositions.value.first.index;
      // if (firstVisibleItemIndex != null) {

      tabController.animateTo(firstVisibleItemIndex,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });

    super.initState();
  }

  ScrollController tabsScrollController = ScrollController();

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Consumer<UniversityProvider>(builder: (context, controller, _) {
      return DefaultTabController(
        length: universityTabTiles.length,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: controller.universityDetailLoading
              ? const SpinKitCircle(
                  color: ColorResources.PRIMARY,
                  size: 25.0,
                )
              : (controller.errorMessage != null)
                  ? CommonWidgets.errorReload(
                      controller.errorMessage.toString(), callback: () {
                      Provider.of<UniversityProvider>(context, listen: false)
                          .univeristyDetailApi(widget.id);
                    })
                  : NestedScrollView(
                      controller: _scrollController,
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverLayoutBuilder(
                              builder: (BuildContext context, constraints) {
                            silverCollapsed =
                                _scrollController!.offset >= kToolbarHeight;

                            return SliverAppBar(
                                floating: false,
                                collapsedHeight: 120,
                                leading: CupertinoButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  padding: EdgeInsets.zero,
                                  child: SvgPicture.asset(
                                      Assets.icon.eventbackbutton.keyName),
                                ),
                                elevation: 0,
                                pinned: true,
                                expandedHeight: 480,
                                flexibleSpace: Container(
                                  padding: const EdgeInsets.only(bottom: 100),
                                  // Set a fixed height for the flexible space
                                  height:
                                      300, // Adjust this to your desired height
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          "https://glasgowconventionbureau.com/media/1298/shutterstock_644108704.jpg?center=0.55633802816901412,0.631578947368421&mode=crop&width=800&height=480&rnd=131540267720000000"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                bottom: PreferredSize(
                                    preferredSize: const Size.fromHeight(80),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        isShrink
                                            ? const SizedBox()
                                            : Stack(
                                                children: [
                                                  Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 75,
                                                        width: double.infinity,
                                                      ),
                                                      Container(
                                                        height: 70,
                                                        width: double.infinity,
                                                        color: Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                                  Positioned(
                                                      bottom: 0,
                                                      left: 0,
                                                      right: 0,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 5),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(18),
                                                          width: 130,
                                                          height: 130,
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .white,
                                                                  boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5),
                                                                  spreadRadius:
                                                                      2,
                                                                  blurRadius: 2,
                                                                  offset:
                                                                      const Offset(
                                                                          0, 2),
                                                                )
                                                              ]),
                                                          child: CachedNetworkImage(
                                                              imageUrl: DummyData()
                                                                  .universitythumnailList()[
                                                                      7]
                                                                  .logo!),
                                                        ),
                                                      ))
                                                ],
                                              ),
                                        Container(
                                          // height: 100,
                                          width: double.infinity,

                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(
                                                          isShrink ? 16 : 0))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                  controller
                                                          .universityDetailModel
                                                          ?.universityDetails
                                                          ?.universityName ??
                                                      "",
                                                  style: h4.black,
                                                ),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                Center(
                                                    child: IconTextCenter(
                                                        text: '${controller.universityDetailModel?.universityDetails?.universityState ?? ""}, ' +
                                                            extractCountry(controller
                                                                    .universityDetailModel
                                                                    ?.universityDetails
                                                                    ?.universityCountry ??
                                                                ""),
                                                        //'${controller.universityDetailModel?.universityDetails?.universityCity ?? ""}',
                                                        icon: Assets
                                                            .icon
                                                            .locationIconSuffix
                                                            .keyName)),
                                                isShrink
                                                    ? const SizedBox()
                                                    : const SizedBox(
                                                        height: 12,
                                                      ),
                                                isShrink
                                                    ? const SizedBox()
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          IconTextCenter(
                                                              text:
                                                                  'ESTD  ${extractYear(controller.universityDetailModel?.universityDetails?.universityEstablishedYear.toString() ?? "")}',
                                                              icon: Assets
                                                                  .icon
                                                                  .establishedIcon
                                                                  .keyName),
                                                          gapHorizontalLarge,
                                                          IconTextCenter(
                                                              text: toOrdinal(int
                                                                  .parse(controller
                                                                          .universityDetailModel
                                                                          ?.universityDetails
                                                                          ?.rank ??
                                                                      '')),
                                                              icon: Assets
                                                                  .icon
                                                                  .ranking
                                                                  .keyName),
                                                          gapHorizontalLarge,
                                                          Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                  Assets
                                                                      .icon
                                                                      .websiteIcon
                                                                      .keyName),
                                                              gapHorizontal,
                                                              SizedBox(
                                                                  // width: 100,
                                                                  child:
                                                                      CupertinoButton(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                minSize: 0,
                                                                onPressed: () {
                                                                  UrlLauncherWidget().launchURL(controller
                                                                          .universityDetailModel
                                                                          ?.universityDetails
                                                                          ?.websiteLink ??
                                                                      '');
                                                                },
                                                                child: Text(
                                                                  "Website",
                                                                  // controller
                                                                  //         .universityDetailModel
                                                                  //         ?.universityDetails
                                                                  //         ?.websiteLink ??
                                                                  //     '',
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .clip,
                                                                  style: body2
                                                                      .blackgrey,
                                                                ),
                                                              )),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //  gap,
                                        Container(
                                          width: double.infinity,
                                          color: Colors.white,
                                          child: UniversityScreenTabBar2(
                                            tabs: universityTabTiles,
                                            tabController: tabController,
                                          ),
                                        ),
                                      ],
                                    )),
                                actions: [
                                  CupertinoButton(
                                      pressedOpacity: 0.8,
                                      //color: Colors.grey,
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        debouncer.run(() {
                                          controller.universitySaveApi(
                                              controller.universityDetailModel
                                                      ?.universityDetails?.id
                                                      .toString() ??
                                                  "",
                                              // AppConstants.userId,
                                              LocalStorage.userData?.id ?? 0,
                                              !controller.universityLikeBool,
                                              () {});
                                          HapticFeedback.mediumImpact();
                                          setState(() {});
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        controller.universityLikeBool
                                            ? Assets.icon.savedIcon.keyName
                                            : Assets
                                                .icon.saveButtonIcon.keyName,
                                      )),
                                  CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () async {
                                        // void sharePressed(BuildContext context) async {
                                        await Share.share(
                                          'checkout this University : $unilink',
                                          subject: 'checkout this University',
                                        );
                                        //  }
                                      },
                                      child: SvgPicture.asset(
                                          Assets.icon.shareButtonIcon.keyName)),
                                ]);
                          }),
                        ];
                      },
                      body: SafeArea(
                        top: false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: PageStorage(
                            bucket: PageStorageBucket(),
                            child: TabBarView(
                              controller: tabController,
                              children: [
                                AboutWidget(
                                  controller: controller,
                                ),
                                ContactInfoWidget(
                                  controller: controller,
                                ),
                                const CourseOffered(),
                                FacilitiesWidget(
                                    universityFacility: controller
                                            .universityDetailModel
                                            ?.universityFacility ??
                                        []),
                                const UniversityRankingWidget(),
                                const UniversityAffiliations(),
                                const ScholarshipDetailsWidget(),
                                const BrochuresWidget(),
                                const AccommodationWIdget(),
                                ImagesBoxfitOld(
                                    images: controller
                                            .universityDetailModel
                                            ?.universityDetails
                                            ?.universityImages ??
                                        []),
                                ListView.builder(
                                  itemCount: controller
                                      .universityDetailModel
                                      ?.universityDetails
                                      ?.universityVideos
                                      ?.length,
                                  itemBuilder: (context, index) => VideosWidget(
                                      universityVideos: controller
                                              .universityDetailModel
                                              ?.universityDetails
                                              ?.universityVideos?[index] ??
                                          UniversityVideos()),
                                )
                                //  VideosWidget(),
                              ],
                            ),
                          ),
                        ),
                      )),
        ),
      );
    });
  }

  Widget myWidget() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 7,
          child: Container(
            color: Colors.green,
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.yellow,
          ),
        ),
      ],
    );
  }

  Column listingWidget(String title, String icon) {
    return Column(
      children: [
        customDivider(),
        Row(
          children: [
            SvgPicture.asset(icon),
            gapHorizontalLarge,
            Text(
              title,
              style: heading1.primary,
            ),
          ],
        ),
        gapLarge
      ],
    );
  }

  Widget textSmallWidth(Widget customwidget) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        // width: double.infinity,
        decoration: BoxDecoration(
            color: ColorResources.GREY5,
            borderRadius: BorderRadius.circular(57)),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: customwidget),
      ),
    );
  }
}

Widget textSmallWidth(Widget customwidget) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Container(
      // width: double.infinity,
      decoration: BoxDecoration(
          color: ColorResources.GREY5, borderRadius: BorderRadius.circular(57)),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: customwidget),
    ),
  );
}

// class SliverAppBarAnimation extends StatefulWidget {
//   @override
//   _SliverAppBarAnimationState createState() => _SliverAppBarAnimationState();
// }

// class _SliverAppBarAnimationState extends State<SliverAppBarAnimation> {
//   double circleTop = 100.0;
//   bool isExpanded = true;

//   double circleAvatarTopMargin = 60;

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 11,
//       child: Scaffold(
//         // backgroundColor: Colors.amber,
//         body: NestedScrollView(
//           headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//             var banner =
//                 'https://www.hindustantimes.com/ht-img/img/2023/06/29/1600x900/Supreme-Court-Affirmative-Action-0_1688058911335_1688058949030.jpg';
//             return <Widget>[
//               SliverAppBar(
//                 stretch: true,
//                 expandedHeight: 250.0,
//                 primary: true,
//                 pinned: true,
//                 backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//                 leading: CupertinoButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   padding: EdgeInsets.zero,
//                   child: SvgPicture.asset(Assets.icon.eventbackbutton.keyName),
//                 ),
//                 flexibleSpace: FlexibleSpaceBar(
//                   title: SafeArea(
//                     child: CircleAvatar(
//                       radius: 100 / 2,
//                       backgroundColor: Colors.white,
//                       child: Image.network(
//                         'https://1000logos.net/wp-content/uploads/2017/02/Harvard-Logo.png',
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                   ),
//                   centerTitle: true,
//                   background: Column(
//                     children: [
//                       Container(
//                         height: 220,
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                             image: NetworkImage(banner),
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         color: Colors.white,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ];
//           },
//           body: Column(
//             children: <Widget>[
//               Text(
//                 'University of Glasgow',
//                 style: h4.black,
//               ),
//               const SizedBox(
//                 height: 12,
//               ),
//               Center(
//                   child: IconTextCenter(
//                       text: 'Glasgow, Scotland',
//                       icon: Assets.icon.locationIconSuffix.keyName)),
//               const SizedBox(
//                 height: 12,
//               ),
//               Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                 IconTextCenter(
//                   icon: Assets.icon.establishedIcon.keyName,
//                   text: 'ESTD  1930',
//                 ),
//                 gapHorizontalLarge,
//                 IconTextCenter(
//                   icon: Assets.icon.ranking.keyName,
//                   text: '5',
//                 ),
//                 gapHorizontalLarge,
//                 Row(
//                   children: [
//                     SvgPicture.asset(Assets.icon.websiteIcon.keyName),
//                     gapHorizontal,
//                     SizedBox(
//                         width: 100,
//                         child: Text(
//                           'www.glasgowuniversity.com.co.in.uk',
//                           maxLines: 1,
//                           overflow: TextOverflow.clip,
//                           style: body2.blackgrey,
//                         )),
//                   ],
//                 ),
//               ]),
//               Container(
//                 child: TabBar(
//                   tabs: [
//                     Tab(text: 'Tab 1'),
//                     Tab(text: 'Tab 2'),
//                     Tab(text: 'Tab 2'),
//                     Tab(text: 'Tab 2'),
//                     Tab(text: 'Tab 2'),
//                     Tab(text: 'Tab 2'),
//                     Tab(text: 'Tab 2'),
//                     Tab(text: 'Tab 2'),
//                     Tab(text: 'Tab 2'),
//                     Tab(text: 'Tab 2'),
//                     Tab(text: 'Tab 2'),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: TabBarView(
//                   children: [
//                     AboutWidget(),
//                     ContactInfoWidget(),
//                     CourseOffered(),
//                     FacilitiesWidget(),
//                     UniversityRankingWidget(),
//                     UniversityAffiliations(),
//                     ScholarshipDetailsWidget(),
//                     BrochuresWidget(),
//                     AccommodationWIdget(),
//                     ImagesWidget(),
//                     VideosWidget(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _updateCirclePosition(double shrinkOffset) {
//     setState(() {
//       circleTop = 100 - shrinkOffset;
//       if (circleTop < 0) {
//         circleTop = 0;
//       }
//     });
//   }
// }

// class CircleHeaderDelegate extends SliverPersistentHeaderDelegate {
//   final double circleTop;

//   CircleHeaderDelegate(this.circleTop);

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Stack(
//       children: [
//         Positioned(
//           top: circleTop,
//           left: MediaQuery.of(context).size.width / 2 - 50,
//           child: Container(
//             width: 100,
//             height: 100,
//             decoration: BoxDecoration(
//               color: Colors.blue,
//               shape: BoxShape.circle,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   double get maxExtent => 100.0;

//   @override
//   double get minExtent => 0.0;

//   @override
//   bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
//     return false;
//   }
// }
