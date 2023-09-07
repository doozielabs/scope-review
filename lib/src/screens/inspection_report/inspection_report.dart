import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/data/models/enum_types.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/data/models/template.dart';
import 'package:pdf_report_scope/src/data/models/template_section.dart';
import 'package:pdf_report_scope/src/data/models/user_model.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/components/inspection_description.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/components/legend.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/components/report_header.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/components/report_summary.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/components/template_sections.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/multi_templates_selection.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/section_eyeshot.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';
import 'package:pdf_report_scope/src/utils/helpers/helper.dart';
import 'package:sizer/sizer.dart';

import 'widgets/general_widgets/section_tile_for_eyeshot.dart';

class InspectionReportScreen extends StatefulWidget {
  final InspectionModel inspection;
  final List<ImageShape> media;
  final List<Template> templates;
  final Template? selectedTemplate;
  final bool showDialogue;
  final bool? isdownloading;
  final Function? printCallBack;
  final Function? mediaCallBack;
  final Function? downloadCallBack;
  final Function? sharePdf;
  final User user;
  const InspectionReportScreen({
    Key? key,
    required this.inspection,
    required this.media,
    required this.templates,
    required this.showDialogue,
    this.printCallBack,
    this.isdownloading,
    this.mediaCallBack,
    this.downloadCallBack,
    this.sharePdf,
    required this.user,
    this.selectedTemplate,
  }) : super(key: key);

  @override
  State<InspectionReportScreen> createState() => _InspectionReportScreenState();
}

class _InspectionReportScreenState extends State<InspectionReportScreen> {
  bool isLoading = false;
  List<bool> isExpanded = [];
  List<Template> templates = [];
  Template selectedTemplate = Template();
  bool isdownloading = false;
  late List<TemplateSection> sections = selectedTemplate.sections;

  late List<TemplateSection> appendedSections = [];
  Stream stream = constraintStream.stream;
  bool _showBackToTopButton = false;
  late ScrollController _scrollController;

  void setSectionData() {
    appendedSections = [
      TemplateSection(name: "Information", uid: '00001'),
      TemplateSection(name: "Report Summary", uid: '00002'),
      ...selectedTemplate.sections
    ];
  }

  @override
  void initState() {
    templates = widget.templates;
    if (templates.isNotEmpty) {
      selectedTemplate = widget.selectedTemplate ?? templates.first;
    }
    setSectionData();
    isExpandedForAllSections();
    setKeysForFilteredSection(sections);
    setTrailItem();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset >= 400) {
          _showBackToTopButton = true;
        } else {
          _showBackToTopButton = false;
        }
        setState(() {});
      });

    stream.listen((index) {
      constraintMaxWidthForNavPop = index;
    });
    setState(() {});
    super.initState();
  }

  _search(text) async {
    setSectionData();
    isSearchValueChanged = true;
    appendedSections = await appendedSections.filter(text);
    setState(() {});
  }

  setTrailItem() async {
    selectedTemplate = GeneralHelper.setTrailItem(templates, selectedTemplate);
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
  void dispose() {
    isExpanded.clear();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(microseconds: 1), curve: Curves.linear);
  }

  Future<void> switchService(index) async {
    selectedTemplate = templates[index];
    widget.mediaCallBack?.call(index);
    setState(() {
      setTrailItem();
      sections = selectedTemplate.sections;
      setSectionData();
      isExpandedForAllSections();
      setKeysForFilteredSection(sections);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isdownloading = widget.isdownloading ?? false;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      constraintStream.add(constraints.maxWidth);
      globalConstraints = constraints;
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
                          key: inspectionInfoKey,
                          inspection: widget.inspection,
                          media: widget.media,
                          user: widget.user,
                          selectedTemplate: selectedTemplate),
                      const Legends(),
                      InspectionDescription(
                          inspection: widget.inspection,
                          selectedTemplate: selectedTemplate),
                      ReportSummary(
                          key: inspectionSummaryKey,
                          inspection: widget.inspection,
                          media: widget.media,
                          selectedTemplate: selectedTemplate),
                      TemplateSections(
                          inspection: widget.inspection,
                          media: widget.media,
                          selectedTemplate: selectedTemplate)
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
                      key: inspectionInfoKey,
                      inspection: widget.inspection,
                      media: widget.media,
                      user: widget.user,
                      selectedTemplate: selectedTemplate),
                  const Legends(),
                  InspectionDescription(
                      inspection: widget.inspection,
                      selectedTemplate: selectedTemplate),
                  ReportSummary(
                      key: inspectionSummaryKey,
                      inspection: widget.inspection,
                      media: widget.media,
                      selectedTemplate: selectedTemplate),
                  TemplateSections(
                      inspection: widget.inspection,
                      media: widget.media,
                      selectedTemplate: selectedTemplate)
                ],
              ),
            ),
          ),
        );
      } else {
        if (constraints.maxWidth < 600) {
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
                  InkWell(
                    onTap: () async {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return SectionEyeShotForMobileAndTablet(
                                inspection: widget.inspection,
                                sharePdf: widget.sharePdf,
                                printCallBack: widget.printCallBack,
                                downloadCallBack: widget.downloadCallBack,
                                isdownloading: isdownloading,
                                selectedTemplate: selectedTemplate,
                                templates: templates,
                                switchServiceMethod: switchService);
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: SvgPicture.asset(
                        "assets/svg/menu.svg",
                        package: "pdf_report_scope",
                      ),
                    ),
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    ReportHeader(
                        key: inspectionInfoKey,
                        inspection: widget.inspection,
                        media: widget.media,
                        user: widget.user,
                        selectedTemplate: selectedTemplate),
                    const Legends(),
                    InspectionDescription(
                        inspection: widget.inspection,
                        selectedTemplate: selectedTemplate),
                    ReportSummary(
                        key: inspectionSummaryKey,
                        inspection: widget.inspection,
                        media: widget.media,
                        selectedTemplate: selectedTemplate),
                    TemplateSections(
                        inspection: widget.inspection,
                        media: widget.media,
                        selectedTemplate: selectedTemplate)
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
                  InkWell(
                    onTap: () async {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return SectionEyeShotForMobileAndTablet(
                                inspection: widget.inspection,
                                sharePdf: widget.sharePdf,
                                printCallBack: widget.printCallBack,
                                downloadCallBack: widget.downloadCallBack,
                                isdownloading: isdownloading,
                                selectedTemplate: selectedTemplate,
                                templates: templates,
                                switchServiceMethod: switchService);
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: SvgPicture.asset(
                        "assets/svg/menu.svg",
                        package: "pdf_report_scope",
                      ),
                    ),
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    ReportHeader(
                        key: inspectionInfoKey,
                        inspection: widget.inspection,
                        media: widget.media,
                        user: widget.user,
                        selectedTemplate: selectedTemplate),
                    const Legends(),
                    InspectionDescription(
                        inspection: widget.inspection,
                        selectedTemplate: selectedTemplate),
                    ReportSummary(
                        key: inspectionSummaryKey,
                        inspection: widget.inspection,
                        media: widget.media,
                        selectedTemplate: selectedTemplate),
                    TemplateSections(
                        inspection: widget.inspection,
                        media: widget.media,
                        selectedTemplate: selectedTemplate)
                  ],
                ),
              ),
            ),
          );
        } else {
          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                controller: _scrollController,
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
                                (kIsWeb && templates.length > 1)
                                    ? MultiTemplatesSelection(
                                        templates: templates,
                                        selectedTemplate: selectedTemplate,
                                        switchServiceMethod: switchService)
                                    : const SizedBox(),
                                Container(
                                  width: MediaQuery.of(context).size.width,
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
                                        // InkWell(
                                        //   hoverColor: Colors.transparent,
                                        //   child: Padding(
                                        //     padding: const EdgeInsets.all(10.0),
                                        //     child: Container(
                                        //       padding: const EdgeInsets.only(
                                        //           top: 10,
                                        //           bottom: 10,
                                        //           left: 10),
                                        //       width: MediaQuery.of(context)
                                        //           .size
                                        //           .width,
                                        //       decoration: BoxDecoration(
                                        //         color: ProjectColors.white,
                                        //         borderRadius:
                                        //             BorderRadius.circular(10.0),
                                        //       ),
                                        //       child: Text(
                                        //         "Information",
                                        //         style: primaryHeadingTextStyle
                                        //             .copyWith(
                                        //           letterSpacing: 2,
                                        //           color: ProjectColors.primary,
                                        //           fontFamily:
                                        //               fontFamilyJostMedium,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),
                                        //   onTap: () {
                                        //     if ((constraintMaxWidthForNavPop <
                                        //         1230)) {
                                        //       Navigator.pop(context);
                                        //     }
                                        //     Future.delayed(
                                        //         const Duration(microseconds: 2),
                                        //         () {
                                        //       Scrollable.ensureVisible(
                                        //         inspectionInfoKey!
                                        //             .currentContext!,
                                        //         duration: const Duration(
                                        //             milliseconds: 300),
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
                                        //           top: 10,
                                        //           bottom: 10,
                                        //           left: 10),
                                        //       width: MediaQuery.of(context)
                                        //           .size
                                        //           .width,
                                        //       decoration: BoxDecoration(
                                        //         color: ProjectColors.white,
                                        //         borderRadius:
                                        //             BorderRadius.circular(10.0),
                                        //       ),
                                        //       child: Text(
                                        //         "Report Summary",
                                        //         style: primaryHeadingTextStyle
                                        //             .copyWith(
                                        //           letterSpacing: 2,
                                        //           color: ProjectColors.primary,
                                        //           fontFamily:
                                        //               fontFamilyJostMedium,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),
                                        //   onTap: () {
                                        //     if ((constraintMaxWidthForNavPop <
                                        //         1230)) {
                                        //       Navigator.pop(context);
                                        //     }
                                        //     summaryControllerStreamToExpand
                                        //         .add(1);
                                        //     Future.delayed(
                                        //         const Duration(microseconds: 2),
                                        //         () {
                                        //       Scrollable.ensureVisible(
                                        //         inspectionSummaryKey!
                                        //             .currentContext!,
                                        //         duration: const Duration(
                                        //             milliseconds: 300),
                                        //         curve: Curves.easeInOut,
                                        //       );
                                        //     });
                                        //   },
                                        // ),
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            children: [
                                              ...List.generate(
                                                appendedSections.length,
                                                (sectionIndex) {
                                                  final section =
                                                      appendedSections[
                                                          sectionIndex];
                                                  bool hasSectionItemComments =
                                                      appendedSections[
                                                              sectionIndex]
                                                          .items
                                                          .any((item) => item
                                                              .comments
                                                              .isNotEmpty);
                                                  bool hasSectionImages =
                                                      appendedSections[
                                                              sectionIndex]
                                                          .images
                                                          .isNotEmpty;
                                                  bool hasSectionComments =
                                                      appendedSections[
                                                              sectionIndex]
                                                          .comments
                                                          .isNotEmpty;
                                                  bool hasSectionItems = false;
                                                  for (var item
                                                      in appendedSections[
                                                              sectionIndex]
                                                          .items) {
                                                    if (!item.unspecified) {
                                                      hasSectionItems = true;
                                                    }
                                                  }
                                                  bool hasSubSections = appendedSections[
                                                          sectionIndex]
                                                      .subSections
                                                      .any((subsection) =>
                                                          (subsection.items.any(
                                                                  (item) => !item
                                                                      .unspecified) ||
                                                              subsection
                                                                  .comments
                                                                  .isNotEmpty ||
                                                              subsection.images
                                                                  .isNotEmpty));

                                                  if (hasSectionItems ||
                                                      hasSectionComments ||
                                                      hasSectionImages ||
                                                      hasSectionItemComments ||
                                                      hasSubSections ||
                                                      section.name ==
                                                          "Information" ||
                                                      section.name ==
                                                          "Report Summary") {
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
                                                                    numberOfDiffencyCommentsInSectionAndNumberOfTotalComments(
                                                                        appendedSections[
                                                                            sectionIndex])[0],
                                                                totalComments:
                                                                    numberOfDiffencyCommentsInSectionAndNumberOfTotalComments(
                                                                        appendedSections[
                                                                            sectionIndex])[1],
                                                                isExpanded:
                                                                    isExpanded,
                                                                hasSubsections:
                                                                    hasSubSections,
                                                                section:
                                                                    section,
                                                                sectionIndex:
                                                                    sectionIndex,
                                                                inspection: widget
                                                                    .inspection,
                                                                selectedTemplate:
                                                                    selectedTemplate,
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
                                                                              appendedSections[sectionIndex].subSections[subSectionIndex];

                                                                          bool
                                                                              hasSubSectionItems =
                                                                              false;
                                                                          for (var item
                                                                              in subSection.items) {
                                                                            if (!item.unspecified) {
                                                                              hasSubSectionItems = true;
                                                                            }
                                                                          }
                                                                          bool hasSubSectionImages = subSection
                                                                              .images
                                                                              .isNotEmpty;
                                                                          bool hasSubSectionComments = subSection
                                                                              .comments
                                                                              .isNotEmpty;
                                                                          bool
                                                                              hasSectionItemComments =
                                                                              subSection.items.any((item) => item.comments.isNotEmpty);
                                                                          if (hasSubSectionItems ||
                                                                              hasSubSectionImages ||
                                                                              hasSubSectionComments ||
                                                                              hasSectionItemComments) {
                                                                            return Padding(
                                                                              padding: const EdgeInsets.only(top: 13.0, bottom: 13.0),
                                                                              child: SectionTile(
                                                                                section: subSection,
                                                                                isExpanded: isExpanded,
                                                                                sectionIndex: sectionIndex,
                                                                                hasSubsections: false,
                                                                                totalComments: numberOfDiffencyCommentsInSectionAndNumberOfTotalComments(subSection)[1],
                                                                                diffencyCount: numberOfDiffencyCommentsInSectionAndNumberOfTotalComments(subSection)[0],
                                                                                inspection: widget.inspection,
                                                                                selectedTemplate: selectedTemplate,
                                                                              ),
                                                                            );
                                                                          } else {
                                                                            return const SizedBox.shrink();
                                                                          }
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
                                                      if (widget
                                                              .printCallBack !=
                                                          null) {
                                                        widget.printCallBack!();
                                                      }
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
                                                            backgroundColor:
                                                                ProjectColors
                                                                    .firefly),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(12.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
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
                                                    onPressed: () async {
                                                      print("I am called");
                                                      if (widget
                                                              .downloadCallBack !=
                                                          null) {
                                                        await widget
                                                            .downloadCallBack!();
                                                      }
                                                      // downloadFile(
                                                      //     'https://api.scopeinspectapp.com/pdfs/inspections-${widget.inspection.id}.pdf');
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
                                                            backgroundColor:
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
                                                        children: [
                                                          isdownloading
                                                              ? const CupertinoActivityIndicator(
                                                                  color: ProjectColors
                                                                      .firefly)
                                                              : const Icon(Icons
                                                                  .cloud_download),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          const Text('PDF',
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
                                  key: inspectionInfoKey,
                                  inspection: widget.inspection,
                                  media: widget.media,
                                  user: widget.user,
                                  selectedTemplate: selectedTemplate),
                              const Legends(),
                              InspectionDescription(
                                  inspection: widget.inspection,
                                  selectedTemplate: selectedTemplate),
                              ReportSummary(
                                  key: inspectionSummaryKey,
                                  inspection: widget.inspection,
                                  media: widget.media,
                                  selectedTemplate: selectedTemplate),
                              TemplateSections(
                                  inspection: widget.inspection,
                                  selectedTemplate: selectedTemplate,
                                  media: widget.media)
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              floatingActionButton: _showBackToTopButton == false
                  ? null
                  : FloatingActionButton(
                      onPressed: _scrollToTop,
                      child: const Icon(Icons.arrow_upward),
                    ),
            ),
          );
        }
      }
    });
  }
}
