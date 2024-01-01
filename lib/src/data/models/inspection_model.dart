import 'package:pdf_report_scope/src/data/models/address_model.dart';
import 'package:pdf_report_scope/src/data/models/enum_types.dart';
import 'package:pdf_report_scope/src/data/models/general_models.dart';
import 'package:pdf_report_scope/src/data/models/payment_info_model.dart';
import 'package:pdf_report_scope/src/data/models/person_model.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';

class InspectionModel {
  late String name;
  late int endDate;
  late num totalFee;
  late String notes;
  late int startDate;
  late Person? client;
  late String reportId;
  late Address? address;
  late String description;
  late Person? buyerAgent;
  late Person? sellerAgent;
  List<Person>? otherPersons;
  late List<String> photos;
  late InspectionType status;
  late Cordinates? coordinates;
  late PaymentInfo? paymentInfo;
  late List<InspectinCleintWithAgreement> preInspectionAgreement;
  late bool trash;
  late String? id;
  late bool isManual;
  late int? serverTimestamp;
  late int? lastModified;
  late Map<String, String> inspectionHashMap;
  InspectionModel(
      {this.id,
      this.client,
      this.address,
      this.coordinates,
      this.buyerAgent,
      this.sellerAgent,
      this.paymentInfo,
      this.endDate = 0,
      this.totalFee = 0,
      this.startDate = 0,
      this.trash = false,
      this.name = "",
      this.notes = "",
      this.reportId = "",
      this.description = "",
      this.status = InspectionType.none,
      this.preInspectionAgreement = const [],
      this.isManual = false,
      this.serverTimestamp,
      this.lastModified,
      this.inspectionHashMap = const {},
      this.otherPersons = const []})
      : photos = [];

  InspectionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serverTimestamp = json['serverTimestamp'] ?? 0;
    lastModified = json['lastModified'] ?? 0;
    if (json['inspectionHashMap'] != null) {
      Map<String, dynamic> dynamicHashmap = json['inspectionHashMap'];
      inspectionHashMap =
          dynamicHashmap.map((key, value) => MapEntry(key, value.toString()));
    } else {
      inspectionHashMap = <String, String>{};
    }
    name = json['name'];
    if (json['otherPersons'] != null) {
      otherPersons = Person.fromListJson(json['otherPersons']);
    } else {
      otherPersons = [];
    }
    description = json['description'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    startDate = json['startDate'];
    endDate = json['endDate'];
    coordinates = json['coordinates'] != null
        ? Cordinates.fromJson(json['coordinates'])
        : null;
    notes = json['notes'];
    paymentInfo = json['paymentInfo'] != null
        ? PaymentInfo.fromJson(json['paymentInfo'])
        : null;
    totalFee = json['totalFee'] ?? 0;
    reportId = json['reportId'] ?? "";
    photos = List<String>.from(json['photos'] ?? []);

    sellerAgent = Person.fromJson(json['sellerAgent'] ?? {});
    buyerAgent = Person.fromJson(json['buyerAgent'] ?? {});
    client = Person.fromJson(json['client'] ?? {});

    status = GeneralHelper.getType(
      InspectionType.values,
      "InspectionType",
      json['status'],
    );
    trash = json['trash'];
    isManual = json['isManual'] ?? false;
    preInspectionAgreement = [];
  }

  get cordinate => null;
  static List<InspectionModel> fromListJson(List list) =>
      list.map((inspection) => InspectionModel.fromJson(inspection)).toList();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['serverTimestamp'] = serverTimestamp;
    data['lastModified'] = lastModified;
    data['inspectionHashMap'] = inspectionHashMap;
    data['name'] = name;
    data['description'] = description;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    if (coordinates != null) {
      data['coordinates'] = coordinates!.toJson();
    }
    data['notes'] = notes;
    if (paymentInfo != null) {
      data['paymentInfo'] = paymentInfo!.toJson();
    }
    data['totalFee'] = totalFee;
    data['reportId'] = reportId;
    data['photos'] = photos;
    if (client != null) {
      data['client'] = client!.toJson();
    }
    if (buyerAgent != null) {
      data['buyerAgent'] = buyerAgent!.toJson();
    }
    if (sellerAgent != null) {
      data['sellerAgent'] = sellerAgent!.toJson();
    }
    data['status'] = GeneralHelper.typeValue(status);
    data['trash'] = trash;
    data['isManual'] = isManual;
    data['otherPersons'] = otherPersons?.map((_) => _.toJson()).toList();
    return data;
  }

  InspectionModel.update(
      InspectionModel originalInspection, InspectionModel updatedInspection) {
    //Inspection id
    originalInspection.id = updatedInspection.id;
    //Inspection name
    originalInspection.name = updatedInspection.name;
    //Inspection endDate
    originalInspection.endDate = updatedInspection.endDate;
    //Inspection totalFee
    originalInspection.totalFee = updatedInspection.totalFee;
    //Inspection notes
    originalInspection.notes = updatedInspection.notes;
    //Inspection startDate
    originalInspection.startDate = updatedInspection.startDate;
    //Inspection client
    originalInspection.client = updatedInspection.client;
    //Inspection reportId
    originalInspection.reportId = updatedInspection.reportId;
    //Inspection address
    originalInspection.address = updatedInspection.address;
    //Inspection description
    originalInspection.description = updatedInspection.description;
    //Inspection buyerAgent
    originalInspection.buyerAgent = updatedInspection.buyerAgent;
    //Inspection sellerAgent
    originalInspection.sellerAgent = updatedInspection.sellerAgent;
    //Inspection photos
    originalInspection.photos = updatedInspection.photos;
    //Inspection status
    originalInspection.status = updatedInspection.status;
    //Inspection coordinates
    originalInspection.coordinates = updatedInspection.coordinates;
    //Inspection paymentInfo
    originalInspection.paymentInfo = updatedInspection.paymentInfo;
    //Inspection preInspectionAgreement
    originalInspection.preInspectionAgreement =
        updatedInspection.preInspectionAgreement;
    //Inspection trash
    originalInspection.trash = updatedInspection.trash;
    //Inspection invoice
    // originalInspection.invoice = updatedInspection.invoice;
    //Inspection isManual
    originalInspection.isManual = updatedInspection.isManual;
    //Inspection Template
    // originalInspection.template = updatedInspection.template;
    //Inspection Server Time Stamp
    originalInspection.serverTimestamp = updatedInspection.serverTimestamp;
    //Inspection Last Mofified Time
    originalInspection.lastModified = updatedInspection.lastModified;
    //Inspection Inspection Hash Map
    originalInspection.inspectionHashMap = updatedInspection.inspectionHashMap;
  }

  static Map<String, String> getMapIdofList(List<dynamic> list) {
    Map<String, String> hashmap = <String, String>{};
    if (list.isNotEmpty) {
      for (var element in list) {
        if (element.uid != "" && element.uid != null) {
          hashmap[element.uid] = element.id;
        }
      }
    }
    return hashmap;
  }
}
