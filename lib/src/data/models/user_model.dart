import 'package:pdf_report_scope/src/data/models/address_model.dart';
import 'package:pdf_report_scope/src/data/models/enum_types.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';

class User {
  late String? id;

  late String? firstname;

  late String? lastname;

  late String? email;

  late String? address;

  late Address? companyAddress;

  late String? phone;

  late ImageShape? logo;

  late PlanType? planMode;

  late int? reportLimits;

  late String? accessToken;

  late int? expireAt;

  late UserType? userType;

  late ImageShape? photo;

  late String? organization;

  late String? website;

  late Cordinates? location;

  late ImageShape? signature;
  // late String signature;

  late String licenseNumber;

  late int licenseExpirationDate;

  late int licenseIssueDate;

  late String? stripeConnectId;

  late int? stripeOnboarded;

  String? timezone;

  bool? daylightSaving;

  User(
      {this.id,
      this.firstname,
      this.lastname,
      this.email,
      this.address,
      this.companyAddress,
      this.phone,
      this.logo,
      this.planMode,
      this.reportLimits,
      this.accessToken,
      this.expireAt,
      this.userType,
      this.photo,
      this.website,
      this.organization = "",
      this.location,
      this.signature,
      this.licenseNumber = "",
      this.licenseIssueDate = 0,
      this.licenseExpirationDate = 0,
      this.stripeConnectId,
      this.stripeOnboarded,
      this.timezone,
      this.daylightSaving});

  User.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    firstname = json["firstname"];
    lastname = json["lastname"];
    email = json["email"];
    address = json["address"];
    phone = json["phone"];
    companyAddress = json["companyAddress"] == null
        ? null
        : Address.fromJson(json["companyAddress"]);
    // logo = json["logo"] == null ? null : ImageShape.fromJson(json["logo"]);
    // reportLimits = json["reportLimits"];
    // accessToken = json["accessToken"];
    // expireAt = json["expireAt"];
    // planMode = GeneralHelper.getType(
    //   PlanType.values,
    //   "PlanType",
    //   json["planMode"],
    // );
    // userType = GeneralHelper.getType(
    //   UserType.values,
    //   "UserType",
    //   json["userType"],
    // );
    photo = json["photo"] == null ? null : ImageShape.fromJson(json["photo"]);
    website = json["website"];
    logo = json["logo"] == null ? null : ImageShape.fromJson(json['logo']);
    organization = json["organization"];
    // signature = json['signature'];
    // location = json["location"];
    signature = json["signature"] == null
        ? null
        : ImageShape.fromJson(json["signature"]);
    licenseNumber = json["licenseNumber"] ?? "";
    // licenseIssueDate = json["licenseIssueDate"] ?? 0;
    // licenseExpirationDate = json["licenseExpirationDate"] ?? 0;
    // stripeConnectId = json["stripeConnectId"] ?? "";
    // stripeOnboarded = json["stripeOnboarded"] ?? 0;
    timezone = json["timezone"];
    daylightSaving = json["daylightSaving"]??false;
  }

  Map<String, dynamic> toJson([bool deep = true]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["firstname"] = firstname;
    data["lastname"] = lastname;
    data["email"] = email;
    data["address"] = address;
    data["phone"] = phone;
    data["companyAddress"] = companyAddress?.toJson();
    // data["reportLimits"] = reportLimits;
    // data["accessToken"] = accessToken;
    // data["expireAt"] = expireAt;
    // data["planMode"] = GeneralHelper.typeValue(PlanType);
    // data["userType"] = GeneralHelper.typeValue(UserType);
    data["website"] = website;
    data["logo"] = logo?.toJson();
    data["photo"] = photo?.toJson();
    data["organization"] = organization;
    // data["signature"] = signature;
    data["signature"] = signature?.toJson();
    // data["location"] = location;
    // data["logo"] = !deep ? logo?.id : logo?.toJson();
    // data["signature"] = !deep ? signature?.id : signature?.toJson();
    data["licenseNumber"] = licenseNumber;
    // data["licenseIssueDate"] = licenseIssueDate;
    // data["licenseExpirationDate"] = licenseExpirationDate;
    // data["stripeConnectId"] = stripeConnectId;
    // data["stripeOnboarded"] = stripeOnboarded;
    data['timezone'] = timezone;
    data['daylightSaving'] = daylightSaving??false;
    print("user data:$data");
    return data;
  }
}
