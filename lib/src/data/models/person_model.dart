import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';
import 'package:pdf_report_scope/src/data/models/enum_types.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';

class Person {
  late String? id;
  late String firstname;
  late String lastname;
  late String email;
  late String phone;
  late ImageShape? photo;
  late PersonType? type;

  late List<String>? additionalEmails;

  Person({
    this.id,
    this.type,
    this.photo,
    this.firstname = "",
    this.lastname = "",
    this.email = "",
    this.phone = "",
    this.additionalEmails,
  });

  Person.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'] ?? "";
    lastname = json['lastname'] ?? "";
    email = json['email'] ?? "";
    phone = json['phone'] ?? "";
    photo = json['photo'] == null ? null : ImageShape.fromJson(json['photo']);
    type = GeneralHelper.getType(
        PersonType.values, "PersonType", json['type'] ?? "");
    if (json.containsKey("additionalEmails") &&
        json['additionalEmails'].isNotEmpty) {
      additionalEmails = json['additionalEmails'];
    }
  }

  Map<String, dynamic> toJson([bool deep = true]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['phone'] = phone;
    data['photo'] = deep ? photo?.toJson() : photo?.id;
    data['type'] = GeneralHelper.typeValue(type);
    data['additionalEmails'] = additionalEmails;
    return data;
  }

  static List<Person> fromListJson(List list) =>
      list.map((person) => Person.fromJson(person)).toList();

  // static Person? fromData(data) {
  //   Person? _person;
  //   if (data is Map || data is String) {
  //     var _id = data is Map ? data["id"] : data;
  //     var _contacts = Boxes.people().values.where((_) => _.id == _id);
  //     if (_contacts.isNotEmpty) _person = _contacts.first;
  //   }
  //   return _person;
  // }
}
