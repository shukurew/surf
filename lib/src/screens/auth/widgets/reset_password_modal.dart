import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms/src/common/widgets/global/nv_text_field.dart';
import 'package:tms/src/screens/auth/cubit/reset_password_cubit.dart';
import 'package:tms/src/common/services/auth_service.dart';
import 'package:get_it/get_it.dart';

class ResetPasswordModal extends StatefulWidget {
  final String? phone;
  const ResetPasswordModal({super.key, this.phone});

  Future<void> view(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => this,
    );
  }

  @override
  State<ResetPasswordModal> createState() => _ResetPasswordModalState();
}

class _ResetPasswordModalState extends State<ResetPasswordModal> {
  int _step = 1;
  String? _message;
  bool _isError = false;

  final _phoneController = TextEditingController();
  bool _phoneValid = false;

  final _codeControllers = List.generate(4, (_) => TextEditingController());
  final _codeFocus = List.generate(4, (_) => FocusNode());

  final _passwordController = TextEditingController();
  bool _hasMinLength = false;
  bool _hasLower = false;
  bool _hasDigit = false;
  bool _hasSpecial = false;

  @override
  void initState() {
    super.initState();
    if (widget.phone != null && widget.phone!.isNotEmpty) {
      _phoneController.text = widget.phone!;
      _validatePhone();
    }
    _phoneController.addListener(_validatePhone);
    _passwordController.addListener(_validatePassword);

    for (final controller in _codeControllers) {
      controller.addListener(() {
        setState(() {});
      });
    }
  }

  void _validatePhone() {
    final text = _phoneController.text;
    final valid = text.length == 18;
    if (valid != _phoneValid) setState(() => _phoneValid = valid);
  }

  void _validatePassword() {
    final pw = _passwordController.text;
    setState(() {
      _hasMinLength = pw.length >= 8;
      _hasLower = pw.contains(RegExp(r'[a-z]'));
      _hasDigit = pw.contains(RegExp(r'\d'));
      _hasSpecial = pw.contains(RegExp(r'[!@#\$&*~%^]'));
    });
  }

  String _getCode() {
    return _codeControllers.map((c) => c.text).join();
  }

  String _cleanPhoneNumber(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.startsWith('7') || cleaned.startsWith('8')) {
      cleaned = cleaned.substring(1);
    }
    return cleaned;
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 6),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Row(
      children: [
        SizedBox(width: 24),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildMessage() {
    if (_message == null) return SizedBox.shrink();

    final color = _isError ? Color(0xFFE53935) : Color(0xFF68D168);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _message!,
        style: TextStyle(color: color, fontSize: 14, fontFamily: 'SF-Pro'),
      ),
    );
  }

  Widget _buildStep1() {
    return BlocConsumer<RequestResetCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          setState(() {
            _message = state.message;
            _isError = false;
            _step = 2;
          });
        } else if (state is ResetPasswordError) {
          setState(() {
            _message = state.message;
            _isError = true;
          });
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMessage(),
            Text(
              "Номер телефона",
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'SF-Pro',
                color: Color(0xFF888B94),
              ),
            ),
            const SizedBox(height: 8),
            NvTextField(
              controller: _phoneController,
              textInputType: TextInputType.phone,
              isPhone: true,
              backgroundColor: Color(0xFFF2F1F0),
              borderRadius: 12,
              borderColor: Color(0xFFE0E0E0),
              enableBorderColor: Color(0xFFE0E0E0),
              hasError: !_phoneValid,
            ),
            const SizedBox(height: 8),
            Text(
              "Введите номер телефона, на который вам будет отправлен SMS-код для смены пароля.",
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'SF-Pro',
                color: Color(0xFF888B94),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed:
                  _phoneValid && state is! ResetPasswordLoading
                      ? () => context.read<RequestResetCubit>().requestReset(
                        _cleanPhoneNumber(_phoneController.text),
                      )
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF68D168),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Color(0xFFF2F1F0),
                disabledForegroundColor: Colors.white70,
                minimumSize: Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child:
                  state is ResetPasswordLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                        "Отправить SMS-код",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'SF-Pro',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStep2() {
    return BlocConsumer<VerifyCodeCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          setState(() {
            _message = state.message;
            _isError = false;
            _step = 3;
          });
        } else if (state is ResetPasswordError) {
          setState(() {
            _message = state.message;
            _isError = true;
          });
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMessage(),
            Text(
              "Введите код из SMS",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF-Pro',
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'SF-Pro',
                ),
                children: [
                  TextSpan(text: 'Отправили его на '),
                  TextSpan(
                    text: _phoneController.text,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Focus(
              autofocus: true,
              onKey: (node, event) {
                if (event is RawKeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.backspace) {
                  for (int i = 0; i < 4; i++) {
                    if (_codeFocus[i].hasFocus &&
                        _codeControllers[i].text.isEmpty &&
                        i > 0) {
                      _codeFocus[i - 1].requestFocus();
                      _codeControllers[i - 1].text = '';
                      break;
                    }
                  }
                }
                return KeyEventResult.ignored;
              },
              child: Row(
                children: List.generate(4, (i) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i < 3 ? 8.0 : 0),
                      child: TextField(
                        controller: _codeControllers[i],
                        focusNode: _codeFocus[i],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'SF-Pro',
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor:
                              _codeControllers[i].text.isEmpty
                                  ? Color(0xFFFAFAFA)
                                  : Color(0xFFE9F2FB),
                          contentPadding: EdgeInsets.symmetric(vertical: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (v) {
                          if (v.isNotEmpty && i < 3) {
                            _codeFocus[i + 1].requestFocus();
                          }
                          if (i == 3 &&
                              _codeControllers.every(
                                (c) => c.text.isNotEmpty,
                              )) {
                            context.read<VerifyCodeCubit>().verifyCode(
                              _cleanPhoneNumber(_phoneController.text),
                              _getCode(),
                            );
                          }
                        },
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {},
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'SF-Pro',
                      color: Color(0xFF888B94),
                    ),
                    children: [
                      TextSpan(text: "Отправить повторно через "),
                      TextSpan(
                        text: "54 секунды",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStep3() {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          setState(() {
            _message = state.message;
            _isError = false;
          });
          Navigator.of(context).pop();
        } else if (state is ResetPasswordError) {
          setState(() {
            _message = state.message;
            _isError = true;
          });
        }
      },
      builder: (context, state) {
        Widget reqText(bool ok, String label, String sublabel) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            child: Column(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                    color: ok ? Color(0xFF68D168) : Color(0xFF888B94),
                    fontFamily: 'SF-Pro',
                  ),
                ),
                Text(
                  sublabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: ok ? Color(0xFF68D168) : Color(0xFF888B94),
                    fontFamily: 'SF-Pro',
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMessage(),
            Text(
              "Введите новый пароль",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF-Pro',
              ),
            ),
            const SizedBox(height: 12),
            NvTextField(
              controller: _passwordController,
              obscureText: true,
              placeholder: "Введите новый пароль",
              backgroundColor: Color(0xFFF2F1F0),
              borderRadius: 12,
              borderColor: Color(0xFFE0E0E0),
              enableBorderColor: Color(0xFFE0E0E0),
            ),
            const SizedBox(height: 16),
            Text("Пароль должен содержать:", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(4, (i) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i < 3 ? 8.0 : 0),
                    child: reqText(
                      i == 0
                          ? _hasMinLength
                          : i == 1
                          ? _hasLower
                          : i == 2
                          ? _hasSpecial
                          : _hasDigit,
                      i == 0
                          ? "8+"
                          : i == 1
                          ? "abc"
                          : i == 2
                          ? "%"
                          : "123",
                      i == 0
                          ? "Количество символов"
                          : i == 1
                          ? "Буквы только латинские"
                          : i == 2
                          ? "Минимум один спец символ"
                          : "Минимум одна цифра",
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed:
                  (_hasMinLength &&
                          _hasLower &&
                          _hasDigit &&
                          _hasSpecial &&
                          state is! ResetPasswordLoading)
                      ? () {
                        context.read<ResetPasswordCubit>().resetPassword(
                          _cleanPhoneNumber(_phoneController.text),
                          _getCode(),
                          _passwordController.text,
                        );
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF68D168),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Color(0xFFF2F1F0),
                disabledForegroundColor: Color(0xFF888B94),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: Size(double.infinity, 48),
              ),
              child:
                  state is ResetPasswordLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                        "Сохранить пароль",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'SF-Pro',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  RequestResetCubit(authService: GetIt.I<AuthService>()),
        ),
        BlocProvider(
          create:
              (context) => VerifyCodeCubit(authService: GetIt.I<AuthService>()),
        ),
        BlocProvider(
          create:
              (context) =>
                  ResetPasswordCubit(authService: GetIt.I<AuthService>()),
        ),
      ],
      child: AnimatedPadding(
        padding: EdgeInsets.only(bottom: bottomInset),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHandle(),
                  if (_step == 1) _buildHeader("Забыли пароль"),
                  if (_step == 2) _buildHeader("Забыли пароль"),
                  if (_step == 3) _buildHeader("Забыли пароль"),
                  const SizedBox(height: 16),
                  if (_step == 1) _buildStep1(),
                  if (_step == 2) _buildStep2(),
                  if (_step == 3) _buildStep3(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    for (var c in _codeControllers) {
      c.dispose();
    }
    for (var f in _codeFocus) {
      f.dispose();
    }
    super.dispose();
  }
}
