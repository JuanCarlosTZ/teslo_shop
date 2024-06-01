import 'package:flutter/material.dart';
import 'package:teslo_shop/feature/shared/widgets/geometrical_background.dart';

class CustomGeometricalView extends StatelessWidget {
  final double? headerHeight;
  final Widget header;
  final Widget body;
  const CustomGeometricalView({
    super.key,
    required this.header,
    required this.body,
    this.headerHeight,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final backgroundColor = Theme.of(context).colorScheme.background;
    final shadowSize = headerHeight ?? size.height * 0.3;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: GeometricalBackground(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: shadowSize,
                child: header,
              ),
              Container(
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(100))),
                child: body,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
