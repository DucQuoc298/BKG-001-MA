import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final String? errorText;

  final Widget? prefix;
  final Widget? suffix;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;

  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final TextStyle? style;
  final InputDecoration? decoration;

  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.errorText,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onTap,
    this.validator,
    this.style,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final defaultDecoration = InputDecoration(
      labelText: label,
      hintText: hintText,
      errorText: errorText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      prefix: prefix,
      suffixIcon: _buildSuffixIcon(),
      suffix: suffix,
    );

    return TextFormField(
      controller: controller,
      enabled: enabled,
      readOnly: readOnly,
      obscureText: obscureText,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onTap: onTap,
      validator: validator,
      style: style,
      decoration: defaultDecoration.copyWith(
        labelText: decoration?.labelText ?? defaultDecoration.labelText,
        hintText: decoration?.hintText ?? defaultDecoration.hintText,
        errorText: decoration?.errorText ?? defaultDecoration.errorText,
        prefixIcon: decoration?.prefixIcon ?? defaultDecoration.prefixIcon,
        suffixIcon: decoration?.suffixIcon ?? defaultDecoration.suffixIcon,
        filled: decoration?.filled,
        fillColor: decoration?.fillColor,
        border: decoration?.border,
        enabledBorder: decoration?.enabledBorder,
        focusedBorder: decoration?.focusedBorder,
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (suffixIcon == null) return null;

    return IconButton(
      onPressed: onSuffixTap,
      icon: Icon(suffixIcon),
    );
  }
}