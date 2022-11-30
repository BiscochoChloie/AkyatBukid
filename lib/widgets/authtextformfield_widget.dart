import 'package:akyatbukid/constant/colors.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';

class AuthTextFormFieldWidget extends StatelessWidget {
  final String label;
  final Color colorFill;
  final double radius;
  final bool isObscure;
  final Widget? suffixIcon;
  final TextEditingController? textFieldController;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final double labelfontSize;
  final int maxLines;
  final String? hintText;
  final Key? formKey;
  final bool isEmail;
  final bool? enabled;
  final TextEditingController? emailController;
  final double borderRadius;
  final TextInputType? keyboardType;

  final void Function(String)? onChanged;

  const AuthTextFormFieldWidget(
      {super.key,
      required this.label,
      this.emailController,
      this.borderRadius = 5,
      this.isEmail = false,
      this.formKey,
      this.onChanged,
      this.enabled,
      this.maxLines = 1,
      this.hintText,
      this.labelfontSize = 14.0,
      this.radius = 10,
      this.floatingLabelBehavior,
      this.suffixIcon,
      this.colorFill = Colors.white,
      this.isObscure = false,
      this.textFieldController,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    // final emailExp =
    //     RegExp(r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)');
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius))),
      child: TextFormField(
        keyboardType: TextInputType.text,
        maxLines: maxLines,
        obscureText: isObscure,
        controller: textFieldController,
        enabled: enabled,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.black),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          // else if (emailExp.hasMatch(value) == false) {
          //   return 'Invalid Email';
          // }

          return null;
        },
        decoration: InputDecoration(
          errorStyle: const TextStyle(color: Colors.red),
          hintText: hintText,
          floatingLabelStyle: GoogleFonts.poppins(color: CustomColors.primary),
          hintStyle: const TextStyle(color: Colors.black),
          suffixIcon: suffixIcon,
          fillColor: colorFill,
          filled: true,
          labelText: label,
          floatingLabelBehavior: floatingLabelBehavior,
          labelStyle: TextStyle(
            color: Colors.grey,
            fontSize: labelfontSize,
          ),
        ),
      ),
    );
  }
}
