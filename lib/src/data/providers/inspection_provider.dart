import 'package:pdf_report_scope/src/data/models/inspection_model.dart';
import 'package:pdf_report_scope/src/data/providers/api.dart';
import 'package:pdf_report_scope/src/data/models/image_shape_model.dart';

class InspectionProvider {
  Future<dynamic> getInspection() async {
    try {
      // final response  = await Api.get("get/inspections/report/6333fadd9942f208f96c591b");
      final response = await Api.get("/inspection/6333fadd9942f208f96c591b");
      Inspection inspection = Inspection.fromJson(response.data);
      return inspection;
    } catch (e) {
      return null;
    }
  }

  Future<List<dynamic>> getPhotoByIds(Inspection report) async {
    List<ImageShape> _imageShape = [];
    try {
      var inspectionImages = report.inspectionImages;
      String s = inspectionImages.join(',');
      final mediaResponse = await Api.get("/inspection/media/$s");
      final json = mediaResponse.data as List;
      for (var image in json) {
        _imageShape.add(ImageShape.fromJson(image));
      }
      return _imageShape;
    } catch (e) {
      return [];
    }
  }
}
