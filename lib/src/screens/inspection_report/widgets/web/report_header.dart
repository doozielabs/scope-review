import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/rounded_corner_image.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/horizontal_divider_widget.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/report_header_item.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/vertical_divider.dart';

class ReportHeaderWeb extends StatelessWidget {
  final Inspection inspection;
  final List<ImageShape>? media;
  const ReportHeaderWeb(
      {Key? key, required this.inspection, required this.media})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<String> _images = [];
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: height * 0.6,
        decoration: BoxDecoration(
          color: ProjectColors.firefly,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.all(10.0),
                child:
                    GeneralHelper.getMediaForHeader(inspection.photos, media!)),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                        child: Text(
                          inspection.template!.name == ""
                              ? "Unspecified"
                              : inspection.template!.name.toUpperCase(),
                          style: primaryHeadingTextStyle.copyWith(
                              color: ProjectColors.white),
                        ),
                      ),
                    ],
                  ),
                  const HorizontalDividerWidget(),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Site Address:",
                                style: secondryHeadingTextStyle,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  SvgPicture.asset(" assets/svg/location.svg"),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      GeneralHelper.getInspectionAddress(
                                          inspection.address),
                                      overflow: TextOverflow.visible,
                                      style: secondryHeadingTextStyle.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const VerticalHorizontalDividerWidget(
                        height: 58,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Start Inspection Date",
                              style: secondryHeadingTextStyle,
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              direction: Axis.horizontal,
                              children: [
                                HeaderInfoItem(
                                  iconName: "clock_icon",
                                  text:
                                      GeneralHelper.getInspectionDateTimeFormat(
                                          inspection.startDate),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "End Inspection Date",
                              style: secondryHeadingTextStyle,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                HeaderInfoItem(
                                  iconName: "clock_icon",
                                  text:
                                      GeneralHelper.getInspectionDateTimeFormat(
                                          inspection.endDate),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const HorizontalDividerWidget(),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Home Buyer:",
                                style: secondryHeadingTextStyle,
                              ),
                              const SizedBox(height: 10),
                              HeaderInfoItem(
                                  iconName: "icon-user",
                                  text: inspection.sellerAgent?.firstname == ''
                                      ? "Unspecified"
                                      : "${inspection.sellerAgent?.firstname}"),
                              const SizedBox(height: 10),
                              HeaderInfoItem(
                                  iconName: "icon-mail",
                                  text: inspection.sellerAgent?.email == ''
                                      ? "Unspecified"
                                      : "${inspection.sellerAgent?.email}"),
                              const SizedBox(height: 10),
                              HeaderInfoItem(
                                  iconName: "icon-cell",
                                  text: inspection.sellerAgent?.phone == ''
                                      ? "Unspecified"
                                      : "${inspection.sellerAgent?.phone}")
                            ],
                          ),
                        ),
                      ),
                      const VerticalHorizontalDividerWidget(
                        height: 155,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Inspected by:",
                              style: secondryHeadingTextStyle,
                            ),
                            const SizedBox(height: 10),
                            HeaderInfoItem(
                                iconName: "icon-user",
                                text: inspection.client?.firstname == ''
                                    ? "Unspecified"
                                    : "${inspection.client?.firstname}"),
                            const SizedBox(height: 10),
                            HeaderInfoItem(
                                iconName: "icon-mail",
                                text: inspection.client?.email == ''
                                    ? "Unspecified"
                                    : "${inspection.client?.email}"),
                            const SizedBox(height: 10),
                            HeaderInfoItem(
                                iconName: "icon-cell",
                                text: inspection.client?.phone == ''
                                    ? "Unspecified"
                                    : "${inspection.client?.phone}"),
                            const SizedBox(height: 10),
                            HeaderInfoItem(
                                iconName: "icon-company",
                                text: inspection.user?.organization == ''
                                    ? "Unspecified"
                                    : "${inspection.user?.organization}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
