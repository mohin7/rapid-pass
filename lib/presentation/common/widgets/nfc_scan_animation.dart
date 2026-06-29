import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// NFC scanning pulse animation widget.
/// Shows a central icon surrounded by expanding ripple rings.
class NfcScanAnimation extends StatefulWidget {
  const NfcScanAnimation({
    super.key,
    required this.isScanning,
    this.isSuccess = false,
    this.isError = false,
  });

  final bool isScanning;
  final bool isSuccess;
  final bool isError;

  @override
  State<NfcScanAnimation> createState() => _NfcScanAnimationState();
}

class _NfcScanAnimationState extends State<NfcScanAnimation>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rippleController1;
  late AnimationController _rippleController2;
  late AnimationController _rippleController3;
  late AnimationController _successController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _ripple1;
  late Animation<double> _ripple2;
  late Animation<double> _ripple3;
  late Animation<double> _successScale;
  late Animation<double> _successOpacity;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _rippleController1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _rippleController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _rippleController3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Stagger ripples
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _rippleController2.forward(from: 0);
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _rippleController3.forward(from: 0);
    });

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurveTween(curve: Curves.easeInOut).animate(_pulseController),
    );

    _ripple1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurveTween(curve: Curves.easeOut).animate(_rippleController1),
    );
    _ripple2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurveTween(curve: Curves.easeOut).animate(_rippleController2),
    );
    _ripple3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurveTween(curve: Curves.easeOut).animate(_rippleController3),
    );

    _successScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurveTween(curve: Curves.elasticOut).animate(_successController),
    );
    _successOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurveTween(curve: Curves.easeIn).animate(_successController),
    );
  }

  @override
  void didUpdateWidget(NfcScanAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSuccess && !oldWidget.isSuccess) {
      _pauseRipples();
      _successController.forward(from: 0);
    } else if (!widget.isScanning && oldWidget.isScanning) {
      _pauseRipples();
    } else if (widget.isScanning && !oldWidget.isScanning) {
      _resumeRipples();
    }
  }

  void _pauseRipples() {
    _pulseController.stop();
    _rippleController1.stop();
    _rippleController2.stop();
    _rippleController3.stop();
  }

  void _resumeRipples() {
    _pulseController.repeat(reverse: true);
    _rippleController1.repeat();
    _rippleController2.repeat();
    _rippleController3.repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rippleController1.dispose();
    _rippleController2.dispose();
    _rippleController3.dispose();
    _successController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isError
        ? AppColors.error
        : widget.isSuccess
            ? AppColors.success
            : AppColors.primary;

    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ripple rings (only during scan)
          if (widget.isScanning) ...[
            AnimatedBuilder(
              animation: _ripple1,
              builder: (_, __) => _Ripple(progress: _ripple1.value, color: color),
            ),
            AnimatedBuilder(
              animation: _ripple2,
              builder: (_, __) => _Ripple(progress: _ripple2.value, color: color),
            ),
            AnimatedBuilder(
              animation: _ripple3,
              builder: (_, __) => _Ripple(progress: _ripple3.value, color: color),
            ),
          ],
          // Center icon
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (_, child) {
              final scale =
                  widget.isScanning ? _pulseAnimation.value : 1.0;
              return Transform.scale(
                scale: scale,
                child: child,
              );
            },
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: widget.isSuccess
                  ? FadeTransition(
                      opacity: _successOpacity,
                      child: ScaleTransition(
                        scale: _successScale,
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    )
                  : Icon(
                      widget.isError
                          ? Icons.error_outline_rounded
                          : Icons.nfc_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Ripple extends StatelessWidget {
  const _Ripple({required this.progress, required this.color});
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88 + (112 * progress),
      height: 88 + (112 * progress),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withOpacity((1 - progress) * 0.35),
          width: 2,
        ),
      ),
    );
  }
}

/// Shimmer loading skeleton placeholder.
class LoadingSkeleton extends StatefulWidget {
  const LoadingSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  State<LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _shimmer = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurveTween(curve: Curves.easeInOut).animate(_controller),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        isDark ? AppColors.surfaceVariantDark : const Color(0xFFE8EAED);
    final highlightColor =
        isDark ? AppColors.cardDark : Colors.white;

    return AnimatedBuilder(
      animation: _shimmer,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                (_shimmer.value - 1).clamp(0.0, 1.0),
                _shimmer.value.clamp(0.0, 1.0),
                (_shimmer.value + 1).clamp(0.0, 1.0),
              ],
              colors: [baseColor, highlightColor, baseColor],
            ),
          ),
        );
      },
    );
  }
}
