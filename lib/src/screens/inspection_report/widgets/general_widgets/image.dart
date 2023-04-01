import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf_report_scope/src/core/constant/colors.dart';

image(
  Uint8List? bytes, {
  double? width,
  double? height,
  Alignment alignment = Alignment.center,
}) {
  if (bytes == null || bytes.isEmpty) return const SizedBox();
  try {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ProjectColors.firefly.withOpacity(0.15)),
        color: ProjectColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 85.0, right: 85.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image(
            image: MemoryImage(bytes),
            width: width,
            height: height,
          ),
        ),
      ),
    );
  } catch (e) {
    return const SizedBox();
  }
}
