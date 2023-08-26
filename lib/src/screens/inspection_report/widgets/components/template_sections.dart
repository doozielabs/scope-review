import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/data/models/template.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/horizontal_divider_widget.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/secondary_heading_text_with_background.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/section_comments.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/section_item_comments.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/section_item_details.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/template_subsections.dart';
import 'package:pdf_report_scope/src/utils/helpers/helper.dart';

class TemplateSections extends StatefulWidget {
  final InspectionModel inspection;
  final List<ImageShape> media;
  final Template? selectedTemplate;
  const TemplateSections(
      {Key? key,
      required this.inspection,
      required this.media,
      this.selectedTemplate})
      : super(key: key);
  @override
  State<TemplateSections> createState() => _TemplateSectionsState();
}

class _TemplateSectionsState extends State<TemplateSections> {
  List<bool> isExpanded = [];
  bool expandAllSections = false;
  InspectionModel inspection = InspectionModel();
  late Template selectedTemplate = Template(); //widget.selectedTemplate!;
  List<ImageShape>? media;

  @override
  void initState() {
    inspection = widget.inspection;
    selectedTemplate = widget.selectedTemplate!;
    media = widget.media;
    controllerStream.stream.listen((index) {
      isExpanded[index] = true;
      setState(() {});
    });
    isExpandedForAllSections();
    super.initState();
  }

  isExpandedForAllSections() {
    isExpanded = List<bool>.generate(
      selectedTemplate.sections.length,
      (index) => false,
    );
  }

  void setAll(bool value, int sectionsLength) {
    setState(() {
      isExpanded = List<bool>.filled(sectionsLength, value);
    });
  }

  @override
  void didUpdateWidget(TemplateSections oldWidget) {
    inspection = widget.inspection;
    selectedTemplate = widget.selectedTemplate!;
    media = widget.media;
    if (selectedTemplate.sections.length != oldWidget.selectedTemplate!.sections.length) {
      isExpandedForAllSections();
    }
    super.didUpdateWidget(oldWidget);
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
                ? setAll(false, selectedTemplate.sections.length)
                : setAll(true, selectedTemplate.sections.length);
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
                  ...List.generate(selectedTemplate.sections.length,
                      (sectionIndex) {
                    bool hasSectionItemComments = selectedTemplate
                        .sections[sectionIndex].items
                        .any((item) => item.comments.isNotEmpty);
                    bool hasSectionItemImages = selectedTemplate
                        .sections[sectionIndex].items
                        .any((item) => item.images.isNotEmpty);
                    bool hasSectionImages = selectedTemplate
                        .sections[sectionIndex].images.isNotEmpty;
                    bool hasSectionComments = selectedTemplate
                        .sections[sectionIndex].comments.isNotEmpty;
                    bool hasSectionItems = false;
                    for (var item
                        in selectedTemplate.sections[sectionIndex].items) {
                      if (!item.unspecified ||
                          hasSectionItemComments ||
                          hasSectionItemImages) {
                        hasSectionItems = true;
                      }
                    }
                    bool hasSubSections = selectedTemplate
                        .sections[sectionIndex].subSections
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
                                        selectedTemplate
                                            .sections[sectionIndex].name!
                                            .toUpperCase(),
                                        key: itemKeys[selectedTemplate
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
                                        selectedTemplate: selectedTemplate,
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
                                        selectedTemplate: selectedTemplate,
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
                                        selectedTemplate: selectedTemplate,
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
                                        selectedTemplate: selectedTemplate,
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
                                          selectedTemplate: selectedTemplate)
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
    required this.selectedTemplate,
    required this.sectionIndex,
  }) : super(key: key);

  final InspectionModel inspection;
  final List<ImageShape> media;
  final Template selectedTemplate;
  final int sectionIndex;

  @override
  Widget build(BuildContext context) {
    return selectedTemplate.sections[sectionIndex].images.isNotEmpty
        ? GeneralHelper.displayMediaList(
            selectedTemplate.sections[sectionIndex].images,
            media,
            4,
            ImageType.sectionImage)
        : SizedBox.shrink();
  }
}
