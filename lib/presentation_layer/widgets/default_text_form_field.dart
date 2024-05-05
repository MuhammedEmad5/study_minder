import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../application_layer/App_colors.dart';

class DefaultTextFormField extends StatelessWidget {
  DefaultTextFormField({
    Key? key,
    required this.controller,
    required this.inputType,
    required this.labelText,
    required this.prefixIcon,
    required this.validator,
    this.suffixIcon,
    this.suffixText,
    this.suffixPressed,
    this.readOnly = false,
    this.obscureText = false,
    this.onTap,
    this.autofocus=false,
    final double? cursorHeight, // Mark cursorHeight as final
    this.maxLines,
  })  : cursorHeight = cursorHeight ?? 16.h, // Assign a default value if null
        super(key: key);

  final TextEditingController controller;
  final TextInputType inputType;
  final String labelText;
  final IconData prefixIcon;
  final FormFieldValidator validator;

  final double cursorHeight; // Mark as final
  final bool readOnly;
  final String? suffixText;
  final VoidCallback? onTap;
  final IconData? suffixIcon;
  final VoidCallback? suffixPressed;
  final bool obscureText;
  final int? maxLines;
  final bool? autofocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: inputType,
      readOnly: readOnly,
      autofocus: autofocus!,
      cursorColor: Theme.of(context).primaryColor,
      cursorHeight: cursorHeight,
      maxLines: maxLines,
      style: Theme.of(context).textTheme.headlineSmall,
      validator: validator,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: labelText,
        suffixText: suffixText,
        suffixStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
            color: AppColors.thirdColor, fontWeight: FontWeight.w300),
        labelStyle: Theme.of(context).textTheme.titleLarge,
        prefixIcon: Icon(
          prefixIcon,
          size: 20.w,
          color: Theme.of(context).primaryColor,
        ),
        filled: true,
        fillColor:Theme.of(context).disabledColor,
        alignLabelWithHint: true,
        suffixIcon: IconButton(
          icon: Icon(suffixIcon, color: Theme.of(context).focusColor, size: 18.w),
          onPressed: suffixPressed,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 25.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.r),
          borderSide: BorderSide(color: Theme.of(context).focusColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
