import 'package:pdf_report_scope/src/data/models/enum_types.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';

class PaymentInfo {
  late num paid;
  late PaymentType paymentType;

  PaymentInfo({
    this.paid = 0,
    this.paymentType = PaymentType.electronicPayment,
  });

  PaymentInfo.fromJson(Map<String, dynamic> json) {
    paid = json['paid'] ?? 0;
    paymentType = GeneralHelper.getType(
      PaymentType.values,
      "PaymentType",
      json['paymentMethod'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paid'] = paid;
    data['paymentMethod'] = GeneralHelper.typeValue(paymentType);

    return data;
  }
}
