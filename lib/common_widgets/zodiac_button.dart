import 'package:flutter/material.dart';

class ZodiacButton extends StatelessWidget {
  final Function()? onPressed;
  final Function()? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip clipBehavior;
  final MaterialStatesController? statesController;
  final Widget? child;
  final Size? size;
  final Color? backgroundColor;
  final Color? textColor;
  const ZodiacButton(
      {super.key,
      required this.onPressed,
      this.onLongPress,
      this.onHover,
      this.onFocusChange,
      this.size,
      this.style,
      this.focusNode,
      this.autofocus = false,
      this.clipBehavior = Clip.none,
      this.statesController,
      required this.child,
      this.backgroundColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: this.onPressed,
      child: this.child,
      style: this.style == null
          ? ElevatedButton.styleFrom(
              backgroundColor: backgroundColor ?? Colors.blue[800],
              foregroundColor: textColor ?? Colors.white,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              fixedSize: this.size == null ? Size(342, 64) : this.size,
            )
          : this.style,
      onHover: this.onHover,
      onFocusChange: this.onFocusChange,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
      clipBehavior: this.clipBehavior,
      statesController: this.statesController,
    );
  }
}
