import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

enum ButtonVariant { primary, secondary, danger, ghost }

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonVariant variant;
  final bool isLoading;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.height = 52,
  });

  /// Convenience constructors
  const CustomButton.danger({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.height = 52,
  }) : variant = ButtonVariant.danger;

  const CustomButton.ghost({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.height = 52,
  }) : variant = ButtonVariant.ghost;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim = _scaleController;
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  Color get _bgColor {
    switch (widget.variant) {
      case ButtonVariant.primary:   return AppColors.primary;
      case ButtonVariant.secondary: return AppColors.charcoal;
      case ButtonVariant.danger:    return const Color(0xFFB71C1C);
      case ButtonVariant.ghost:     return Colors.transparent;
    }
  }

  Color get _fgColor {
    if (widget.variant == ButtonVariant.ghost) return AppColors.primary;
    return AppColors.white;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:    (_) => _scaleController.reverse(),
      onTapUp:      (_) => _scaleController.forward(),
      onTapCancel:  ()  => _scaleController.forward(),
      onTap: widget.isLoading || widget.onPressed == null
          ? null
          : widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (_, child) =>
            Transform.scale(scale: _scaleAnim.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.onPressed == null
                ? AppColors.grey
                : _bgColor,
            borderRadius: BorderRadius.circular(14),
            border: widget.variant == ButtonVariant.ghost
                ? Border.all(color: AppColors.primary, width: 1.5)
                : null,
            boxShadow: widget.variant == ButtonVariant.ghost ||
                    widget.onPressed == null
                ? []
                : [
                    BoxShadow(
                      color: _bgColor.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: _fgColor,
                    strokeWidth: 2.5,
                  ),
                )
              else ...[
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: _fgColor, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.text,
                  style: TextStyle(
                    color: _fgColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}