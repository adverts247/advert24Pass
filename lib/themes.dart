import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class themes {
  Color primaryColor = const Color(0xff3180E7);
  Color secondaryColor = const Color(0xff181336);
  Color tetiaryColor = const Color(0xff899a9a);
  Color darkerGreyColor = const Color.fromARGB(255, 81, 91, 111);
  Color backgroundColor = Colors.white;
  // Color appBarColor = const Color.fromARGB(255, 238, 242, 247);
  Color whiteColor = Colors.white;
  Color blackColor = Colors.black;
  Color blueColor = const Color(0xff6C6AEB);
  Color greyText = const Color.fromARGB(171, 50, 71, 92);
  Color cardColor = const Color(0xff282C4A);
  Color pinkColor = const Color(0xffFF6E91);

  Color appBarColor = const Color(0xffEEF2F7);
  Color yellowColor = const Color(0xffF09654);
  // Color lightBlueColor = const Color.fromARGB(255, 212, 235, 235);
}

class TextStyles {
  TextStyle DefaultText(final double? fontSize, final FontWeight? weight,
          final Color color) =>
      GoogleFonts.manrope(
        color: color,
        fontWeight: weight ?? FontWeight.w500,
        fontSize: fontSize ?? 19,
      );

  //Blue Text

  TextStyle whiteTextStyle() => GoogleFonts.manrope(
        color: themes().whiteColor,
        fontWeight: FontWeight.w300,
        fontSize: 17,
      );

  TextStyle greyTextStyle() => GoogleFonts.manrope(
        color: themes().greyText,
        fontWeight: FontWeight.w300,
        fontSize: 14,
      );

  TextStyle purpleTextStyle() {
    return GoogleFonts.manrope(
      color: themes().tetiaryColor,
      fontWeight: FontWeight.w500,
      fontSize: 16,
    );
  }

  //Black style

  TextStyle blackTextStyle400() {
    return GoogleFonts.manrope(
      color: themes().secondaryColor,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );
  }

  TextStyle blackTextStyle700() {
    return GoogleFonts.manrope(
      color: themes().secondaryColor,
      fontWeight: FontWeight.w700,
      fontSize: 19,
    );
  }

  //Grey

  TextStyle greyTextStyle400() {
    return GoogleFonts.manrope(
      color: themes().tetiaryColor,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );
  }

  TextStyle greyTextStyle700() {
    return GoogleFonts.manrope(
      color: themes().tetiaryColor,
      fontWeight: FontWeight.w700,
      fontSize: 14,
    );
  }

  TextStyle darkGreyTextStyle400() {
    return GoogleFonts.manrope(
      color: themes().darkerGreyColor,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );
  }

  TextStyle darkGreyTextStyle700() {
    return GoogleFonts.manrope(
      color: themes().darkerGreyColor,
      fontWeight: FontWeight.w700,
      fontSize: 14,
    );
  }

  TextStyle redTextStyle() {
    return GoogleFonts.manrope(
      color: Colors.red,
      fontWeight: FontWeight.w700,
      fontSize: 16,
    );
  }
}
