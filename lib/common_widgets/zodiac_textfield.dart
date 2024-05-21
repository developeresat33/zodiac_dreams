import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ZodiacTextField extends StatelessWidget {
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool readOnly;
  final ToolbarOptions? toolbarOptions;
  final showCursor;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final enabled;
  final GestureTapCallback? onTap;
  final bool autoFocus;

  const ZodiacTextField(
      {super.key,
      this.suffixIcon,
      this.controller,
      this.focusNode,
      this.decoration,
      this.keyboardType,
      this.textInputAction,
      this.style,
      this.strutStyle,
      this.textAlign = TextAlign.start,
      this.textAlignVertical,
      this.textDirection,
      this.readOnly = false,
      this.toolbarOptions,
      this.showCursor,
      this.maxLines = 1,
      this.minLines,
      this.maxLength,
      this.maxLengthEnforcement,
      this.onChanged,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.inputFormatters,
      this.enabled,
      this.onTap,
      this.autovalidateMode,
      this.validator,
      this.obscureText = false,
      this.prefixIcon,
      this.autoFocus = false,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: this.autoFocus,
      keyboardType: this.keyboardType,
      textInputAction: this.textInputAction,
      controller: this.controller,
      focusNode: this.focusNode,
      onTap: this.onTap,
      enabled: this.enabled,
      inputFormatters: this.inputFormatters,
      onFieldSubmitted: this.onFieldSubmitted,
      onEditingComplete: this.onEditingComplete,
      onChanged: this.onChanged,
      maxLengthEnforcement: this.maxLengthEnforcement,
      maxLength: this.maxLength,
      minLines: this.minLines,
      maxLines: this.maxLines,
      showCursor: this.showCursor,
      // ignore: deprecated_member_use
      toolbarOptions: this.toolbarOptions,
      readOnly: this.readOnly,
      textDirection: this.textDirection,
      textAlignVertical: this.textAlignVertical,
      textAlign: this.textAlign,
      strutStyle: this.strutStyle,

      style: this.style ??
          TextStyle(
            fontSize: 16,
          ),
      obscureText: this.obscureText,
      decoration: decoration == null
          ? InputDecoration(
              filled: true,
              fillColor: Color.fromRGBO(30, 33, 37, 1),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 0.3,
                      color: Colors.blue[800]!,
                      style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              disabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.redAccent, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.redAccent, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              labelText: this.hintText,
              labelStyle: TextStyle(
                  fontSize: 14,
                  overflow: TextOverflow.clip,
                  color: Colors.white.withOpacity(0.7)),
              suffixIcon: this.suffixIcon,
              hintText: this.hintText,
              hintStyle: TextStyle(
                fontSize: 16,
                overflow: TextOverflow.clip,
                color: Colors.white,
              ),
              prefixIcon: this.prefixIcon ?? null,
            )
          : this.decoration,

      validator: this.validator,
    );
  }
}
