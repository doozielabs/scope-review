import 'package:pdf_report_scope/src/data/models/comment_model.dart';
import 'package:pdf_report_scope/src/data/models/enum_types.dart';
import 'package:pdf_report_scope/src/data/models/general_models.dart';
import 'package:pdf_report_scope/src/data/models/template.dart';
import 'package:pdf_report_scope/src/data/models/template_item.dart';
import 'package:pdf_report_scope/src/data/models/template_section.dart';
import 'package:pdf_report_scope/src/data/models/template_subsection.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';
import 'package:path/path.dart' as trail;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:intl/intl.dart';
import 'dart:math' as math;

extension BoolExtension on bool? {
  bool get force => this ?? false;
}

extension NullableListExtension on List? {
  List levant(List value) => (this ?? []).isEmpty ? value : this!;
}

extension ListOfNumExtension on List<num> {
  num get top => isEmpty ? 0 : reduce(max);
  num get bottom => isEmpty ? 0 : reduce(min);
  num get sum => [0, 0, ...this].reduce((a, b) => a + b);
  List<String> get string => map((_) => _.toString()).toList();
  Color get toColor {
    if (length != 4) throw "invlaid range";
    return Color.fromRGBO(
      this[0].toInt(),
      this[1].toInt(),
      this[2].toInt(),
      this[3].toDouble(),
    );
  }
}

extension ListExtension on List {
  List<T> decode<T>() => List<T>.generate(length, (_) => jsonDecode(this[_]));

  List<String> get encode => map((_) => jsonEncode(_)).toList();

  List get toJson => map((_) => _.toJson()).toList();

  int get lastIndex => length - 1;

  List<T> emptyMe<T>(bool boolean) => boolean ? [] : cast<T>();

  List get keys => map((e) => e.key).toList();

  String get firstString => isEmpty ? "" : first;

  dynamic get random => isEmpty ? null : this[Random().nextInt(length)];

  bool validatRange(int index) => index < length;

  List get shuffled {
    List list = this;
    list.shuffle();
    return list;
  }

  List get randomRange => sublist(Random().nextInt(length));

  List get set => toSet().toList();

  List get clean => where((element) => element.isNotEmpty).toList();

  List<String> get toStringList =>
      List.generate(length, (index) => this[index].toString());

  List get(String name) => map((e) => e[name]).toList();

  List jsMap(Function(dynamic value, int index) cb) =>
      asMap().entries.map((e) => cb(e.value, e.key)).toList();

  List<List> pairs(int length) {
    List<List> chunks = [];
    for (var i = 0; i < length; i += length) {
      chunks.add(
        sublist(i, i + length > length ? length : i + length),
      );
    }
    return chunks;
  }

  List<List> split(int length) => pairs((length / length).ceil());
}

extension DynamicExtension on dynamic {
  bool get isNull => this == null;
  bool get isHollow => this == null || this.isEmpty;
}

extension KeyExtension on GlobalKey {
  Size get getSize {
    if (currentContext.isNull) return const Size(0, 0);
    var box = currentContext?.findRenderObject() as RenderBox;
    Size size = box.size;
    return size;
  }

  Offset get getOffset {
    if (currentContext.isNull) return Offset.zero;
    var box = currentContext?.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    return position;
  }
}

extension BuilContextExtension on BuildContext {
  bool get keyboardOpen => MediaQuery.of(this).viewInsets.bottom != 0;
}

extension StringExtension on String? {
  String get set => this ?? "";
  String get removeExtension => trail.withoutExtension(set);
  String get fileName => trail.basename(set);
  String get nameWithoutExtension => trail.basenameWithoutExtension(set);
  // bool get isHgui => set.contains(Constants.hguiKey);
  bool match(String val) =>
      set.toLowerCase().contains(val.toString().toLowerCase());
  String get unspecified =>
      (this == null || set.isEmpty) ? "Unspecified" : this ?? "";
  int get toInt => int.parse(this!);
  int get toDouble => int.parse(this!);
  String get initials =>
      set.split(" ").map((e) => e.isEmpty ? "" : e[0]).join();
  String get capitalize => set
      .split(" ")
      .map((e) => e.isEmpty ? "" : "${e[0].toUpperCase()}${e.substring(1)}")
      .join(" ");
  String updateFileStamp() {
    if (set.isEmpty) return "";
    List<String> newImgUrl = set.split('/');
    String newImgName = newImgUrl.last.split('-').first;
    String imgExt = newImgUrl.last.split('.').last;
    newImgUrl.removeLast();
    newImgUrl
        .add('$newImgName-${DateTime.now().millisecondsSinceEpoch}.$imgExt');
    String newUrl = newImgUrl.join('/');
    return newUrl;
  }

  String get punctuation => set.isEmpty ? "" : ', $this';
  bool get isUrl => set.contains("http");
  bool get isDeviceUrl {
    if (Platform.isIOS) {
      return set.contains("/var/mobile/Containers"); // for Physical Device
      // return set.contains("data/Containers/"); // for Simulator
    }
    return set.contains("app.com.scope");
  }

  bool get isAsset => set.contains("assets");
  bool get fromCache {
    if (set.contains("app.com.scope/cache") ||
        set.contains('Caches') ||
        set.contains('tmp')) {
      return true;
    }
    return false;
  }

  Future deleteDirectory() async {
    if (set.isEmpty) return;
    var _dir = Directory(set);
    if (await _dir.exists()) {
      var _images = await _dir.list().where((_) => _.path == set).toList();
      if (_images.isNotEmpty) _images.first.delete();
    }
  }

  String firstSplit(String patern) {
    var _list = set.split(",");
    return _list.isEmpty ? "" : _list.first;
  }

  Map<String, int> get onenessId {
    var _ids = (this ?? "").split(".").map((e) => e.toInt).toList();
    return {
      "item": _ids[2],
      "comment": _ids[3],
      "section": _ids[0],
      "subSection": _ids[1],
    };
  }

  String nId(int index, newId) {
    var _ids = (this ?? "").split(".");
    _ids[index] = newId.toString();
    return _ids.join(".");
  }
}

extension ColorExtension on Color {
  String get hex => '#${value.toRadixString(16).substring(2).toString()}';
  List<num> get toRGBO => [red, green, blue, opacity];
}

extension TemplateSubSectionExtension on TemplateSubSection {
  bool hasImages() {
    for (int i = 0; i < items.length; i++) {
      if (items[i].images.isNotEmpty) {
        return true;
      } else if (items[i].type == TemplateItemType.signature) {
        if (items[i].images.isNotEmpty) {
          return true;
        }
      } else {
        return false;
      }
    }
    return false;
  }

  int getLength() {
    int len = 0;
    for (int i = 0; i < items.length; i++) {
      for (int j = 0; j < items[i].images.length; j++) {
        len++;
      }
    }
    return len;
  }

  TemplateSubSection get clone => TemplateSubSection.fromJson(toJson());

  List<Comment> remarks() {
    List<Comment> _comments = [];
    _comments.addAll(comments);
    items.asMap().forEach((_index, _item) => _comments.addAll(_item.comments));
    return _comments;
  }
}

extension TemplateItemExtension on TemplateItem {
  bool get unspecified {
    switch (type) {
      case TemplateItemType.photo:
        return (value == null || (value is List && value.length <= 0));
      case TemplateItemType.timestamp:
        return value == null;
      case TemplateItemType.choice:
        return (value == null || value.isEmpty) && defaultOption == null;

      default:
        return value == null || value.isEmpty;
    }
  }

  bool alowed(Template template) {
    switch (type) {
      case TemplateItemType.choice:
        return !prohibitConditionRating &&
            (template.conditionRatingOptions?.enableConditionRatings ?? false);
      default:
        return true;
    }
  }

  bool hasImages() {
    return images.isNotEmpty;
  }
}

extension CommentExtension on Comment {
  Comment get clone => Comment.fromJson(toJson());
}

extension IntExtension on int {
  String get time => inDate.time;
  String get smallDate => inDate.smallDate;
  String get fulldate => inDate.fulldate;
  String get fullISODate => inDate.fullISODate;
  String get fullMonth => inDate.fullMonth;
  String get regularDate => inDate.regularDate;
  String get regularISODate => inDate.regularISODate;
  String get regularDateFormat => inDate.regularDateFormat;
  bool isLast(List list) => this == list.length - 1;
  DateTime get inDate => DateTime.fromMillisecondsSinceEpoch(this);
  int get nilDate => isZero ? DateTime.now().toInt : this;
  int get inc => this + 1;
  int get dec => this - 1;
  List<int> chunk(int? amount) {
    if ((amount ?? this) >= this || amount.isNull) return [this];
    List<int> _list = [];
    _list = List.generate((this ~/ amount!), (_) => amount);
    _list.add((this % amount).toInt());
    if (_list.last.isZero) _list.removeLast();
    return _list;
  }
}

extension NumExtension on num {
  num get toNum => num.parse(toString());
  num get twice => this * 2;
  num get half => this / 2;
  num relative(bool state) => state ? -this : abs();
  String get quadrant => (this / 90).abs().toStringAsFixed(0);
  num get bleak => isNegative ? this : 0;
  bool get isZero => this <= 0;
  num get inc => this + 1;
  num get dec => this - 1;
  String get currency => NumberFormat.compactCurrency(
        decimalDigits: 0,
        symbol: '\$',
      ).format(this);
  String get currencyUncompact => NumberFormat.currency(
        decimalDigits: 0,
        symbol: '\$',
      ).format(this);
  double get degree => this * math.pi / 180;
  double inPercent(double? percent) => this * (percent ?? 100) / 100;
  double percentOf(num number) => isZero ? 0 : (number / this) * 100;
  List<num> stairs(int quantity) =>
      List.generate(quantity + 1, (_) => (this / quantity) * _);
}

extension ListOfCommentExtension on List<Comment> {
  Future<List<String>> get media async {
    List<String> _images = [];
    await Future.forEach(this, (comment) {
      comment as Comment;
      _images.addAll(comment.images);
    });
    return _images;
  }

  Future<List<Comment>> indentification(Id id) async {
    await Future.forEach(this, (comment) async {
      comment as Comment;
      id.comment = indexOf(comment).inc;
      comment.id = id.id();
    });
    return this;
  }
}

extension TemplateSectionExtension on TemplateSection {
  // Future updateImages() async {
  //   try {
  //     images = await _updateMedia(images);
  //     await Future.forEach(items, (TemplateItem _) async => _.updateImages());
  //     await Future.forEach(
  //       comments,
  //       (Comment _) async => _.images = await _updateMedia(_.images),
  //     );
  //     await Future.forEach(
  //       subSections,
  //       (TemplateSubSection _) async => _.updateImages(),
  //     );
  //   } catch (error) {
  //     throw (error);
  //   }
  // }

  // Future dowloadImages() async {
  //   images = await _downloadMedia(images);
  //   print("Images: $images");
  //   await Future.forEach(items, (TemplateItem _) async => _.downloadMedia());
  //   await Future.forEach(
  //     comments,
  //     (Comment _) async => _.images = await _downloadMedia(_.images),
  //   );
  //   await Future.forEach(
  //     subSections,
  //     (TemplateSubSection _) async => _.downloadMedia(),
  //   );
  // }

  // Future<List<String>> get media async {
  //   List<String> _images = [];
  //   _images.addAll(images);
  //   _images.addAll(await items.media);
  //   // _images.addAll(await comments.media);
  //   await Future.forEach(
  //     subSections,
  //     (TemplateSubSection _) async => _images.addAll(await _.media),
  //   );
  //   return _images;
  // }

  Future<List<String>> names([bool withItems = false]) async {
    List<String> _names = [];
    _names.add(name ?? "");
    if (withItems) _names.addAll(items.map((_) => _.label ?? ""));
    await Future.forEach(subSections, (_) {
      _ as TemplateSubSection;
      _names.add(_.name ?? "");
      if (withItems) _names.addAll((_.items).map((_) => _.label ?? ""));
    });
    return _names;
  }

  TemplateSection get clone => TemplateSection.fromJson(toJson());
  // List<Comment> remarks({
  //   bool section = true,
  //   bool visiblesOnly = false,
  // }) {
  //   List<Comment> _comments = [];
  //   _comments.addAll(comments);
  //   items.asMap().forEach((_, _item) => _comments.addAll(_item.comments));
  //   if (section) {
  //     (visiblesOnly ? subSections.visibles : subSections).asMap().forEach(
  //       (_, subSections) {
  //         _comments.addAll(subSections.remarks());
  //       },
  //     );
  //   }
  //   return _comments;
  // }

  // List<TemplateItem> get whollyItems {
  //   List<TemplateItem> _item = [];
  //   _item.addAll(this.items);
  //   (this.subSections).forEach((sec) => _item.addAll(sec.items));
  //   return _item;
  // }

  // Future remove() async {
  //   await Boxes.deleteMedia(images);
  //   await Future.forEach(comments, (Comment _) async => _.remove());
  //   await Future.forEach(items, (TemplateItem _) async => _.remove());
  //   await Future.forEach(
  //     subSections,
  //     (TemplateSubSection _) async => _.remove(),
  //   );
  // }

  bool hasImages() {
    for (int i = 0; i < items.length; i++) {
      if (items[i].images.length > 0) {
        return true;
      } else if (items[i].type == TemplateItemType.signature) {
        if (items[i].images.length > 0) {
          return true;
        }
      } else {
        return false;
      }
    }
    return false;
  }

  int getLength() {
    int len = 0;
    for (int i = 0; i < items.length; i++) {
      for (int j = 0; j < items[i].images.length; j++) {
        len++;
      }
    }
    return len;
  }
}

extension ListOfTemplateSectionExtension on List<TemplateSection>? {
  List<TemplateSection> get set => this ?? [];

  Future<List<List<String>>> names([bool withItems = false]) async {
    List<List<String>> _names = [];
    await Future.forEach(
      set,
      (TemplateSection _) async => _names.add(await _.names(withItems)),
    );
    return _names;
  }

  List<TemplateSection> get visibles =>
      (this ?? []).where((_) => _.visibility ?? true).toList();

  Future<List<TemplateSection>> filter(
    String keyword, {
    bool withItems = false,
  }) async {
    var _names = await set.names(withItems);
    return set.where((_) {
      var _labels = _names[set.indexOf(_)];
      return _labels.where((_) => _.match(keyword)).isNotEmpty;
    }).toList();
  }
}

extension DateTimeExtension on DateTime {
  int get toInt => millisecondsSinceEpoch;
  DateTime get firstMonth => DateTime(year, 1, 1);
  DateTime get lastMonth => DateTime(year, 12, 1);
  bool sameMonth(date) => year == date.year && month == date.month;
  DateTime addDay(int amount) => DateTime(year, month, day + amount);
  DateTime subtractDay(int amount) => DateTime(year, month, day - amount);
  DateTime addMonth(int amount) => DateTime(year, month + amount, day);
  DateTime subtractMonth(int amount) => DateTime(year, month - amount, day);
  String get time => DateFormat('h:mm a').format(this);
  String get fulldate => DateFormat('EEE, LLL d, yyyy  -  h:mm a').format(this);
  String get regularDate => DateFormat('d MMM, yyyy').format(this);
  String get smallDate => DateFormat('MMM, yyyy').format(this);
  String get fullISODate => DateFormat('EEE, d/M/yyyy  -  h:mm a').format(this);
  String get regularISODate => DateFormat('d/M/yyyy').format(this);
  String get regularDateFormat => DateFormat('M/d/yyyy').format(this);
  String get fullMonth => DateFormat('MMMM').format(this);
  String get ad => DateFormat('MMMM').format(this);
  List<DateTime> get unit {
    return List.generate(
      addMonth(1).difference(this).inDays,
      (_) => DateTime(year, month, _.inc),
    );
  }
}

// extension ListOfCommentExtension on List<Comment> {
//   Future<List<String>> get media async {
//     List<String> _images = [];
//     await Future.forEach(this, (comment) {
//       comment as Comment;
//       _images.addAll(comment.images);
//     });
//     return _images;
//   }

//   Future<List<Comment>> indentification(Id id) async {
//     await Future.forEach(this, (comment) async {
//       comment as Comment;
//       id.comment = indexOf(comment).inc;
//       comment.id = id.id();
//     });
//     return this;
//   }
// }

// Enum
extension PersonTypeExtension on PersonType {
  String get value => GeneralHelper.typeValue(this);
}

extension InspectionTypeExtension on InspectionType {
  String get value => GeneralHelper.typeValue(this);
  bool get isCompleted => this == InspectionType.completed;
  bool get isOnGoing => this == InspectionType.ongoing;
  bool get isScheduled => this == InspectionType.scheduled;
  bool get isTrashed => this == InspectionType.trashed;
  bool get isUnpublished => this == InspectionType.unpublished;
  bool get isNone => this == InspectionType.none;
}

extension TemplateItemTypeExtension on TemplateItemType? {
  _data({
    choice,
    currency,
    email,
    organization,
    phone,
    photo,
    signature,
    text,
    timestamp,
    website,
  }) {
    switch (this) {
      case TemplateItemType.choice:
        return choice;
      case TemplateItemType.currency:
        return currency;
      case TemplateItemType.email:
        return email;
      case TemplateItemType.organization:
        return organization;
      case TemplateItemType.phone:
        return phone;
      case TemplateItemType.photo:
        return photo;
      case TemplateItemType.signature:
        return signature;
      case TemplateItemType.text:
        return text;
      case TemplateItemType.timestamp:
        return timestamp;
      case TemplateItemType.website:
        return website;
      default:
        return choice;
    }
  }

  String get text => _data(
        choice: "Multiple Choice (Default)",
        text: "Generic Text Entry",
        timestamp: "Date and Time",
        signature: "Signature",
        email: "Email Address",
        organization: "Name and Organization",
        phone: "Phone Number",
        website: "Website URL",
        photo: "Image",
        currency: "Currency",
      );
  String get value => GeneralHelper.typeValue(this);
  bool get isChoice => this == TemplateItemType.choice;
  bool get isCurrency => this == TemplateItemType.currency;
  bool get isEmail => this == TemplateItemType.email;
  bool get isOrganization => this == TemplateItemType.organization;
  bool get isPhone => this == TemplateItemType.phone;
  bool get isPhoto => this == TemplateItemType.photo;
  bool get isSignature => this == TemplateItemType.signature;
  bool get isText => this == TemplateItemType.text;
  bool get isTimestamp => this == TemplateItemType.timestamp;
  bool get isWebsite => this == TemplateItemType.website;
}

extension MediaCorbaMediaTypeExtension on MediaCorbaMediaType {
  String get value => GeneralHelper.typeValue(this);
}

extension CommentTypeExtension on CommentType? {
  _data({def, info, saf, acct, notIns}) {
    switch (this) {
      case CommentType.deficiency:
        return def;
      case CommentType.information:
        return info;
      // case CommentType.safety:
      //   return saf;
      // case CommentType.acceptable:
      //   return acct;
      case CommentType.notInspected:
        return notIns;
      default:
        return def;
    }
  }

  CommentType get set => this ?? CommentType.values.first;

  bool get needService => set == CommentType.deficiency;

  String get svg => _data(
        info: "assets/svg/icons/info.svg",
        saf: "assets/svg/icons/sheild.svg",
        acct: "assets/svg/icons/check.svg",
        def: "assets/svg/icons/deficiency.svg",
        notIns: "assets/svg/icons/question_mark_round.svg",
      );

  // Color get color => _data(
  //       info: LightColors.primary,
  //       saf: ProjectColors.malibu,
  //       def: LightColors.secondary,
  //       notIns: ProjectColors.tundora,
  //       acct: ProjectColors.mountainMeadow,
  //     );

  String get text => _data(
        saf: "Safety",
        acct: "Acceptable",
        def: "Deficiency",
        info: "Information",
        notIns: "Not Inspected",
      );

  String get description => _data(
        acct:
            "This icon means that a system or component was inspected, and was found to be acceptable and perform its function at the time of inspection.",
        def:
            "This icon means an inspected item needs to be repaired and is inhibiting the function of the system.",
        info:
            "This icon means the statement is for general information about the system. It can also represent an issue that is only cosmetic in nature and not inhibiting function or safety of the system.",
        saf:
            "This icon means an inspected item that is an immediate safety risk and should be approached with caution.",
        notIns:
            "This icon means an inspected item that is an immediate safety risk and should be approached with caution.",
      );
}

extension CommentLevelExtension on CommentLevel? {
  _data({homeBuyer, contractor}) {
    switch (this) {
      case CommentLevel.homeBuyer:
        return homeBuyer;
      case CommentLevel.contractor:
        return contractor;
      default:
        return homeBuyer;
    }
  }

  String get text => _data(
        homeBuyer: "home buyer",
        contractor: "contractor",
      );
}

extension TemplateExtension on Template {
  dynamic commentParent(String? id) {
    var _about = about(id ?? "");
    if (!_about.subSection.isNull) {
      return !_about.item.isNull ? _about.item! : _about.subSection!;
    } else if (!_about.section.isNull) {
      return !_about.item.isNull ? _about.item! : _about.section!;
    } else {
      return null;
    }
  }

  List<String> imageClassroom(String? id) {
    var _about = about(id?.split('-')[0] ?? "");

    _section(section) {
      if (!_about.comment.isNull) {
        return _about.comment!.images;
      } else if (!_about.item.isNull) {
        return _about.item!.type.isPhoto
            ? _about.item!.value
            : _about.item!.images;
      } else {
        return section!.images;
      }
    }

    if (!_about.subSection.isNull) {
      return _section(_about.subSection!);
    } else if (!_about.section.isNull) {
      return _section(_about.section!);
    } else {
      return [];
    }
  }

  String commentTitle(Comment comment) {
    var _data = about(comment.id ?? "");
    return [
      _data.section?.name,
      _data.subSection?.name,
      _data.item?.label,
    ].where((_) {
      return (_.isNull ? "" : _)!.isNotEmpty;
    }).join(", ");
  }

  Template get copy => Template.fromJson(toJson());
  // bool get isTrashed => this.templateStatus == flag(TemplateFlag.trash);
  // Template get activeMe {
  //   this.templateStatus = flag(TemplateFlag.active);
  //   return this;
  // }

  // Template get trashMe {
  //   this.templateStatus = flag(TemplateFlag.trash);
  //   return this;
  // }

  // int flag(TemplateFlag type) {
  //   switch (type) {
  //     case TemplateFlag.trash:
  //       return 4;
  //     case TemplateFlag.active:
  //       return 0;
  //   }
  // }

  // List<Comment> remarks([bool visiblesOnly = false]) {
  //   List<Comment> _comments = [];
  //   (visiblesOnly ? sections.visibles : sections).asMap().forEach(
  //     (index, _section) {
  //       _comments.addAll(_section.remarks(visiblesOnly: visiblesOnly));
  //     },
  //   );
  //   return _comments;
  // }

  // Future remove() async {
  //   try {
  //     await Future.forEach(
  //       sections,
  //       (TemplateSection _) async => await _.remove(),
  //     );
  //     await this.delete();
  //   } catch (error) {
  //     throw error;
  //   }
  // }

  // Future<List<String>> get media async {
  //   List<String> _images = [];
  //   await Future.forEach(
  //     sections,
  //     (TemplateSection _) async => _images.addAll(await _.media),
  //   );
  //   return _images;
  // }

  TemplateAbout about(String id) {
    TemplateSection? _section;
    TemplateSubSection? _subSection;
    TemplateItem? _item;
    Comment? _comment;
    var _id = Id.decode(id);

    _setSection(section) {
      if (_id.haveItem()) {
        if (section.items.length > _id.item.dec) {
          _item = section.items![_id.item.dec];
        }
        if (_id.haveComment()) {
          if (_item!.comments.length > _id.comment.dec) {
            _comment = _item!.comments[_id.comment.dec];
          }
        }
        // ignore: curly_braces_in_flow_control_structures
      } else if (_id.haveComment()) if (section.comments.length >
          _id.comment.dec) {
        _comment = section.comments![_id.comment.dec];
      }
    }

    if (_id.haveSection()) {
      _section = sections[_id.section.dec];
      _setSection(_id.haveSubSection()
          ? _section.subSections[_id.subSection.dec]
          : _section);
      if (_id.haveSubSection()) {
        _subSection = _section.subSections[_id.subSection.dec];
      }
    }

    return TemplateAbout(
      item: _item,
      section: _section,
      comment: _comment,
      subSection: _subSection,
    );
  }
  // Future updateImages() async {
  //   try {
  //     await Future.forEach(
  //       sections,
  //       (TemplateSection _) => _.updateImages(),
  //     );
  //   } catch (error) {
  //     throw (error);
  //   }
  // }

  // Future dowloadImages() async {
  //   try {
  //     await Future.forEach(sections, (TemplateSection _) => _.dowloadImages());
  //   } catch (error) {
  //     throw (error);
  //   }
  // }
}

extension PaymentTypeExtension on PaymentType? {
  _data({cash, check, electronicPayment, electronicPaymentviaScope}) {
    switch (this) {
      case PaymentType.cash:
        return cash;
      case PaymentType.check:
        return check;
      case PaymentType.electronicPayment:
        return electronicPayment;
      case PaymentType.electronicPaymentviaScope:
        return electronicPaymentviaScope;
      default:
        return electronicPayment;
    }
  }

  String get text => _data(
        check: "Check",
        cash: "Cash",
        electronicPayment: "Electronic Payment",
        electronicPaymentviaScope: "Electronic Payment via Scope",
      );
}
