import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/horizontal_divider_widget.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/secondary_heading_text_with_background.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/section_comments.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/section_item_comments.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/section_item_details.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/template_subsections.dart';

class TemplateSections extends StatefulWidget {
  final InspectionModel inspection;
  final List<ImageShape> media;
  const TemplateSections(
      {Key? key, required this.inspection, required this.media})
      : super(key: key);
  @override
  State<TemplateSections> createState() => _TemplateSectionsState();
}

class _TemplateSectionsState extends State<TemplateSections> {
  List<bool> isExpanded = [];
  bool expandAllSections = false;
  InspectionModel inspection = InspectionModel();
  List<ImageShape>? media;

  @override
  void initState() {
    inspection = widget.inspection;
    media = widget.media;
    controllerStream.stream.listen((index) {
      setState(() {
        isExpanded[index] = true;
      });
    });
    isExpandedForAllSections();
    super.initState();
  }

  isExpandedForAllSections() {
    isExpanded = List<bool>.generate(
      inspection.template!.sections.length,
      (index) => true,
    );
  }

  void setAll(bool value, int sectionsLength) {
    setState(() {
      isExpanded = List<bool>.filled(sectionsLength, value);
    });
  }

  @override
  void dispose() {
    isExpanded.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //=========================== Expand All Section Button Start ===========================
        GestureDetector(
          onTap: () {
            //TODO: Expand all sections callback
            expandAllSections
                ? setAll(false, inspection.template!.sections.length)
                : setAll(true, inspection.template!.sections.length);
            setState(() {
              expandAllSections = !expandAllSections;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 26.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Expand all Sections",
                    style: primaryHeadingTextStyle.copyWith(
                        color: ProjectColors.pickledBluewood)),
                const SizedBox(width: 8),
                SvgPicture.asset(
                  "assets/svg/${expandAllSections ? "expand" : "unexpand"}.svg",
                  package: "pdf_report_scope",
                  width: 21,
                  height: 21,
                ),
              ],
            ),
          ),
        ),
        //=========================== Expand All Section Button End ===========================
        Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: ProjectColors.aliceBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ...List.generate(inspection.template!.sections.length,
                      (sectionIndex) {
                    if (itemKeys[
                            inspection.template!.sections[sectionIndex].uid] ==
                        null) {
                      itemKeys[inspection
                          .template!.sections[sectionIndex].uid!] = GlobalKey();
                    }
                    bool hasSectionItemComments = inspection
                        .template!.sections[sectionIndex].items
                        .any((item) => item.comments.isNotEmpty);
                    bool hasSectionImages = inspection
                        .template!.sections[sectionIndex].images.isNotEmpty;
                    bool hasSectionComments = inspection
                        .template!.sections[sectionIndex].comments.isNotEmpty;
                    bool hasSectionItems = inspection
                        .template!.sections[sectionIndex].items.isNotEmpty;
                    bool hasSubSections = inspection.template!
                        .sections[sectionIndex].subSections.isNotEmpty;
                    if (hasSectionItems ||
                        hasSectionComments ||
                        hasSectionImages ||
                        hasSectionItemComments) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isExpanded[sectionIndex] =
                                      !isExpanded[sectionIndex];
                                });
                              },
                              child: Container(
                                height: 37.0,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: ProjectColors.primary,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Center(
                                    child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        inspection.template!
                                            .sections[sectionIndex].name!
                                            .toUpperCase(),
                                        key: itemKeys[inspection.template!
                                            .sections[sectionIndex].uid],
                                        style: primaryHeadingTextStyle.copyWith(
                                            letterSpacing: 2,
                                            color: ProjectColors.white,
                                            fontFamily: fontFamilyJostMedium),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset(
                                        "assets/svg/${isExpanded[sectionIndex] ? "expand" : "unexpand"}.svg",
                                        package: "pdf_report_scope",
                                      ),
                                    )
                                  ],
                                )),
                              ),
                            ),
                            isExpanded[sectionIndex]
                                ? ListView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    children: [
                                      //=========================== Section Items Start ===========================
                                      hasSectionItems
                                          ? const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 14, bottom: 14),
                                              child:
                                                  SecondaryHeadingTextWithBackground(
                                                headingText: "Items Details",
                                                backgroundColor:
                                                    ProjectColors.firefly,
                                              ),
                                            )
                                          : const SizedBox(),
                                      SectionItemDetails(
                                        inspection: inspection,
                                        media: media!,
                                        sectionIndex: sectionIndex,
                                      ),
                                      //=========================== Section Items End ===========================
                                      //
                                      //
                                      //
                                      //
                                      //
                                      //=========================== Section Images Start ===========================
                                      hasSectionImages
                                          ? const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 19.0, bottom: 10),
                                              child: Text(
                                                "Section Images",
                                                style: b1Regular,
                                              ),
                                            )
                                          : const SizedBox(),
                                      SectionImages(
                                        inspection: inspection,
                                        media: media!,
                                        sectionIndex: sectionIndex,
                                      ),
                                      //=========================== Section Images End ===========================
                                      //
                                      //
                                      //
                                      //
                                      //
                                      //=========================== Section Comments Start ===========================
                                      hasSectionComments
                                          ? const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 8.0),
                                              child: HorizontalDividerWidget(
                                                color: ProjectColors.firefly,
                                              ),
                                            )
                                          : const SizedBox(),

                                      hasSectionComments
                                          ? const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 14, bottom: 14),
                                              child:
                                                  SecondaryHeadingTextWithBackground(
                                                headingText: "Section Comments",
                                                backgroundColor:
                                                    ProjectColors.pictonBlue,
                                              ),
                                            )
                                          : const SizedBox(),
                                      SectionComments(
                                        inspection: inspection,
                                        media: media!,
                                        sectionIndex: sectionIndex,
                                      ),
                                      //=========================== Section Comments End ===========================
                                      //
                                      //
                                      //
                                      //
                                      //
                                      //=========================== Section Item Comments Start ===========================
                                      hasSectionItemComments
                                          ? const HorizontalDividerWidget(
                                              color: ProjectColors.firefly)
                                          : const SizedBox(),
                                      hasSectionItemComments
                                          ? const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 14, bottom: 14),
                                              child:
                                                  SecondaryHeadingTextWithBackground(
                                                headingText:
                                                    "Section Item Comments",
                                                backgroundColor:
                                                    ProjectColors.pictonBlue,
                                              ),
                                            )
                                          : const SizedBox(),
                                      SectionItemComments(
                                        inspection: inspection,
                                        media: media!,
                                        sectionIndex: sectionIndex,
                                      ),
                                      hasSubSections
                                          ? const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 14.0, bottom: 14),
                                              child: HorizontalDividerWidget(
                                                  color: ProjectColors.firefly),
                                            )
                                          : const SizedBox(),
                                      TemplateSubSection(
                                        inspection: inspection,
                                        media: media!,
                                        sectionIndex: sectionIndex,
                                      )
                                      //=========================== Section Item Comments End ===========================
                                    ],
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  })
                ],
              ),
            )),
      ],
    );
  }
}

class SectionImages extends StatelessWidget {
  const SectionImages({
    Key? key,
    required this.inspection,
    required this.media,
    required this.sectionIndex,
  }) : super(key: key);

  final InspectionModel inspection;
  final List<ImageShape> media;
  final int sectionIndex;

  @override
  Widget build(BuildContext context) {
    return GeneralHelper.displayMediaList(
        inspection.template!.sections[sectionIndex].images,
        media,
        4,
        ImageType.sectionImage);
  }
}
