import 'dart:math' show pi;

import 'package:flutter/material.dart';

class GeometricalBackground extends StatelessWidget {
  final double? height;
  final bool filled;
  final Widget child;
  const GeometricalBackground({
    super.key,
    required this.child,
    this.height,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final backgroundColor = Theme.of(context).colorScheme.surface;
    final shadowSize = height ?? size.height * 0.3;
    final shadowFinish = shadowSize + size.height * 0.2;

    return SizedBox.expand(
      child: Stack(
        children: [
          Container(
            color: Colors.black,
          ),
          const GeometricalView(),
          Positioned(
            top: shadowFinish,
            child: Container(
              height: size.height - shadowFinish,
              width: size.width,
              color: filled ? backgroundColor : Colors.transparent,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class GeometricalView extends StatelessWidget {
  const GeometricalView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final borderSize = size.width / 7;

    final int rowCount = size.height ~/ borderSize;
    Iterable<int> iterable = Iterable<int>.generate(rowCount);

    final items = <Widget>[
      Circle(borderSize: borderSize, color: Colors.white10),
      Square(borderSize: borderSize, color: Colors.white10),
      RightTriangle(borderSize: borderSize, color: Colors.white10),
      LeftTriangle(borderSize: borderSize, color: Colors.white10),
      Diamond(borderSize: borderSize, color: Colors.white10),
      _SemiCircle(borderSize: borderSize, color: Colors.white10),
      _SemiCircleInverted(borderSize: borderSize, color: Colors.white10),
    ];

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...iterable.map((_) => ShapeRow(shapeWidgets: items)),
        ],
      ),
    );
  }
}

/// El objetivo de este widget es crear una final de figuras geometricas
/// Es Stateful porque quiero mantener el estado del mismo
/// El initState rompe la referencia para que lo pueda usar en varios lugares
class ShapeRow extends StatefulWidget {
  const ShapeRow({
    super.key,
    required this.shapeWidgets,
  });

  final List<Widget> shapeWidgets;

  @override
  State<ShapeRow> createState() => _ShapeRowState();
}

class _ShapeRowState extends State<ShapeRow> {
  late List<Widget> shapeMixedUp;

  @override
  void initState() {
    super.initState();
    shapeMixedUp = [...widget.shapeWidgets];
    shapeMixedUp.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: shapeMixedUp);
  }
}

class Circle extends StatelessWidget {
  final double borderSize;
  final Color color;
  const Circle({
    super.key,
    required this.borderSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: borderSize,
      width: borderSize,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(100), color: color),
    );
  }
}

class Square extends StatelessWidget {
  final double borderSize;
  final Color color;
  const Square({
    super.key,
    required this.borderSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: borderSize,
      width: borderSize,
      color: color,
    );
  }
}

class RightTriangle extends StatelessWidget {
  final double borderSize;
  final Color color;
  const RightTriangle({
    super.key,
    required this.borderSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(borderSize, borderSize),
      painter: RightTrianglePainter(borderSize: borderSize, color: color),
    );
  }
}

class RightTrianglePainter extends CustomPainter {
  final double borderSize;
  final Color color;

  RightTrianglePainter({
    super.repaint,
    required this.borderSize,
    required this.color,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path
      ..lineTo(size.width, 0)
      ..lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(RightTrianglePainter oldDelegate) => false;
}

class LeftTriangle extends StatelessWidget {
  final double borderSize;
  final Color color;
  const LeftTriangle({
    super.key,
    required this.borderSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(borderSize, borderSize),
      painter: LeftTrianglePainter(borderSize: borderSize, color: color),
    );
  }
}

class LeftTrianglePainter extends CustomPainter {
  final double borderSize;
  final Color color;

  LeftTrianglePainter({
    super.repaint,
    required this.borderSize,
    required this.color,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path
      ..moveTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(LeftTrianglePainter oldDelegate) => false;
}

class Diamond extends StatelessWidget {
  final double borderSize;
  final Color color;
  const Diamond({
    super.key,
    required this.borderSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(borderSize, borderSize),
      painter: DiamondPainter(borderSize: borderSize, color: color),
    );
  }
}

class DiamondPainter extends CustomPainter {
  final double borderSize;
  final Color color;

  DiamondPainter({
    super.repaint,
    required this.borderSize,
    required this.color,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height / 2)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, size.height / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(DiamondPainter oldDelegate) => false;
}

class _SemiCircle extends StatelessWidget {
  final double borderSize;
  final Color color;

  const _SemiCircle({
    required this.borderSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: borderSize,
      height: borderSize,
      child: CustomPaint(
        painter: _SemiCirclePainter(borderSize: borderSize, color: color),
      ),
    );
  }
}

class _SemiCirclePainter extends CustomPainter {
  final double borderSize;
  final Color color;

  _SemiCirclePainter({required this.borderSize, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rect = Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        width: size.width,
        height: size.height);

    canvas.drawArc(
      rect,
      pi,
      pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_SemiCirclePainter oldDelegate) => false;
}

class _SemiCircleInverted extends StatelessWidget {
  final double borderSize;
  final Color color;

  const _SemiCircleInverted({
    required this.borderSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: borderSize,
      height: borderSize,
      child: CustomPaint(
        painter:
            _SemiCircleInvertedPainter(borderSize: borderSize, color: color),
      ),
    );
  }
}

class _SemiCircleInvertedPainter extends CustomPainter {
  final double borderSize;
  final Color color;

  _SemiCircleInvertedPainter({required this.borderSize, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rect = Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        width: size.width,
        height: size.height);

    canvas.drawArc(
      rect,
      0,
      pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_SemiCircleInvertedPainter oldDelegate) => false;
}
