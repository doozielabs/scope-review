import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/data/models/user_model.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/horizontal_divider_widget.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/report_header_item.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';
import 'package:pdf_report_scope/src/utils/helpers/helper.dart';

class ReportHeaderMobile extends StatelessWidget {
  final InspectionModel inspection;
  final List<ImageShape>? media;
  final User user;
  const ReportHeaderMobile(
      {Key? key,
      required this.inspection,
      required this.media,
      required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        // height: height * 0.8,
        decoration: BoxDecoration(
          color: ProjectColors.firefly,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(10.0),
                child:
                    GeneralHelper.getMediaForHeader(inspection.photos, media!)),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
              child: Text(
                inspection.template!.name.unspecified.toUpperCase(),
                style: primaryHeadingTextStyle.copyWith(
                    color: ProjectColors.white),
              ),
            ),
            const HorizontalDividerWidget(),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Site Address:",
                    style: secondryHeadingTextStyle,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        "assets/svg/location.svg",
                        package: "pdf_report_scope",
                      ),
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
            const HorizontalDividerWidget(),
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
                  Row(
                    children: [
                      HeaderInfoItem(
                        iconName: "clock_icon",
                        text: GeneralHelper.getInspectionDateTimeFormat(
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
                        text: GeneralHelper.getInspectionDateTimeFormat(
                            inspection.endDate),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const HorizontalDividerWidget(),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Inspected By:",
                    style: secondryHeadingTextStyle,
                  ),
                  const SizedBox(height: 10),
                  HeaderInfoItem(
                      iconName: "icon-user",
                      text:
                          "${user.firstname.unspecified} ${user.lastname ?? ""}"),
                  const SizedBox(height: 10),
                  HeaderInfoItem(
                      iconName: "icon-mail", text: user.email.unspecified),
                  const SizedBox(height: 10),
                  HeaderInfoItem(
                      iconName: "icon-cell", text: user.phone.unspecified),
                ],
              ),
            ),
            const HorizontalDividerWidget(),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Client:",
                    style: secondryHeadingTextStyle,
                  ),
                  const SizedBox(height: 10),
                  HeaderInfoItem(
                      iconName: "icon-user",
                      text:
                          "${inspection.client!.firstname.unspecified}${inspection.client!.lastname}"),
                  const SizedBox(height: 10),
                  HeaderInfoItem(
                      iconName: "icon-mail",
                      text: inspection.client!.email.unspecified),
                  const SizedBox(height: 10),
                  HeaderInfoItem(
                      iconName: "icon-cell",
                      text: inspection.client!.phone.unspecified),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
