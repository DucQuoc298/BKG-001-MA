import 'package:flutter/material.dart';

enum AppButtonVariant {
  primary,
  secondary,
  outline,
  danger,
  ghost,
}

enum AppButtonSize {
  small,
  medium,
  large,
}

class AppButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;

  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool fullWidth;
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  final ButtonStyle? style;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const AppButton({
    super.key,
    this.text,
    this.child,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.fullWidth = true,
    this.prefixIcon,
    this.suffixIcon,
    this.style,
    this.padding,
    this.width,
    this.height,
  }) : assert(
  text != null || child != null,
  'AppButton cần có text hoặc child',
  );

  @override
  Widget build(BuildContext context) {
    final defaultStyle = _getStyle(context);
    // style truyền vào merge với default → style truyền vào được ưu tiên
    final finalStyle = style != null ? style!.merge(defaultStyle) : defaultStyle;

    return SizedBox(
      width: fullWidth ? double.infinity : width,
      height: height ?? _getHeight(),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: finalStyle,
        child: isLoading ? _buildLoading() : _buildContent(context, finalStyle),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ButtonStyle resolvedStyle) {
    if (child != null) return child!;

    // Lấy foregroundColor từ style cuối — đây là nguồn màu chữ đúng
    final foregroundColor = resolvedStyle.foregroundColor?.resolve({});
    final baseTextStyle = resolvedStyle.textStyle?.resolve({}) ?? const TextStyle();
    final finalTextStyle = baseTextStyle.copyWith(color: foregroundColor);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefixIcon != null) ...[
          Icon(prefixIcon, size: 18, color: foregroundColor),
          const SizedBox(width: 8),
        ],
        Text(text!, style: finalTextStyle),
        if (suffixIcon != null) ...[
          const SizedBox(width: 8),
          Icon(suffixIcon, size: 18, color: foregroundColor),
        ],
      ],
    );
  }

  Widget _buildLoading() {
    return const SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(
        strokeWidth: 2,
      ),
    );
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.medium:
        return 48;
      case AppButtonSize.large:
        return 56;
    }
  }

  ButtonStyle _getStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final baseShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    );

    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: padding,
          shape: baseShape,
        );

      case AppButtonVariant.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onSecondary,
          padding: padding,
          shape: baseShape,
        );

      case AppButtonVariant.danger:
        return ElevatedButton.styleFrom(
          backgroundColor: colorScheme.error,
          foregroundColor: colorScheme.onError,
          padding: padding,
          shape: baseShape,
        );

      case AppButtonVariant.outline:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.primary,
          elevation: 0,
          side: BorderSide(color: colorScheme.primary),
          padding: padding,
          shape: baseShape,
        );

      case AppButtonVariant.ghost:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.primary,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: padding,
          shape: baseShape,
        );
    }
  }
}