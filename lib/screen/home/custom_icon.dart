import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

Future<BitmapDescriptor> createCustomMarker(String label, {Color color = Colors.orange}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final paint = Paint()..color = color;
  final radius = 25.0; // smaller circle

  // Draw circle
  canvas.drawCircle(Offset(radius, radius), radius, paint);

  // Draw text
  final textPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );
  textPainter.text = TextSpan(
    text: label,
    style: TextStyle(
      fontSize: 20, // smaller font
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  );
  textPainter.layout();
  textPainter.paint(
    canvas,
    Offset(radius - textPainter.width / 2, radius - textPainter.height / 2),
  );

  final picture = recorder.endRecording();
  final img = await picture.toImage((radius * 2).toInt(), (radius * 2).toInt());
  final data = await img.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
}
