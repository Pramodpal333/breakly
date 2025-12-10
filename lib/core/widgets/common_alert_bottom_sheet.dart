import 'package:breakly/core/theme/app_text_styles.dart';
import 'package:breakly/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import '../../core/theme/app_colors.dart';
import 'smooth_container.dart';

class CommonAlertBottomSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final String okayText;
  final String cancelText;
  final VoidCallback onOkay;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final Widget? icon;

  const CommonAlertBottomSheet({
    super.key,
    required this.title,
    required this.subtitle,
    this.okayText = "Okay",
    this.cancelText = "Cancel",
    required this.onOkay,
    this.onCancel,
    this.isDestructive = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = isDestructive
        ? AppColors.error
        : theme.colorScheme.primary;

    return SmoothContainer(
      color: theme.colorScheme.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Gap(40),

          // Icon
          if (icon != null || true) ...[
            icon != null
                ? IconTheme(
                    data: IconThemeData(color: primaryColor, size: 90),
                    child: icon!,
                  )
                : SvgPicture.asset(
                    Assets.icons.alertRedIcon,
                    width: 90,
                    height: 90,
                    colorFilter: ColorFilter.mode(
                      primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
            const Gap(24),
          ],

          // Title
          Text(
            title,
            style: AppTextStyles.displaySmall.medium,
            textAlign: TextAlign.center,
          ),
          const Gap(16),

          // Subtitle
          Text(
            subtitle,
            style: AppTextStyles.bodyLarge.regular,
            textAlign: TextAlign.center,
          ),
          const Gap(48),

          // Buttons
          Row(
            children: [
              // Cancel Button (Outlined)
              Expanded(
                child: SmoothButton(
                  onPressed: () {
                    if (onCancel != null) {
                      onCancel!();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  backgroundColor: Colors.transparent,
                  foregroundColor: theme.colorScheme.onSurface,
                  side: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: .3),
                  ),
                  elevation: 0,
                  borderRadius: BorderRadius.circular(20),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      cancelText,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const Gap(16),

              // Okay Button (Filled or Outlined? User said "make buttons outlined", but usually primary is filled.
              // Assuming user wants *both* outlined or maybe just secondary.
              // Let's make secondary outlined and primary filled for better UX/Aesthetics,
              // UNLESS user specifically meant "I want the outlined style for ALL buttons".
              // Given "Make buttons outlined", let's try making the primary one outlined too but with thicker border or color fill?
              // Actually, standard aesthetic is usually one filled one outlined. If I make both outlined it might look weak.
              // Let's stick to standard aesthetic: Secondary Outlined, Primary Filled. User might have meant "make buttons" referring to the general button style in the app or just the cancel one.
              // WAIT, "make buttons outlined" plural. Okay, I will make BOTH outlined as requested.)
              Expanded(
                child: SmoothButton(
                  onPressed: onOkay,
                  backgroundColor: Colors.transparent,
                  foregroundColor: primaryColor,
                  side: BorderSide(color: primaryColor, width: 2),
                  elevation: 0,
                  borderRadius: BorderRadius.circular(20),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      okayText,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Gap(40), // Bottom safe area spacing
        ],
      ),
    );
  }
}
