import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/data/models/enum_types.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/data/models/template.dart';
import 'package:pdf_report_scope/src/data/models/template_section.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/multi_templates_selection.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/section_tile_for_eyeshot.dart';
import 'package:pdf_report_scope/src/utils/helpers/helper.dart';
import 'package:sizer/sizer.dart';

class SectionEyeShotForMobileAndTablet extends StatefulWidget {
  final InspectionModel inspection;
  final Function? sharePdf;
  final Function? printCallBack;
  final Function? downloadCallBack;
  final bool? isdownloading;
  final String? pdfStatus;
  final Template? selectedTemplate;
  final List<Template>? templates;
  final Function(int val)? switchServiceMethod;
  final Function? needUpgrade;
  const SectionEyeShotForMobileAndTablet(
      {Key? key,
      required this.inspection,
      this.templates,
      this.sharePdf,
      this.switchServiceMethod,
      this.printCallBack,
      this.downloadCallBack,
      this.isdownloading,
      this.pdfStatus,
      this.selectedTemplate,
      this.needUpgrade})
      : super(key: key);

  @override
  State<SectionEyeShotForMobileAndTablet> createState() =>
      _SectionEyeShotForMobileState();
}

class _SectionEyeShotForMobileState
    extends State<SectionEyeShotForMobileAndTablet> {
  Template? selectedTemplate = Template();
  late List<TemplateSection> sections = selectedTemplate!.sections;
  late List<TemplateSection> appendedSections = [];
  List<Template> templates = [];
  bool isdownloading = false;
  String pdfStatus = 'wait';

  void setSectionData() {
    appendedSections = [
      TemplateSection(name: "Information", uid: '00001'),
      TemplateSection(name: "Report Summary", uid: '00002'),
      ...selectedTemplate!.sections
    ];
  }

  List<bool> isExpanded = [];
  _search(text) async {
    setSectionData();
    isSearchValueChanged = true;
    appendedSections = await appendedSections.filter(text);
    setState(() {});
  }

  isExpandedForAllSections() {
    isExpanded = List<bool>.generate(
      appendedSections.length,
      (index) => false,
    );
  }

  List<int> numberOfDiffencyCommentsInSectionAndNumberOfTotalComments(
      dynamic section) {
    int diffencyCount = 0;
    int totalNumberOfSectionComments = 0;
    for (var item in section.items) {
      for (var itemComment in item.comments) {
        totalNumberOfSectionComments++;
        if (itemComment.type == CommentType.deficiency) {
          diffencyCount++;
        }
      }
    }
    for (var comment in section.comments) {
      totalNumberOfSectionComments++;
      if (comment.type == CommentType.deficiency) {
        diffencyCount++;
      }
    }
    return [diffencyCount, totalNumberOfSectionComments];
  }

  @override
  void initState() {
    templates = widget.templates ?? [];
    selectedTemplate = widget.selectedTemplate;
    setSectionData();
    setKeysForFilteredSection(sections);
    isExpandedForAllSections();
    super.initState();
  }

  Future<void> switchService(index) async {
    selectedTemplate = templates[index];
    widget.switchServiceMethod?.call(index);
    setState(() {
      sections = selectedTemplate!.sections;
      setSectionData();
      setKeysForFilteredSection(sections);
      isExpandedForAllSections();
    });
  }

  @override
  Widget build(BuildContext context) {
    pdfStatus = widget.pdfStatus!;
    isdownloading = widget.isdownloading ?? false;
    return Scaffold(
        backgroundColor: ProjectColors.white.withOpacity(0.9),
        appBar: AppBar(
          title: (kIsWeb && templates.length > 1)
              ? Text("Services and Sections",
                  style: h2.copyWith(color: ProjectColors.firefly))
              : Text("Jump to Section",
                  style: h2.copyWith(color: ProjectColors.firefly)),
          // ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset(
                    "assets/svg/close.svg",
                    package: "pdf_report_scope",
                  )),
            )
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    (kIsWeb && templates.length > 1)
                        ? MultiTemplatesSelection(
                            templates: templates,
                            selectedTemplate: selectedTemplate,
                            switchServiceMethod: switchService)
                        : const SizedBox(),
                    TextField(
                      onChanged: _search,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
                    // InkWell(
                    //   hoverColor: Colors.transparent,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(10.0),
                    //     child: Container(
                    //       padding: const EdgeInsets.only(
                    //           top: 10, bottom: 10, left: 10),
                    //       width: MediaQuery.of(context).size.width,
                    //       decoration: BoxDecoration(
                    //         color: ProjectColors.white,
                    //         borderRadius: BorderRadius.circular(10.0),
                    //       ),
                    //       child: Text(
                    //         "Report Summary",
                    //         style: primaryHeadingTextStyle.copyWith(
                    //           letterSpacing: 2,
                    //           color: ProjectColors.primary,
                    //           fontFamily: fontFamilyJostMedium,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    //   onTap: () {
                    //     if ((constraintMaxWidthForNavPop < 1230)) {
                    //       Navigator.pop(context);
                    //     }
                    //     summaryControllerStreamToExpand.add(1);
                    //     Future.delayed(const Duration(microseconds: 1), () {
                    //       Scrollable.ensureVisible(
                    //         inspectionSummaryKey.currentContext!,
                    //         duration: const Duration(milliseconds: 400),
                    //         curve: Curves.easeInOut,
                    //       );
                    //     });
                    //   },
                    // ),
                    // InkWell(
                    //   hoverColor: Colors.transparent,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(10.0),
                    //     child: Container(
                    //       padding: const EdgeInsets.only(
                    //           top: 10, bottom: 10, left: 10),
                    //       width: MediaQuery.of(context).size.width,
                    //       decoration: BoxDecoration(
                    //         color: ProjectColors.white,
                    //         borderRadius: BorderRadius.circular(10.0),
                    //       ),
                    //       child: Text(
                    //         "Report Summary",
                    //         style: primaryHeadingTextStyle.copyWith(
                    //           letterSpacing: 2,
                    //           color: ProjectColors.primary,
                    //           fontFamily: fontFamilyJostMedium,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    //   onTap: () {
                    //     if ((constraintMaxWidthForNavPop < 1230)) {
                    //       Navigator.pop(context);
                    //     }
                    //     summaryControllerStreamToExpand.add(1);
                    //     Future.delayed(const Duration(microseconds: 1), () {
                    //       Scrollable.ensureVisible(
                    //         inspectionSummaryKey.currentContext!,
                    //         duration: const Duration(milliseconds: 400),
                    //         curve: Curves.easeInOut,
                    //       );
                    //     });
                    //   },
                    // ),
                    ...List.generate(appendedSections.length, (sectionIndex) {
                      final section = appendedSections[sectionIndex];
                      bool hasSectionItemComments =
                          appendedSections[sectionIndex]
                              .items
                              .any((item) => item.comments.isNotEmpty);
                      bool hasSectionImages =
                          appendedSections[sectionIndex].images.isNotEmpty;
                      bool hasSectionComments =
                          appendedSections[sectionIndex].comments.isNotEmpty;
                      bool hasSectionItems = false;
                      for (var item in appendedSections[sectionIndex].items) {
                        if (!item.unspecified) {
                          hasSectionItems = true;
                        }
                      }
                      bool hasSubSections = appendedSections[sectionIndex]
                          .subSections
                          .any((subsection) => (subsection.items
                                  .any((item) => !item.unspecified) ||
                              subsection.comments.isNotEmpty ||
                              subsection.images.isNotEmpty));

                      if (hasSectionItems ||
                          hasSectionComments ||
                          hasSectionImages ||
                          hasSectionItemComments ||
                          hasSubSections ||
                          section.name == "Information" ||
                          section.name == "Report Summary") {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 10, right: 10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: ProjectColors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (isSearchValueChanged) {
                                      int currentSectionIndex = widget
                                          .selectedTemplate!.sections
                                          .indexWhere((currentSection) =>
                                              currentSection.uid ==
                                              section.uid);
                                      setState(() {
                                        controllerStream.add(sectionIndex);
                                        isExpanded[sectionIndex] =
                                            !isExpanded[sectionIndex];
                                        isSearchValueChanged = false;
                                      });
                                    } else {
                                      setState(() {
                                        controllerStream.add(sectionIndex);
                                        isExpanded[sectionIndex] =
                                            !isExpanded[sectionIndex];
                                        isSearchValueChanged = false;
                                      });
                                    }
                                  },
                                  child: SectionTile(
                                    diffencyCount:
                                        numberOfDiffencyCommentsInSectionAndNumberOfTotalComments(
                                            appendedSections[sectionIndex])[0],
                                    totalComments:
                                        numberOfDiffencyCommentsInSectionAndNumberOfTotalComments(
                                            appendedSections[sectionIndex])[1],
                                    isExpanded: isExpanded,
                                    hasSubsections: hasSubSections,
                                    section: section,
                                    sectionIndex: sectionIndex,
                                    inspection: widget.inspection,
                                    selectedTemplate: widget.selectedTemplate,
                                  ),
                                ),
                                isExpanded[sectionIndex]
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          section.subSections.isNotEmpty
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 25.0,
                                                          bottom: 12),
                                                  child: Text(
                                                    "Subsections of ${section.name!}",
                                                    style: b4Regular,
                                                  ),
                                                )
                                              : const SizedBox(),
                                          MasonryGridView.count(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount:
                                                  section.subSections.length,
                                              crossAxisCount: 1,
                                              itemBuilder:
                                                  (context, subSectionIndex) {
                                                final subSection =
                                                    appendedSections[
                                                                sectionIndex]
                                                            .subSections[
                                                        subSectionIndex];

                                                bool hasSubSectionItems = false;
                                                for (var item
                                                    in subSection.items) {
                                                  if (!item.unspecified) {
                                                    hasSubSectionItems = true;
                                                  }
                                                }
                                                bool hasSubSectionImages =
                                                    subSection
                                                        .images.isNotEmpty;
                                                bool hasSubSectionComments =
                                                    subSection
                                                        .comments.isNotEmpty;
                                                bool hasSectionItemComments =
                                                    subSection.items.any(
                                                        (item) => item.comments
                                                            .isNotEmpty);
                                                if (hasSubSectionItems ||
                                                    hasSubSectionImages ||
                                                    hasSubSectionComments ||
                                                    hasSectionItemComments) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 13.0,
                                                            bottom: 13.0),
                                                    child: SectionTile(
                                                      section: subSection,
                                                      isExpanded: isExpanded,
                                                      sectionIndex:
                                                          sectionIndex,
                                                      hasSubsections: false,
                                                      totalComments:
                                                          numberOfDiffencyCommentsInSectionAndNumberOfTotalComments(
                                                              subSection)[1],
                                                      diffencyCount:
                                                          numberOfDiffencyCommentsInSectionAndNumberOfTotalComments(
                                                              subSection)[0],
                                                      inspection:
                                                          widget.inspection,
                                                      selectedTemplate: widget
                                                          .selectedTemplate,
                                                    ),
                                                  );
                                                } else {
                                                  return const SizedBox
                                                      .shrink();
                                                }
                                              })
                                        ],
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }),
                    const SizedBox(height: 50)
                  ],
                ),
              ),
            ),
            !kIsWeb
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          // add your onPressed function here
                          if (widget.needUpgrade != null) {
                            await widget.needUpgrade!();
                          } else {
                            if (widget.sharePdf != null) {
                              widget.sharePdf!();
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor: ProjectColors.primary),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.share,
                                color: ProjectColors.white,
                              ),
                              const SizedBox(width: 10),
                              Text('Share PDF',
                                  style: b2Medium.copyWith(
                                      color: ProjectColors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 5, left: 10, right: 10),
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 0, left: 10, right: 10),
                        color: const Color.fromARGB(158, 233, 234, 231),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width / 2 -
                                  10.w),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (widget.printCallBack != null) {
                                    widget.printCallBack!();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    backgroundColor: ProjectColors.firefly),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.print),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      const Text('Print', style: b2Medium),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width / 2 -
                                  10.w),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (widget.downloadCallBack != null) {
                                    widget.downloadCallBack!();
                                  }
                                  // downloadFile(
                                  //     'https://api.scopeinspectapp.com/pdfs/inspections-${widget.inspection.id}.pdf');
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    backgroundColor: ProjectColors.primary),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      isdownloading
                                          ? const CupertinoActivityIndicator(
                                              color: ProjectColors.firefly)
                                          : const Icon(Icons.cloud_download),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      const Text('PDF', style: b2Medium),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
          ],
        ));

    // Dialog(
    //   // actionsAlignment: MainAxisAlignment.center,
    //   backgroundColor: ProjectColors.white.withOpacity(0.9),
    // actions: [
    //   ElevatedButton(
    //     onPressed: () {
    //       // add your onPressed function here
    //     },
    //     style: ElevatedButton.styleFrom(
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(10.0),
    //         ),
    //         primary: ProjectColors.primary),
    //     child: Padding(
    //       padding: const EdgeInsets.all(12.0),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           const Icon(
    //             Icons.share,
    //             color: ProjectColors.white,
    //           ),
    //           const SizedBox(width: 10),
    //           Text('Share PDF',
    //               style: b2Medium.copyWith(color: ProjectColors.white)),
    //         ],
    //       ),
    //     ),
    //   ),
    // ],
    // title: Stack(
    //   children: [
    //     const Center(
    //       child: Text("Jump to Section", style: h2),
    //     ),
    //     Positioned(
    //       right: 0,
    //       child: GestureDetector(
    //           onTap: () => Navigator.pop(context),
    //           child: SvgPicture.asset(
    //             "assets/svg/close.svg",
    //             package: "pdf_report_scope",
    //           )),
    //     ),
    //   ],
    // ),
    //   child: SizedBox(
    //     width: MediaQuery.of(context).size.width,
    //     child: ListView(
    //       children: [
    //         TextField(
    //           onChanged: _search,
    //           decoration: InputDecoration(
    //             prefixIcon: const Icon(Icons.search),
    //             hintText: 'Search',
    //             border: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(10.0),
    //               borderSide: BorderSide.none,
    //             ),
    //             filled: true,
    //             fillColor: Colors.grey[200],
    //             contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    //           ),
    //         ),
    //         ...List.generate(sections.length, (sectionIndex) {
    //           // final bool hasSubSections =
    //           //     sections[sectionIndex].subSections.isNotEmpty;
    //           final section = sections[sectionIndex];
    //           bool hasSectionItemComments = sections[sectionIndex]
    //               .items
    //               .any((item) => item.comments.isNotEmpty);
    //           bool hasSectionImages = sections[sectionIndex].images.isNotEmpty;
    //           bool hasSectionComments =
    //               sections[sectionIndex].comments.isNotEmpty;
    //           bool hasSectionItems = false;
    //           for (var item in sections[sectionIndex].items) {
    //             if (!item.unspecified) {
    //               hasSectionItems = true;
    //             }
    //           }
    //           bool hasSubSections = sections[sectionIndex].subSections.any(
    //               (subsection) =>
    //                   (subsection.items.any((item) => !item.unspecified) ||
    //                       subsection.comments.isNotEmpty ||
    //                       subsection.images.isNotEmpty));

    //           if (hasSectionItems ||
    //               hasSectionComments ||
    //               hasSectionImages ||
    //               hasSectionItemComments ||
    //               hasSubSections) {
    //             return Padding(
    //               padding: const EdgeInsets.all(10.0),
    //               child: Container(
    //                 padding: const EdgeInsets.only(
    //                     top: 10, bottom: 10, left: 10, right: 10),
    //                 width: MediaQuery.of(context).size.width,
    //                 decoration: BoxDecoration(
    //                   color: ProjectColors.white,
    //                   borderRadius: BorderRadius.circular(10.0),
    //                 ),
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     GestureDetector(
    //                       onTap: () {
    //                         setState(() {
    //                           controllerStream.add(sectionIndex);
    //                           isExpanded[sectionIndex] =
    //                               !isExpanded[sectionIndex];
    //                         });
    //                       },
    //                       child: SectionTile(
    //                         diffencyCount: numberOfDiffencyCommentsInSection(
    //                             sections[sectionIndex]),
    //                         totalComments: section.comments.length,
    //                         isExpanded: isExpanded,
    //                         hasSubsections: hasSubSections,
    //                         section: section,
    //                         sectionIndex: sectionIndex,
    //                       ),
    //                     ),
    //                     isExpanded[sectionIndex]
    //                         ? Column(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             children: [
    //                               section.subSections.isNotEmpty
    //                                   ? Padding(
    //                                       padding: const EdgeInsets.only(
    //                                           top: 25.0, bottom: 12),
    //                                       child: Text(
    //                                         "Subsections of ${section.name!}",
    //                                         style: b4Regular,
    //                                       ),
    //                                     )
    //                                   : const SizedBox(),
    //                               MasonryGridView.count(
    //                                   physics:
    //                                       const NeverScrollableScrollPhysics(),
    //                                   shrinkWrap: true,
    //                                   itemCount: section.subSections.length,
    //                                   crossAxisCount: 1,
    //                                   itemBuilder: (context, subSectionIndex) {
    //                                     final subSection =
    //                                         sections[sectionIndex]
    //                                             .subSections[subSectionIndex];
    //                                     return Padding(
    //                                       padding: const EdgeInsets.only(
    //                                           top: 13.0, bottom: 13.0),
    //                                       child: GestureDetector(
    //                                         onTap: () {
    //                                           print("SubSection Clicked");
    //                                         },
    //                                         child: SectionTile(
    //                                           section: subSection,
    //                                           isExpanded: isExpanded,
    //                                           sectionIndex: sectionIndex,
    //                                           hasSubsections: false,
    //                                           totalComments:
    //                                               subSection.comments.length,
    //                                           diffencyCount:
    //                                               numberOfDiffencyCommentsInSection(
    //                                                   subSection),
    //                                         ),
    //                                       ),
    //                                     );
    //                                   }),
    //                             ],
    //                           )
    //                         : const SizedBox(),
    //                   ],
    //                 ),
    //               ),
    //             );
    //           } else {
    //             return const SizedBox();
    //           }
    //         })
    //       ],
    //     ),
    //   ),
    // );
  }
}
