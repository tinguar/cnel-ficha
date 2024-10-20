import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  const Responsive({
    super.key,
    required this.mobile,
    required this.desktop,
    this.tablet,
    this.mobileLarge,
  });

  final Widget mobile;
  final Widget? mobileLarge;
  final Widget? tablet;
  final Widget desktop;

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) return mobile;
    if (context.isMobileLarge) return mobileLarge ?? mobile;
    if (context.isTablet) return tablet ?? mobileLarge ?? mobile;
    return desktop;
  }
}

enum BreackPoints {
  mobile(400),
  mobileLarge(700),
  tablet(1024),
  desktop(1024);

  const BreackPoints(this.value);
  final double value;
}

extension ResponsiveExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isMobile => screenWidth <= BreackPoints.mobile.value;
  bool get isMobileLarge => screenWidth <= BreackPoints.mobileLarge.value;
  bool get isTablet => screenWidth < BreackPoints.tablet.value;
  bool get isDesktop => screenWidth >= BreackPoints.desktop.value;
}
