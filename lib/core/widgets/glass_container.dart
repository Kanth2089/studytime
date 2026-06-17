import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double blur;
  final double borderRadius;
  final double borderOpacity;
  final double fillOpacity;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxBorder? customBorder;
  final AlignmentGeometry? alignment;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.blur = 15.0,
    this.borderRadius = 16.0,
    this.borderOpacity = 0.15,
    this.fillOpacity = 0.08,
    this.padding,
    this.margin,
    this.customBorder,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      alignment: alignment,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 24,
            spreadRadius: -4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: Colors.white.withValues(alpha: fillOpacity),
              border:
                  customBorder ??
                  Border.all(
                    color: Colors.white.withValues(alpha: borderOpacity),
                    width: 1.0,
                  ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: fillOpacity + 0.04),
                  Colors.white.withValues(alpha: fillOpacity / 2),
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
