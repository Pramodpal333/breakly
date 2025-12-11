import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:breakly/core/theme/app_colors.dart';
import 'package:breakly/core/theme/app_text_styles.dart';

class SecurityAlertScreen extends StatefulWidget {
  const SecurityAlertScreen({super.key});

  @override
  State<SecurityAlertScreen> createState() => _SecurityAlertScreenState();
}

class _SecurityAlertScreenState extends State<SecurityAlertScreen>
    with SingleTickerProviderStateMixin {
  int _countdown = 10;
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _startTimer();

    // Setup pulse animation for the icon
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
        _exitApp();
      }
    });
  }

  void _exitApp() {
    exit(0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.error2, // Dark red
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Pulsing Warning Icon
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.error.withValues(alpha: 0.4),
                          blurRadius: 32,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.gpp_bad_rounded,
                      color: AppColors.error,
                      size: 80,
                    ),
                  ),
                ),
                const Gap(40),
                // Title
                Text(
                  'Security Alert',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(16),
                // Description
                Text(
                  'Unofficial installation detected.\nFor your security, this app is only supported when downloaded from the Play Store or App Store.',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white70,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                // Countdown
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    children: [
                      Text(
                        'Closing in',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white54,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        '00:${_countdown.toString().padLeft(2, '0')}',
                        style: AppTextStyles.displayMedium.copyWith(
                          color: Colors.white,
                          fontSize: 48,
                          fontFeatures: [const FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
