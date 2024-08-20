import 'package:flutter/material.dart';

class ChatBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color.fromARGB(255, 255, 221, 182);
    final path = Path();

    // 말풍선 모양 그리기
    path.moveTo(10, 0);
    path.lineTo(size.width - 10, 0);
    path.arcToPoint(Offset(size.width, 10),
        radius: const Radius.circular(10), clockwise: true);
    path.lineTo(size.width, size.height - 10);
    path.arcToPoint(Offset(size.width - 10, size.height),
        radius: const Radius.circular(10), clockwise: true);
    path.lineTo(size.width / 2 + 10, size.height);
    path.lineTo(size.width / 2, size.height + 10);
    path.lineTo(size.width / 2 - 10, size.height);
    path.lineTo(10, size.height);
    path.arcToPoint(Offset(0, size.height - 10),
        radius: const Radius.circular(10), clockwise: true);
    path.lineTo(0, 10);
    path.arcToPoint(const Offset(10, 0),
        radius: const Radius.circular(10), clockwise: true);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
