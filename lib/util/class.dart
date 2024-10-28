import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';

class ColorStyle {
  static Color backgroundBlack = const Color(0xff272e3f);
  static Color background = const Color(0xfff3efff);
  static Color colorGrey = const Color(0xff7f8c9f);
  static Color colorBlue = const Color(0xff2196f3);
  static Color backgroundOrange = const Color(0xfff37474);
}

class ColorPdf {
  static const colorBlack = PdfColor.fromInt(0xff272e3f);
}

class DecorationStyle {
  static BoxDecoration greyBorder({Color? color}) {
    return BoxDecoration(
      color: color ?? Colors.transparent,
      border: Border.all(color: color ?? ColorStyle.colorGrey),
      borderRadius: BorderRadius.circular(5),
    );
  }
}

class TextStyleS {
  static TextStyle textGlobal({
    fontSize,
    color,
    fontWeight,
    decoration,
    decorationThickness,
    decorationColor,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 17,
      color: color ?? ColorStyle.backgroundBlack,
      fontWeight: fontWeight ?? FontWeight.w200,
      decoration: decoration ?? TextDecoration.none,
      decorationThickness: decorationThickness ?? 0.0,
      decorationColor: decorationColor ?? Colors.transparent,
    );
  }

  static TextStyle textLink({TextDecoration? decoration, double? fontSize}) {
    return TextStyle(
      color: ColorStyle.colorBlue,
      fontWeight: FontWeight.bold,
      fontSize: fontSize ?? 16,
      decoration: decoration ?? TextDecoration.underline,
    );
  }
}
