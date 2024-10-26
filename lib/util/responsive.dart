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

enum BreakPoint {
  mobile(485),
  mobileLarge(
      767), // TODO(alberto): revisa que valor es el que se adapta mejor para evitar que la tarjeta se deforme
  tablet(1024),
  desktop(1024);

  const BreakPoint(this.value);
  final double value;
}

extension ResponsiveExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isMobile => screenWidth <= BreakPoint.mobile.value;
  bool get isMobileLarge => screenWidth <= BreakPoint.mobileLarge.value;
  bool get isTablet => screenWidth < BreakPoint.tablet.value;
  bool get isDesktop => screenWidth >= BreakPoint.desktop.value;
}
