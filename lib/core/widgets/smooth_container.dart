import 'package:flutter/material.dart';
import 'package:smooth_corner/smooth_corner.dart';
import '../utils/haptic_util.dart';

class SmoothContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final BorderRadiusGeometry borderRadius;
  final double smoothness;
  final BorderSide side;
  final List<BoxShadow>? shadows;
  final AlignmentGeometry? alignment;

  const SmoothContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius = const BorderRadius.all(Radius.circular(16.0)),
    this.smoothness = 1.0,
    this.side = BorderSide.none,
    this.shadows,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      alignment: alignment,
      decoration: ShapeDecoration(
        color: color,
        shadows: shadows,
        shape: SmoothRectangleBorder(
          borderRadius: borderRadius,
          smoothness: smoothness,
          side: side,
        ),
      ),
      child: child,
    );
  }
}

/// Helper to get a ShapeBorder for buttons/FABs
ShapeBorder smoothShape({
  BorderRadiusGeometry borderRadius = const BorderRadius.all(
    Radius.circular(16.0),
  ),
  double smoothness = 1.0,
  BorderSide side = BorderSide.none,
}) {
  return SmoothRectangleBorder(
    borderRadius: borderRadius,
    smoothness: smoothness,
    side: side,
  );
}

class SmoothButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final BorderRadiusGeometry borderRadius;
  final BorderSide side;

  const SmoothButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.elevation,
    this.borderRadius = const BorderRadius.all(Radius.circular(16.0)),
    this.side = BorderSide.none,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.primary;
    final fg = foregroundColor ?? theme.colorScheme.onPrimary;

    return Material(
      color: bg,
      elevation: elevation ?? 0,
      shape: SmoothRectangleBorder(
        borderRadius: borderRadius,
        smoothness: 1,
        side: side,
      ),
      child: InkWell(
        onTap: onPressed == null
            ? null
            : () {
                HapticUtil.feedback();
                onPressed!();
              },
        customBorder: SmoothRectangleBorder(
          borderRadius: borderRadius,
          smoothness: 1,
          side: side,
        ),
        child: Padding(
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: DefaultTextStyle(
            style:
                theme.textTheme.labelLarge?.copyWith(color: fg) ??
                TextStyle(color: fg),
            child: child,
          ),
        ),
      ),
    );
  }
}
