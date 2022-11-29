import 'package:akyatbukid/constant/colors.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';

class TextWidget extends StatelessWidget {
  final TextAlign? textAlign;
  final String text;
  final double fontSize;
  final Color color;
  final TextDecoration? decoration;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;
  final Function()? onTap;

  const TextWidget({
    super.key,
    this.textAlign,
    this.fontWeight = FontWeight.normal,
    this.onTap,
    this.overflow,
    this.color = Colors.black,
    this.fontSize = 13,
    required this.text,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        overflow: overflow,
        textAlign: textAlign,
        style: GoogleFonts.nunito(
            fontWeight: fontWeight,
            color: color,
            fontSize: fontSize,
            decoration: decoration),
      ),
    );
  }
}

class TextWithButton extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  const TextWithButton(
      {super.key,
      required this.text,
      required this.color,
      required this.icon,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: CustomColors.primary,
      onTap: onTap,
      child: Ink(
        color: Colors.transparent,
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
            ),
            const SizedBox(
              width: 10,
            ),
            TextWidget(color: color, fontSize: 14, text: text)
          ],
        ),
      ),
    );
  }
}
