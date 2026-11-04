
import 'package:flutter/material.dart';

@immutable
class AppCustomColors extends ThemeExtension<AppCustomColors> {
  const AppCustomColors({
    required this.warningTint,
    required this.warningBorder,
    required this.warningText,
    required this.successTint,
    required this.successBorder,
    required this.successText,
    required this.errorTint,
    required this.errorText,
    required this.greyTint,
  });

  final Color warningTint;
  final Color warningBorder;
  final Color warningText;

  final Color successTint;
  final Color successBorder;
  final Color successText;

  final Color errorTint;
  final Color errorText;

  final Color greyTint;

  @override
  AppCustomColors copyWith({
    Color? warningTint,
    Color? warningBorder,
    Color? warningText,
    Color? successTint,
    Color? successBorder,
    Color? successText,
    Color? errorTint,
    Color? errorText,
    Color? greyTint,
  }) {
    return AppCustomColors(
      warningTint: warningTint ?? this.warningTint,
      warningBorder: warningBorder ?? this.warningBorder,
      warningText: warningText ?? this.warningText,
      successTint: successTint ?? this.successTint,
      successBorder: successBorder ?? this.successBorder,
      successText: successText ?? this.successText,
      errorTint: errorTint ?? this.errorTint,
      errorText: errorText ?? this.errorText,
      greyTint: greyTint ?? this.greyTint,
    );
  }

  @override
  AppCustomColors lerp(
    covariant AppCustomColors? other,
    double t,
  ) {
    if (other == null) return this;

    return AppCustomColors(
      warningTint: Color.lerp(warningTint, other.warningTint, t)!,
      warningBorder: Color.lerp(warningBorder, other.warningBorder, t)!,
      warningText: Color.lerp(warningText, other.warningText, t)!,
      successTint: Color.lerp(successTint, other.successTint, t)!,
      successBorder: Color.lerp(successBorder, other.successBorder, t)!,
      successText: Color.lerp(successText, other.successText, t)!,
      errorTint: Color.lerp(errorTint, other.errorTint, t)!,
      errorText: Color.lerp(errorText, other.errorText, t)!,
      greyTint: Color.lerp(greyTint, other.greyTint, t)!,
    );
  }
}
