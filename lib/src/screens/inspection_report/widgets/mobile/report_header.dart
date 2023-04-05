import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';
import 'package:pdf_report_scope/src/core/constant/globals.dart';
import 'package:pdf_report_scope/src/core/constant/typography.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/horizontal_divider_widget.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/rounded_corner_image.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/general_widgets/report_header_item.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';

class ReportHeaderMobile extends StatelessWidget {
  final Inspection inspection;
  final List<ImageShape>? media;
  const ReportHeaderMobile(
      {Key? key, required this.inspection, required this.media})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _returnAddressString() {
      if (inspection.address!.street != "") {
        return "${inspection.address!.street} ${inspection.address!.city}, ${inspection.address!.state} ${inspection.address!.zipcode}";
      } else {
        return "Unspecified";
      }
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: width * 1,
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
                inspection.template!.name == ""
                    ? "Unspecified"
                    : inspection.template!.name.toUpperCase(),
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
                    // style: secondryHeadingTextStyle,
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
                          // style: secondryHeadingTextStyle.copyWith(
                          //   fontWeight: FontWeight.w500,
                          //   fontSize: 16,
                          // ),
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
                    // style: secondryHeadingTextStyle,
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
                    // style: secondryHeadingTextStyle,
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
                  Text(
                    "Home Buyer:",
                    // style: secondryHeadingTextStyle,
                  ),
                  SizedBox(height: 10),
                  HeaderInfoItem(
                      iconName: "icon-user",
                      text: inspection.sellerAgent?.firstname == ''
                          ? "Unspecified"
                          : "${inspection.sellerAgent?.firstname}"),
                  SizedBox(height: 10),
                  HeaderInfoItem(
                      iconName: "icon-mail",
                      text: inspection.sellerAgent?.email == ''
                          ? "Unspecified"
                          : "${inspection.sellerAgent?.email}"),
                  SizedBox(height: 10),
                  HeaderInfoItem(
                      iconName: "icon-cell",
                      text: inspection.sellerAgent?.phone == ''
                          ? "Unspecified"
                          : "${inspection.sellerAgent?.phone}")
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
                  Text(
                    "Inspected by:",
                    // style: secondryHeadingTextStyle,
                  ),
                  SizedBox(height: 10),
                  HeaderInfoItem(
                      iconName: "icon-user",
                      text: inspection.client?.firstname == ''
                          ? "Unspecified"
                          : "${inspection.client?.firstname}"),
                  SizedBox(height: 10),
                  HeaderInfoItem(
                      iconName: "icon-mail",
                      text: inspection.client?.email == ''
                          ? "Unspecified"
                          : "${inspection.client?.email}"),
                  SizedBox(height: 10),
                  HeaderInfoItem(
                      iconName: "icon-cell",
                      text: inspection.client?.phone == ''
                          ? "Unspecified"
                          : "${inspection.client?.phone}"),
                  SizedBox(height: 10),
                  HeaderInfoItem(
                      iconName: "icon-company",
                      text: inspection.user?.organization == ''
                          ? "Unspecified"
                          : "${inspection.user?.organization}")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
