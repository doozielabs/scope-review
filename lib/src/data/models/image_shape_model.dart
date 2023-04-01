import 'dart:typed_data';

import 'package:pdf_report_scope/src/data/models/image_painter_shape_model.dart';

class ImageShape {
  late String id;

  late String url;

  late int filesize;

  late String filetype;

  late String filename;

  late String mediatype;

  late Uint8List? bytes;

  late String localFilename;

  late List<ImagePainterShape> shapes;

  late String original;

  late bool trashed;

  late String internalId;

  late bool needSync = false;

  late int? serverTimestamp;

  late int? lastModified;

  ImageShape(
      {this.bytes,
      this.id = "",
      this.internalId = "",
      this.filesize = 0,
      this.url = "",
      this.original = "",
      this.filename = "",
      this.mediatype = "",
      this.localFilename = "",
      this.filetype = "png",
      this.trashed = false,
      this.needSync = false,
      this.serverTimestamp = 0,
      this.lastModified = 0})
      : shapes = [];

  ImageShape.fromJson(Map<dynamic, dynamic> json, {bool bits = false}) {
    id = json['id'];
    url = json['url'];
    filetype = json['filetype'];
    filesize = json['filesize'];
    filename = json['filename'];
    mediatype = json['mediatype'];
    internalId = json['internalId'] ?? "";
    lastModified = json['lastModified'] ?? 0;
    serverTimestamp = json['serverTimestamp'] ?? 0;
    localFilename = json["localfilename"] ?? "";
    trashed = json['trashed'] ?? false;
    original = json["originalImgUrl"] ?? "";
    bytes = Uint8List.fromList(bits ? json['bytes'] : []);
    shapes = ImagePainterShape.fromListJson(json['shapes'] ?? []);
    needSync = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    data['bytes'] = bytes;
    data['trashed'] = trashed;
    data['filesize'] = filesize;
    data['filetype'] = filetype;
    data['filename'] = filename;
    data['mediatype'] = mediatype;
    data['internalId'] = internalId;
    data['lastModified'] = lastModified;
    data['serverTimestamp'] = serverTimestamp;
    data["originalImgUrl"] = original;
    data['localfilename'] = localFilename;
    data['shapes'] = shapes.map((_) => _.toJson()).toList();
    return data;
  }

  update(ImageShape updatedImage) {
    id = updatedImage.id;
    internalId = updatedImage.internalId;
    filesize = updatedImage.filesize;
    url = updatedImage.url;
    original = updatedImage.original;
    filename = updatedImage.filename;
    mediatype = updatedImage.mediatype;
    localFilename = updatedImage.localFilename;
    filetype = updatedImage.filetype;
    trashed = updatedImage.trashed;
    serverTimestamp = updatedImage.serverTimestamp;
    lastModified = updatedImage.lastModified;
    shapes = updatedImage.shapes;
    bytes = Uint8List.fromList(updatedImage.bytes ?? []);
  }

  static List<ImageShape> fromListJson(List list, {bool bits = false}) =>
      List.generate(
        list.length,
        (index) => ImageShape.fromJson(list[index], bits: bits),
      );

  ImageShape get copy => ImageShape.fromJson(toJson());
}
