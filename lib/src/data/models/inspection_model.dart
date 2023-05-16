import 'package:pdf_report_scope/src/data/models/address_model.dart';
import 'package:pdf_report_scope/src/data/models/general_models.dart';
import 'package:pdf_report_scope/src/data/models/payment_info_model.dart';
import 'package:pdf_report_scope/src/data/models/person_model.dart';
import 'package:pdf_report_scope/src/data/models/template.dart';
import 'package:pdf_report_scope/src/data/models/enum_types.dart';
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
  late List<String> photos;
  late InspectionType status;
  late Cordinates? coordinates;
  late PaymentInfo? paymentInfo;
  late Template? template;
  late List<InspectinCleintWithAgreement> preInspectionAgreement;
  late bool trash;
  late String? id;
  // late InvoiceReceipt? invoice;
  late bool isManual;
  late int? serverTimestamp;
  late int? lastModified;
  // late User? user;
  late Map<String, String> inspectionHashMap;
  InspectionModel(
      {this.id,
      this.client,
      this.address,
      // this.invoice,
      this.template,
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
      // this.user,
      this.inspectionHashMap = const {}})
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
    // invoice = json['invoice'] != null
    //     ? InvoiceReceipt.fromJson(json['invoice'])
    //     : null;

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
    // user = User.fromJson(json['user']);

    status = GeneralHelper.getType(
      InspectionType.values,
      "InspectionType",
      json['status'],
    );
    template = Template.fromJson(json["template"]);
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
    // if (user != null) {
    //   data['user'] = user!.toJson();
    // }
    data['status'] = GeneralHelper.typeValue(status);
    // data['invoice'] = this.invoice!.toJson(deep: false);
    data["template"] = template!.toJson();
    data['trash'] = trash;
    data['isManual'] = isManual;
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
    originalInspection.template = updatedInspection.template;
    //Inspection Server Time Stamp
    originalInspection.serverTimestamp = updatedInspection.serverTimestamp;
    //Inspection Last Mofified Time
    originalInspection.lastModified = updatedInspection.lastModified;
    //Inspection Inspection Hash Map
    originalInspection.inspectionHashMap = updatedInspection.inspectionHashMap;
  }

  // bool get invoiceAssigned => invoice != null ? true : false;

  List<String> get inspectionImages {
    List<String> images = [];
    if (photos.isNotEmpty) {
      images.add(photos.last);
    }
    if (template != null) {
      if (template!.sections.isNotEmpty) {
        for (var section in template!.sections) {
          if (section.images.isNotEmpty) images.addAll(section.images);
          if (section.comments.isNotEmpty) {
            for (var comment in section.comments) {
              if (comment.images.isNotEmpty) images.addAll(comment.images);
            }
          }
          if (section.items.isNotEmpty) {
            for (var item in section.items) {
              if (TemplateItemType.photo == item.type) {
                if ((item.value as List).isNotEmpty) images.addAll(item.value);
              } else {
                if (item.images.isNotEmpty) {
                  images.addAll(item.images);
                }
              }
              if (item.comments.isNotEmpty) {
                for (var itemComment in item.comments) {
                  if (itemComment.images.isNotEmpty) {
                    images.addAll(itemComment.images);
                  }
                }
              }
            }
          }
          if (section.subSections.isNotEmpty) {
            for (var subSection in section.subSections) {
              if (subSection.images.isNotEmpty) {
                images.addAll(subSection.images);
              }
              if (subSection.comments.isNotEmpty) {
                for (var subSectionComment in subSection.comments) {
                  if (subSectionComment.images.isNotEmpty) {
                    images.addAll(subSectionComment.images);
                  }
                }
              }
              if (subSection.items.isNotEmpty) {
                for (var subSectionItem in subSection.items) {
                  if (TemplateItemType.photo == subSectionItem.type) {
                    if ((subSectionItem.value as List).isNotEmpty) {
                      images.addAll(subSectionItem.value);
                    }
                  } else {
                    if (subSectionItem.images.isNotEmpty) {
                      images.addAll(subSectionItem.images);
                    }
                  }
                  // if (subSectionItem.images.isNotEmpty) {
                  //   images.addAll(subSectionItem.images);
                  // }
                  if (subSectionItem.comments.isNotEmpty) {
                    for (var subSectionItemComment in subSectionItem.comments) {
                      if (subSectionItemComment.images.isNotEmpty) {
                        images.addAll(subSectionItemComment.images);
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    return images;
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
