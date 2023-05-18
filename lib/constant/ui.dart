import 'package:flutter/material.dart';

Color cRed = const Color(0xffBE344B);
Color cRedDark = const Color(0xff95051D);
Color green = const Color(0xff00897B);
Color lightGreen = const Color(0xffE8F5E9);
Color darkGreen = const Color(0xff00796B);

//Standard Size of UI
double dSpace_4 = 4;
double dSpace_8 = 8;
double dSpace_16 = 16;
double dSpace_32 = 32;

dynamic cGradientDefault =const LinearGradient(colors: [
  Color(0xff522C5F),
  Color(0xffC82A4C),
],transform: GradientRotation(0.8));

//IconSize
Widget icons_48(Widget icon) {
  return Container(
    decoration: const BoxDecoration(
      // border: Border.all(color: C_red,width: 1)
    ),
    height: 48,
    width: 48,
    child: Center(child: icon),
  );
}

Widget icons_40(Widget icon) {
  return Container(
    decoration: const BoxDecoration(
      // border: Border.all(color: C_red,width: 1)
    ),
    height: 40,
    width: 40,
    child: Center(child: icon),
  );
}

Widget icons_24(Widget icon) {
  return Container(
    decoration: const BoxDecoration(
      // border: Border.all(color: C_red,width: 1)
    ),
    height: 24,
    width: 24,
    child: Center(child: icon),
  );
}

Widget icons_16(Widget icon) {
  return Container(
    decoration: const BoxDecoration(
      // border: Border.all(color: C_red,width: 1)
    ),
    height: 16,
    width: 16,
    child: Center(child: icon),
  );
}

const dShadowBox = BoxShadow(
  color: Color.fromARGB(65, 58, 73, 92),
  spreadRadius: 0,
  blurRadius: 12,
  offset: Offset(0, 4),
);
