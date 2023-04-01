import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/utils/helpers/general_helper.dart';
import 'package:pdf_report_scope/src/utils/helpers/helper.dart';

class ImagePainterShape {
  late String text;

  late Outset outset;

  late Color color;

  late double fontSize;

  late double width;

  late double height;

  late double radius;

  late double strokeWidth;

  late ImagePainterStyle style;

  late ImagePainterForm form;

  late double angle;

  late String uid;

  late bool newShape;
  ImagePainterShape({
    this.text = "",
    this.uid = "",
    this.radius = 0,
    this.angle = 0,
    this.fontSize = 20,
    this.strokeWidth = 10,
    this.newShape = true,
    this.form = ImagePainterForm.square,
    this.style = ImagePainterStyle.stroke,
  })  : outset = Outset(0, 0),
        width = 100,
        height = 100;

  ImagePainterShape.fromJson(Map<String, dynamic> json) {
    double _toDouble(num value) => value.toDouble();
    text = json["text"] ?? "";
    uid = json["uid"] ?? "";
    newShape = json["newShape"] ?? false;
    angle = _toDouble(json["angle"] ?? 0);
    radius = _toDouble(json["radius"] ?? 0);
    fontSize = _toDouble(json["fontSize"] ?? 20);
    strokeWidth = _toDouble(json["strokeWidth"] ?? 10);
    outset = Outset.fromJson(json["outset"] ?? {});
    width = _toDouble(json["width"] ?? 100);
    height = _toDouble(json["height"] ?? 100);
    // color = List<num>.from(json["color"]).toColor;
    form = GeneralHelper.getType(
      ImagePainterForm.values,
      "ImagePainterForm",
      json["form"],
    );
    style = GeneralHelper.getType(
      ImagePainterStyle.values,
      "ImagePainterStyle",
      json["style"],
    );
  }

  Map<String, dynamic> toJson({bool deep = true}) {
    final Map<String, dynamic> json = <String, dynamic>{};
    json["text"] = text;
    json["uid"] = uid;
    json["newShape"] = newShape;
    json["width"] = width;
    json["angle"] = angle;
    json["radius"] = radius;
    json["height"] = height;
    json["fontSize"] = fontSize;
    json["color"] = color.toRGBO;
    json["strokeWidth"] = strokeWidth;
    json["outset"] = outset.toJson();
    json["form"] = GeneralHelper.typeValue(form);
    json["style"] = GeneralHelper.typeValue(style);
    return json;
  }

  static List<ImagePainterShape> fromListJson(List list) =>
      list.map((shape) => ImagePainterShape.fromJson(shape)).toList();
}

class Outset {
  late double dx;

  late double dy;

  Outset(this.dx, this.dy);

  Outset.fromJson(Map<String, dynamic> json) {
    dx = json['dx'].toDouble() ?? 0;
    dy = json['dy'].toDouble() ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dx'] = dx;
    data['dy'] = dy;
    return data;
  }

  Offset toOffset() => Offset(dx, dy);
}

enum ImagePainterStyle {
  fill,
  stroke,
}

enum ImagePainterForm {
  text,
  star,
  circle,
  square,
  triangle,
  arrowLeft,
  arrowRight,
}
