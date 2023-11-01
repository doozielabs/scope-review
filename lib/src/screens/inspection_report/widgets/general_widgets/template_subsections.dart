import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/data/models/comment_model.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/data/models/template.dart';
import 'package:pdf_report_scope/src/data/models/template_item.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/primary_heading_text_with_background.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/secondary_heading_text_with_background.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/section_comment_card.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/section_item.dart';
import 'package:pdf_report_scope/src/utils/helpers/helper.dart';

class TemplateSubSection extends StatelessWidget {
  //TODO: Template section work is in progress need to rectify this.
  const TemplateSubSection({
    Key? key,
    required this.inspection,
    required this.media,
    required this.sectionIndex,
    required this.selectedTemplate,
  }) : super(key: key);

  final InspectionModel inspection;
  final List<ImageShape> media;
  final int sectionIndex;
  final Template selectedTemplate;

  @override
  Widget build(BuildContext context) {
    final subSections = selectedTemplate.sections[sectionIndex].subSections;
    return MasonryGridView.count(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: subSections.length,
        crossAxisCount: 1,
        itemBuilder: (context, subSectionIndex) {
          bool hasSubSectionItems = false;
          for (var item in subSections[subSectionIndex].items) {
            if (!item.unspecified) {
              hasSubSectionItems = true;
            }
          }
          bool hasSubSectionImages =
              subSections[subSectionIndex].images.isNotEmpty;
          bool hasSubSectionComments =
              subSections[subSectionIndex].comments.isNotEmpty;
          bool hasSectionItemComments = subSections[subSectionIndex]
              .items
              .any((item) => item.comments.isNotEmpty);
          List<TemplateItem> filterItems = [];
          filterItems = GeneralHelper.getOnlyValidSectionItems(subSections[subSectionIndex].items);
          int crossAxisCountItems = 1;
          int crossAxisCountComments = 1;
          // if(filterItems.length <  GeneralHelper.getSizeByDevicesForItems()){
          //   crossAxisCountItems = filterItems.length;
          // } else {
            crossAxisCountItems = GeneralHelper.getSizeByDevicesForItems();
          // }
          // if(crossAxisCountItems ==0 || crossAxisCountItems==1){
          //   crossAxisCountItems =1;
          // }

          // if(subSections[subSectionIndex].comments.length <  GeneralHelper.getSizeByDevicesForComments()){
          //   crossAxisCountComments = subSections[subSectionIndex].comments.length;
          // } else {
            crossAxisCountComments = GeneralHelper.getSizeByDevicesForComments();
          // }
          // if(crossAxisCountComments ==0 || crossAxisCountComments ==1){
          //   crossAxisCountComments =1;
          // }
          if (hasSubSectionItems ||
              hasSubSectionImages ||
              hasSubSectionComments ||
              hasSectionItemComments) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: PrimaryHeadingTextWithBackground(
                      key: itemKeys[selectedTemplate.sections[sectionIndex]
                          .subSections[subSectionIndex].uid!],
                      headingText:
                          "${selectedTemplate.sections[sectionIndex].name}: ${subSections[subSectionIndex].name!}",
                      backgroundColor: ProjectColors.firefly),
                ),
                hasSubSectionItems
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: Container(
                            decoration: BoxDecoration(
                              color: ProjectColors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: ProjectColors.firefly.withOpacity(0.15),
                                width: 1.5,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: SecondaryHeadingTextWithBackground(
                                    headingText: "Subsection Items Details",
                                    backgroundColor:
                                        ProjectColors.firefly.withOpacity(0.2),
                                    textColor: ProjectColors.firefly,
                                  ),
                                ),
                                //Section Items
                                MasonryGridView.count(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      filterItems.length,
                                  crossAxisCount: crossAxisCountItems,
                                  // isMobile
                                  //     ? 1
                                  //     : isTablet
                                  //         ? 2
                                  //         : 3,
                                  mainAxisSpacing: 14,
                                  crossAxisSpacing: 14,
                                  itemBuilder: (context, itemIndex) {
                                    return SectionItem(
                                      isSubsectionItem: true,
                                      item: filterItems[itemIndex],
                                          media:media
                                    );
                                  },
                                ),
                              ]),
                            )),
                      )
                    : const SizedBox(),
                hasSubSectionImages
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: Container(
                            decoration: BoxDecoration(
                              color: ProjectColors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: ProjectColors.firefly.withOpacity(0.15),
                                width: 1.5,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(children: [
                                Column(
                                  children: [
                                    subSections[subSectionIndex]
                                            .images
                                            .isNotEmpty
                                        ? SecondaryHeadingTextWithBackground(
                                            headingText: "Subsection Images",
                                            textColor: ProjectColors.firefly,
                                            backgroundColor: ProjectColors
                                                .mariner
                                                .withOpacity(0.20))
                                        : const SizedBox(),
                                    const SizedBox(height: 14),
                                    GeneralHelper.displayMediaList(
                                        subSections[subSectionIndex].images,
                                        media,
                                        4,
                                        ImageType.sectionImage),
                                    // MasonryGridView.count(
                                    //     physics:
                                    //         const NeverScrollableScrollPhysics(),
                                    //     shrinkWrap: true,
                                    //     itemCount: subSections[subSectionIndex]
                                    //         .images
                                    //         .length,
                                    //     crossAxisCount:
                                    //         (isMobile || isTablet) ? 2 : 4,
                                    //     mainAxisSpacing: 4,
                                    //     crossAxisSpacing: 4,
                                    //     itemBuilder:
                                    //         (context, subSectionImageIndex) {
                                    //       return ImageWithRoundedCorners(
                                    //         imageUrl: isWeb
                                    //             ? GeneralHelper.getMediaObj(
                                    //                 subSections[subSectionIndex]
                                    //                     .images,
                                    //                 media) //"https://picsum.photos/seed/picsum/200/300"
                                    //             : GeneralHelper.getMediaObj(
                                    //                 subSections[subSectionIndex]
                                    //                     .images,
                                    //                 media),
                                    //         height: getImageWidthHeight(
                                    //             ImageType.sectionImage,
                                    //             subSections[subSectionIndex]
                                    //                 .images)[1],
                                    //         width: getImageWidthHeight(
                                    //             ImageType.sectionImage,
                                    //             subSections[subSectionIndex]
                                    //                 .images)[0],
                                    //       );
                                    //     }),
                                  ],
                                ),
                              ]),
                            )),
                      )
                    : const SizedBox(),
                hasSubSectionComments
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: Container(
                            decoration: BoxDecoration(
                              color: ProjectColors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: ProjectColors.firefly.withOpacity(0.15),
                                width: 1.5,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(children: [
                                Column(children: [
                                  subSections[subSectionIndex].images.isNotEmpty
                                      ? SecondaryHeadingTextWithBackground(
                                          headingText: "Subsection Comments",
                                          textColor: ProjectColors.firefly,
                                          backgroundColor: ProjectColors.mariner
                                              .withOpacity(0.20))
                                      : const SizedBox(),
                                  const SizedBox(height: 14),
                                  MasonryGridView.count(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: subSections[subSectionIndex]
                                        .comments
                                        .length,
                                    crossAxisCount: crossAxisCountItems,
                                    // isMobile
                                    //     ? 1
                                    //     : isTablet
                                    //         ? 2
                                    //         : 2,
                                    mainAxisSpacing: 4,
                                    crossAxisSpacing: 4,
                                    itemBuilder:
                                        (context, sectionCommentIndex) {
                                      return SectionCommentCard(
                                          // key:itemKeys[subSections[subSectionIndex]
                                          // .comments[sectionCommentIndex].uid!],
                                          comment: subSections[subSectionIndex]
                                              .comments[sectionCommentIndex],
                                          commentTitle:
                                              'Comment ( ${subSections[subSectionIndex].name} )',
                                          media: media);
                                    },
                                  ),
                                ]),
                                const SizedBox(height: 14),
                              ]),
                            )),
                      )
                    : const SizedBox(),
                //Subsection item Comments
                hasSectionItemComments
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: Container(
                            decoration: BoxDecoration(
                              color: ProjectColors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: ProjectColors.firefly.withOpacity(0.15),
                                width: 1.5,
                              ),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(children: [
                                  SecondaryHeadingTextWithBackground(
                                      headingText: "Subsection Items Comments",
                                      textColor: ProjectColors.firefly,
                                      backgroundColor: ProjectColors.mariner
                                          .withOpacity(0.20)),
                                  const SizedBox(height: 14),
                                  SubSectionItemComments(
                                    sectionIndex: sectionIndex,
                                    inspection: inspection,
                                    subSectionIndex: subSectionIndex,
                                    media: media,
                                    selectedTemplate:selectedTemplate,
                                  )
                                ]))),
                      )
                    : const SizedBox(),
              ],
            );
          } else {
            return const SizedBox();
          }
        });
  }
}

class SubSectionItemComments extends StatelessWidget {
  const SubSectionItemComments({
    Key? key,
    required this.inspection,
    required this.media,
    required this.subSectionIndex,
    required this.sectionIndex,
    required this.selectedTemplate,
  }) : super(key: key);

  final InspectionModel inspection;
  final List<ImageShape> media;
  final int subSectionIndex;
  final int sectionIndex;
  final Template selectedTemplate;

  @override
  Widget build(BuildContext context) {
    List<Comment> subSectionItemComments = [];
    for (var subSectionItem in selectedTemplate.sections[sectionIndex].subSections[subSectionIndex].items) {
      for (var comment in subSectionItem.comments) {
        subSectionItemComments.add(comment);
      }
    }
    int crossAxisCountItemComments = GeneralHelper.getSizeByDevicesForComments();
    // if(subSectionItemComments.length <  GeneralHelper.getSizeByDevicesForComments()){
    //   crossAxisCountItemComments = subSectionItemComments.length;
    // } else {
    //   crossAxisCountItemComments = GeneralHelper.getSizeByDevicesForComments();
    // }
    // if(crossAxisCountItemComments ==0){
    //   crossAxisCountItemComments =1;
    // }
    // if(subSectionItemComments.length ==1){
    //   crossAxisCountItemComments =2;
    // }
    return MasonryGridView.count(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: subSectionItemComments.length,
        crossAxisCount: crossAxisCountItemComments,
        // isMobile
        //     ? 1
        //     : isTablet
        //         ? 2
        //         : 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, sectionCommentIndex) {
          return SectionCommentCard(
              commentTitle: selectedTemplate
                  .commentTitle(subSectionItemComments[sectionCommentIndex]),
              comment: subSectionItemComments[sectionCommentIndex],
              media: media);
        });
  }
}


// return MasonryGridView.count(
                                //   physics:
                                //       const NeverScrollableScrollPhysics(),
                                //   shrinkWrap: true,
                                //   itemCount:
                                //       subSectionItem.comments.length,
                                //   crossAxisCount: isMobile
                                //       ? 1
                                //       : isTablet
                                //           ? 2
                                //           : 3,
                                //   mainAxisSpacing: 4,
                                //   crossAxisSpacing: 4,
                                //   itemBuilder:
                                //       (context, subSectionCommentIndex) {
                                //     print(
                                //         "-----:${subSection[subSectionIndex].name} --${subSection[subSectionIndex].comments.length} ---${subSectionItem.comments[subSectionCommentIndex]}");
                                //     return SectionCommentCard(
                                //       imageWidth: getImageWidthHeight(
                                //           ImageType.commentImage,
                                //           subSectionItem
                                //               .comments[
                                //                   subSectionCommentIndex]
                                //               .images)[0],
                                //       imageHeight: getImageWidthHeight(
                                //           ImageType.commentImage,
                                //           subSectionItem
                                //               .comments[
                                //                   subSectionCommentIndex]
                                //               .images)[1],
                                //       comment: subSectionItem.comments[
                                //           subSectionCommentIndex],
                                //     );
                                //   },
                                // );