import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/data/models/enum_types.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/components/inspection_description.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/components/legend.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/components/report_header.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/components/report_summary.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/components/template_sections.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/section_eyeshot.dart';
import 'package:sizer/sizer.dart';
import 'widgets/general_widgets/section_tile_for_eyeshot.dart';

class InspectionReportScreen extends StatefulWidget {
  final Inspection inspection;
  final List<ImageShape> media;
  const InspectionReportScreen(
      {Key? key, required this.inspection, required this.media})
      : super(key: key);

  @override
  State<InspectionReportScreen> createState() => _InspectionReportScreenState();
}

class _InspectionReportScreenState extends State<InspectionReportScreen> {
  bool isLoading = false;
  List<bool> isExpanded = [];

  @override
  void initState() {
    isExpandedForAllSections();
    super.initState();
  }

  isExpandedForAllSections() {
    isExpanded = List<bool>.generate(
      widget.inspection.template!.sections.length,
      (index) => false,
    );
  }

  int numberOfDiffencyCommentsInSection(dynamic section) {
    int diffencyCount = 0;
    for (var comment in section.comments) {
      if (comment.type == CommentType.deficiency) {
        diffencyCount++;
      }
    }
    return diffencyCount;
  }

  @override
  void dispose() {
    isExpanded.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (SizerUtil.deviceType == DeviceType.mobile) {
        //Mobile
        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ReportHeader(
                      inspection: widget.inspection, media: widget.media),
                  InspectionDescription(inspection: widget.inspection),
                  ReportSummary(
                      inspection: widget.inspection, media: widget.media),
                  TemplateSections(
                      inspection: widget.inspection, media: widget.media)
                ],
              ),
            ),
          ),
        );
      } else if (SizerUtil.deviceType == DeviceType.tablet) {
        //tablet
        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ReportHeader(
                      inspection: widget.inspection, media: widget.media),
                  InspectionDescription(inspection: widget.inspection),
                  ReportSummary(
                      inspection: widget.inspection, media: widget.media),
                  TemplateSections(
                      inspection: widget.inspection, media: widget.media)
                ],
              ),
            ),
          ),
        );
      } else {
        if (constraints.maxWidth < 600) {
          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    ReportHeader(
                        inspection: widget.inspection, media: widget.media),
                    InspectionDescription(inspection: widget.inspection),
                    ReportSummary(
                        inspection: widget.inspection, media: widget.media),
                    TemplateSections(
                        inspection: widget.inspection, media: widget.media)
                  ],
                ),
              ),
            ),
          );
        }
        if (constraints.maxWidth < 1230) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  "Report Review",
                  style: h1.copyWith(color: ProjectColors.black),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SectionEyeShotForMobileAndTablet(
                                isWeb: false,
                                inspection: widget.inspection,
                                isExpanded: isExpanded);
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.menu,
                        color: ProjectColors.firefly,
                      ),
                      // child: SvgPicture.asset(
                      //   "assets/svg/menu.svg",
                      //   height: 24,
                      // ),
                    ),
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    ReportHeader(
                        inspection: widget.inspection, media: widget.media),
                    InspectionDescription(inspection: widget.inspection),
                    ReportSummary(
                        inspection: widget.inspection, media: widget.media),
                    TemplateSections(
                        inspection: widget.inspection, media: widget.media)
                  ],
                ),
              ),
            ),
          );
        } else {
          print("Cons:${constraints.maxWidth}");
          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Header logo Start
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SvgPicture.asset(
                        "lib/src/assets/svg/logo.svg",
                        width: 50,
                        height: 50,
                      ),
                    ),
                    //Header logo End
                    Divider(color: ProjectColors.firefly.withOpacity(0.15)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Container(
                                  width: width,
                                  decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                        color: ProjectColors.aliceBlue,
                                        spreadRadius: 7,
                                        blurRadius: 7,
                                        offset: Offset(0, 7),
                                      ),
                                    ],
                                    color: ProjectColors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Jump To Sections",
                                          style: b2Medium,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            children: [
                                              ...List.generate(
                                                widget.inspection.template!
                                                    .sections.length,
                                                (sectionIndex) {
                                                  final bool hasSubSections =
                                                      widget
                                                          .inspection
                                                          .template!
                                                          .sections[
                                                              sectionIndex]
                                                          .subSections
                                                          .isNotEmpty;
                                                  final section = widget
                                                      .inspection
                                                      .template!
                                                      .sections[sectionIndex];
                                                  return Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 30,
                                                            bottom: 30),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              isExpanded[
                                                                      sectionIndex] =
                                                                  isExpanded[
                                                                      sectionIndex];
                                                            });
                                                          },
                                                          child: Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  ProjectColors
                                                                      .white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                            child: SectionTile(
                                                              diffencyCount: numberOfDiffencyCommentsInSection(widget
                                                                      .inspection
                                                                      .template!
                                                                      .sections[
                                                                  sectionIndex]),
                                                              totalComments:
                                                                  section
                                                                      .comments
                                                                      .length,
                                                              isExpanded:
                                                                  isExpanded,
                                                              hasSubsections:
                                                                  hasSubSections,
                                                              section: section,
                                                              sectionIndex:
                                                                  sectionIndex,
                                                            ),
                                                          ),
                                                        ),
                                                        isExpanded[sectionIndex]
                                                            ? Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  section.subSections
                                                                          .isNotEmpty
                                                                      ? Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              top: 25.0,
                                                                              bottom: 12),
                                                                          child:
                                                                              Text(
                                                                            "Subsections of ${section.name}",
                                                                            style:
                                                                                b4Regular,
                                                                          ),
                                                                        )
                                                                      : const SizedBox(),
                                                                  MasonryGridView
                                                                      .count(
                                                                          physics:
                                                                              const NeverScrollableScrollPhysics(),
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemCount: section
                                                                              .subSections
                                                                              .length,
                                                                          crossAxisCount:
                                                                              1,
                                                                          itemBuilder:
                                                                              (context, subSectionIndex) {
                                                                            final subSection =
                                                                                widget.inspection.template!.sections[sectionIndex].subSections[subSectionIndex];
                                                                            return Padding(
                                                                              padding: const EdgeInsets.only(top: 13.0, bottom: 13.0),
                                                                              child: SectionTile(
                                                                                section: subSection,
                                                                                isExpanded: isExpanded,
                                                                                sectionIndex: sectionIndex,
                                                                                hasSubsections: false,
                                                                                totalComments: subSection.comments.length,
                                                                                diffencyCount: numberOfDiffencyCommentsInSection(subSection),
                                                                              ),
                                                                            );
                                                                          }),
                                                                ],
                                                              )
                                                            : const SizedBox(),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              ReportHeader(
                                  inspection: widget.inspection,
                                  media: widget.media),
                              isWeb ? const Legends() : const SizedBox(),
                              InspectionDescription(
                                  inspection: widget.inspection),
                              ReportSummary(
                                  inspection: widget.inspection,
                                  media: widget.media),
                              TemplateSections(
                                  inspection: widget.inspection,
                                  media: widget.media)
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }
    });
  }
}
