import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tms/src/common/constants/color_constant.dart';
import 'package:tms/src/common/constants/text_styles.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class NvTextField extends StatefulWidget {
  const NvTextField({
    super.key,
    this.placeholder = '',
    this.labelText = '',
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.onChanged,
    this.borderColor,
    this.enableBorderColor,
    this.labelStyle,
    this.placeholderStyle,
    this.inputFormatters,
    this.textInputType,
    this.backgroundColor = AppColors.white,
    this.isExpanded = false,
    this.focusNode,
    this.textAlign,
    this.borderRadius = 10,
    this.labelTop = false,
    this.padding,
    this.hasError = false,
    this.readOnly = false,
    this.maxLength,
    this.isPhone = false,
    this.onSubmitted,
  });

  final String placeholder;
  final String labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Color? borderColor;
  final Color? enableBorderColor;
  final TextStyle? labelStyle;
  final TextStyle? placeholderStyle;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? textInputType;
  final Color? backgroundColor;
  final bool isExpanded;
  final bool labelTop;
  final FocusNode? focusNode;
  final TextAlign? textAlign;
  final double? borderRadius;
  final EdgeInsets? padding;
  final bool hasError;
  final bool readOnly;
  final int? maxLength;
  final bool isPhone;
  final ValueChanged<String>? onSubmitted;

  @override
  State<NvTextField> createState() => _NvTextFieldState();
}

class _NvTextFieldState extends State<NvTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isEmpty = true;
  bool _isFocused = false;
  late MaskTextInputFormatter _phoneMask;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_updateLabelVisibility);
    _isEmpty = _controller.text.isEmpty;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);

    if (widget.isPhone) {
      _phoneMask = MaskTextInputFormatter(
        mask: '+7 (###) ### ## ##',
        filter: {"#": RegExp(r'[0-9]')},
      );
    }
  }

  void _updateLabelVisibility() {
    setState(() {
      _isEmpty = _controller.text.isEmpty;
    });
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_updateLabelVisibility);
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  OutlineInputBorder _outlineBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 15),
      borderSide: BorderSide(color: color, width: 1.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isExpanded = widget.isExpanded;
    final Color borderColor = widget.borderColor ?? AppColors.grey;
    final Color backgroundColor = widget.backgroundColor ?? Colors.white;
    final Color focusedBorderColor =
        widget.hasError
            ? Colors.red
            : (_isFocused ? AppColors.green : borderColor);

    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 15),
        border: Border.all(
          color: isExpanded ? AppColors.grey : AppColors.white,
          width: 1,
        ),
      ),
      child: TextFormField(
        maxLength: widget.maxLength,
        readOnly: widget.readOnly,
        controller: _controller,
        focusNode: _focusNode,
        keyboardType: widget.textInputType,
        inputFormatters: widget.isPhone ? [_phoneMask] : widget.inputFormatters,
        validator: widget.validator,
        obscureText: widget.obscureText,
        onChanged: (text) {
          widget.onChanged?.call(text);
          _updateLabelVisibility();
        },
        onFieldSubmitted: widget.onSubmitted,
        textAlign: widget.textAlign ?? TextAlign.left,
        textAlignVertical:
            isExpanded ? TextAlignVertical.top : TextAlignVertical.center,
        minLines: isExpanded ? 5 : 1,
        maxLines: isExpanded ? null : 1,
        decoration: InputDecoration(
          counterText: '',
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          filled: true,
          fillColor: backgroundColor,
          hintText: widget.placeholder,
          hintStyle:
              widget.placeholderStyle ??
              TextStyles.bodyMedium.copyWith(color: Colors.grey),
          labelText: widget.labelTop ? widget.labelText : null,
          labelStyle:
              widget.labelStyle ?? const TextStyle(color: AppColors.grey),
          floatingLabelBehavior:
              widget.labelTop
                  ? FloatingLabelBehavior.auto
                  : FloatingLabelBehavior.never,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          border: _outlineBorder(borderColor),
          enabledBorder: _outlineBorder(borderColor),
          focusedBorder: _outlineBorder(focusedBorderColor),
          errorBorder: _outlineBorder(Colors.red),
          focusedErrorBorder: _outlineBorder(Colors.red),
        ),
      ),
    );
  }
}
