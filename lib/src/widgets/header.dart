import 'package:flutter/material.dart';

class HeaderOla extends StatelessWidget {
  const HeaderOla({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: CustomPaint(
        painter: _HeaderOlaPainter(),
      ),
    );
  }
}

class _HeaderOlaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final paint2 = Paint();

    // PROPIEDADES
    paint.color = Color(0xffB7B0E8);
    paint.style = PaintingStyle.fill; // .fill .stroke
    paint.strokeWidth = 20;

    // PROPIEDADES
    paint2.color = Color(0xffC5C0EC);
    paint2.style = PaintingStyle.fill; // .fill .stroke
    paint2.strokeWidth = 20;

    final path = new Path();

    // Dibujar con el path y el lapiz
    path.lineTo(0, size.height * 0.1);
    path.quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.37, //ola
        size.width,
        size.height * 0.1);
    path.lineTo(size.width, 0);
    canvas.drawPath(path, paint);

    final path2 = new Path();

    // Dibujar con el path y el lapiz
    path2.lineTo(0, size.height * 0.05);
    path2.quadraticBezierTo(
        size.width * 0.30,
        size.height * 0.25, //ola 2
        size.width,
        size.height * 0.05);
    path2.lineTo(size.width, 0);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
