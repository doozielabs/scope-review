import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/data/models/enum_types.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/data/models/template_section.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/section_tile_for_eyeshot.dart';
import 'package:pdf_report_scope/src/utils/helpers/helper.dart';

class SectionEyeShotForMobileAndTablet extends StatefulWidget {
  final InspectionModel inspection;
  const SectionEyeShotForMobileAndTablet({
    Key? key,
    required this.inspection,
  }) : super(key: key);

  @override
  State<SectionEyeShotForMobileAndTablet> createState() =>
      _SectionEyeShotForMobileState();
}

class _SectionEyeShotForMobileState
    extends State<SectionEyeShotForMobileAndTablet> {
  late List<TemplateSection> sections = widget.inspection.template!.sections;
  List<bool> isExpanded = [];
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
  void initState() {
    // TODO: implement initState
    isExpandedForAllSections();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ProjectColors.white.withOpacity(0.9),
        appBar: AppBar(
          title: Text("Jump to Section",
              style: h2.copyWith(color: ProjectColors.firefly)),
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
                    ...List.generate(sections.length, (sectionIndex) {
                      // final bool hasSubSections =
                      //     sections[sectionIndex].subSections.isNotEmpty;
                      final section = sections[sectionIndex];
                      bool hasSectionItemComments = sections[sectionIndex]
                          .items
                          .any((item) => item.comments.isNotEmpty);
                      bool hasSectionImages =
                          sections[sectionIndex].images.isNotEmpty;
                      bool hasSectionComments =
                          sections[sectionIndex].comments.isNotEmpty;
                      bool hasSectionItems = false;
                      for (var item in sections[sectionIndex].items) {
                        if (!item.unspecified) {
                          hasSectionItems = true;
                        }
                      }
                      bool hasSubSections = sections[sectionIndex]
                          .subSections
                          .any((subsection) => (subsection.items
                                  .any((item) => !item.unspecified) ||
                              subsection.comments.isNotEmpty ||
                              subsection.images.isNotEmpty));

                      if (hasSectionItems ||
                          hasSectionComments ||
                          hasSectionImages ||
                          hasSectionItemComments ||
                          hasSubSections) {
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
                                    setState(() {
                                      controllerStream.add(sectionIndex);
                                      isExpanded[sectionIndex] =
                                          !isExpanded[sectionIndex];
                                    });
                                  },
                                  child: SectionTile(
                                    diffencyCount:
                                        numberOfDiffencyCommentsInSection(
                                            sections[sectionIndex]),
                                    totalComments: section.comments.length,
                                    isExpanded: isExpanded,
                                    hasSubsections: hasSubSections,
                                    section: section,
                                    sectionIndex: sectionIndex,
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
                                                    sections[sectionIndex]
                                                            .subSections[
                                                        subSectionIndex];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 13.0,
                                                          bottom: 13.0),
                                                  child: SectionTile(
                                                    section: subSection,
                                                    isExpanded: isExpanded,
                                                    sectionIndex: sectionIndex,
                                                    hasSubsections: false,
                                                    totalComments: subSection
                                                        .comments.length,
                                                    diffencyCount:
                                                        numberOfDiffencyCommentsInSection(
                                                            subSection),
                                                  ),
                                                );
                                              }),
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
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // add your onPressed function here
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      primary: ProjectColors.primary),
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
                            style:
                                b2Medium.copyWith(color: ProjectColors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
