import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/data/models/enum_types.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/data/models/template_section.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/components/inspection_description.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/components/legend.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/components/report_header.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/components/report_summary.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/components/template_sections.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/section_eyeshot.dart';
import 'package:pdf_report_scope/src/utils/helpers/helper.dart';
import 'package:sizer/sizer.dart';

import 'widgets/general_widgets/section_tile_for_eyeshot.dart';

class InspectionReportScreen extends StatefulWidget {
  final InspectionModel inspection;
  final List<ImageShape> media;
  final bool showDialogue;
  const InspectionReportScreen(
      {Key? key,
      required this.inspection,
      required this.media,
      required this.showDialogue})
      : super(key: key);

  @override
  State<InspectionReportScreen> createState() => _InspectionReportScreenState();
}

class _InspectionReportScreenState extends State<InspectionReportScreen> {
  List<bool> isExpanded = [];
  late List<TemplateSection> sections = widget.inspection.template!.sections;

  @override
  void initState() {
    isExpandedForAllSections();
    super.initState();
  }

  _search(text) async {
    sections = await widget.inspection.template!.sections.filter(text);
    setState(() {});
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
            body: Stack(
              children: [
                SingleChildScrollView(
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
              ],
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
                        "assets/svg/logo.svg",
                        package: "pdf_report_scope",
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
                                          style: h1,
                                        ),
                                        const SizedBox(height: 18),
                                        TextField(
                                          onChanged: _search,
                                          decoration: InputDecoration(
                                            prefixIcon:
                                                const Icon(Icons.search),
                                            hintText: 'Search',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey[200],
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16.0),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            children: [
                                              ...List.generate(
                                                sections.length,
                                                (sectionIndex) {
                                                  final bool hasSubSections =
                                                      sections[sectionIndex]
                                                          .subSections
                                                          .isNotEmpty;
                                                  bool hasSectionComments =
                                                      sections[sectionIndex]
                                                          .comments
                                                          .isNotEmpty;
                                                  final section =
                                                      sections[sectionIndex];
                                                  bool hasSectionItemComments =
                                                      sections[sectionIndex]
                                                          .items
                                                          .any((item) => item
                                                              .comments
                                                              .isNotEmpty);
                                                  bool hasSectionImages =
                                                      sections[sectionIndex]
                                                          .images
                                                          .isNotEmpty;

                                                  bool hasSectionItems =
                                                      sections[sectionIndex]
                                                          .items
                                                          .isNotEmpty;

                                                  if (hasSectionItems ||
                                                      hasSectionComments ||
                                                      hasSectionImages ||
                                                      hasSectionItemComments) {
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
                                                            BorderRadius
                                                                .circular(10.0),
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
                                                                    !isExpanded[
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
                                                              child:
                                                                  SectionTile(
                                                                diffencyCount:
                                                                    numberOfDiffencyCommentsInSection(
                                                                        sections[
                                                                            sectionIndex]),
                                                                totalComments:
                                                                    section
                                                                        .comments
                                                                        .length,
                                                                isExpanded:
                                                                    isExpanded,
                                                                hasSubsections:
                                                                    hasSubSections,
                                                                section:
                                                                    section,
                                                                sectionIndex:
                                                                    sectionIndex,
                                                              ),
                                                            ),
                                                          ),
                                                          isExpanded[
                                                                  sectionIndex]
                                                              ? Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    section.subSections
                                                                            .isNotEmpty
                                                                        ? Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 25.0, bottom: 12),
                                                                            child:
                                                                                Text(
                                                                              "Subsections of ${section.name!}",
                                                                              style: b4Regular,
                                                                            ),
                                                                          )
                                                                        : const SizedBox(),
                                                                    MasonryGridView.count(
                                                                        physics: const NeverScrollableScrollPhysics(),
                                                                        shrinkWrap: true,
                                                                        itemCount: section.subSections.length,
                                                                        crossAxisCount: 1,
                                                                        itemBuilder: (context, subSectionIndex) {
                                                                          final subSection =
                                                                              sections[sectionIndex].subSections[subSectionIndex];
                                                                          return Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 13.0, bottom: 13.0),
                                                                            child:
                                                                                SectionTile(
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
                                                  } else {
                                                    return const SizedBox();
                                                  }
                                                },
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      // add your onPressed function here
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                            primary:
                                                                ProjectColors
                                                                    .firefly),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: const [
                                                          Icon(Icons.print),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text('Print',
                                                              style: b2Medium),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      // add your onPressed function here
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                            ),
                                                            primary:
                                                                ProjectColors
                                                                    .primary),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: const [
                                                          Icon(Icons
                                                              .cloud_download),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text('Download PDF',
                                                              style: b2Medium),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
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
