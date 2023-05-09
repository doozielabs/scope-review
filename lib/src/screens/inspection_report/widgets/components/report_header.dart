import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/data/models/user_model.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/mobile/report_header.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/tablet/report_header.dart';
import 'package:pdf_report_scope/src/screens/inspection_report/widgets/web/report_header.dart';
import 'package:sizer/sizer.dart';

class ReportHeader extends StatelessWidget {
  final InspectionModel inspection;
  final List<ImageShape>? media;
  final User user;
  const ReportHeader(
      {Key? key,
      required this.inspection,
      required this.media,
      required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (SizerUtil.deviceType == DeviceType.mobile) {
        return ReportHeaderMobile(
          inspection: inspection,
          media: media!,
          user: user,
        );
      } else if (SizerUtil.deviceType == DeviceType.tablet) {
        return ReportHeaderTablet(
          inspection: inspection,
          media: media!,
          user: user,
        );
      } else {
        if (constraints.maxWidth < 500) {
          //Mobile
          return ReportHeaderMobile(
            inspection: inspection,
            media: media!,
            user: user,
          );
        }
        //TODO: need to manage this
        if (constraints.maxWidth < 1030) {
          //Tablet
          return ReportHeaderTablet(
            inspection: inspection,
            media: media!,
            user: user,
          );
        } else {
          //Web
          return ReportHeaderWeb(
            inspection: inspection,
            media: media!,
            user: user,
          );
        }
      }
    });
  }
}
