import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

// 커스텀 텍스트 필드 위젯
class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final bool obscureText;
  final int? maxLength;
  final int? maxLines;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.obscureText = false,
    this.maxLength,
    this.maxLines = 1,
    this.validator,
    this.onChanged,
    this.inputFormatters,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLength: maxLength,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      style: TextStyle(
        fontSize: AppConstants.mediumFontSize,
        color: Color(AppConstants.textColorHex),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: Color(AppConstants.grayColorHex),
                size: 20,
              )
            : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(
                  suffixIcon,
                  color: Color(AppConstants.grayColorHex),
                  size: 20,
                ),
                onPressed: onSuffixIconPressed,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Color(AppConstants.grayColorHex),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Color(AppConstants.grayColorHex),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Color(AppConstants.primaryColorHex),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppConstants.mediumPadding,
          vertical: AppConstants.mediumPadding,
        ),
        hintStyle: TextStyle(
          color: Color(AppConstants.grayColorHex),
          fontSize: AppConstants.mediumFontSize,
        ),
        labelStyle: TextStyle(
          color: Color(AppConstants.grayColorHex),
          fontSize: AppConstants.mediumFontSize,
        ),
        errorStyle: TextStyle(
          color: Colors.red,
          fontSize: AppConstants.smallFontSize,
        ),
        counterStyle: TextStyle(
          color: Color(AppConstants.grayColorHex),
          fontSize: AppConstants.smallFontSize,
        ),
      ),
    );
  }
}
