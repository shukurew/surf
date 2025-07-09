import 'package:flutter/material.dart';
import 'package:tms/src/common/constants/color_constant.dart';
import 'package:tms/src/common/constants/text_styles.dart';
import 'package:tms/src/common/router/routing_constant.dart';
import 'package:tms/src/screens/auth/widgets/appbar_with_logos.dart';
import 'package:tms/src/screens/auth/widgets/reset_password_modal.dart';
import 'package:tms/src/common/widgets/global/nv_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms/src/screens/auth/cubit/auth_cubit.dart';
import 'package:tms/src/screens/auth/widgets/tos_checkbox.dart';

import '../../common/widgets/surv_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final FocusNode _phoneNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

  bool tosChecked = false;
  bool obscurePassword = true;
  bool isFormFilled = false;

  void onTextFieldChanged(String text) {
    setIsFormFilled();
  }

  void onCheckChanged(bool? value) {
    if (value == null) return;
    setState(() {
      tosChecked = value;
    });
    setIsFormFilled();
  }

  void setIsFormFilled() {
    setState(() {
      isFormFilled =
          _phoneController.text.length == 18 &&
          _passwordController.text.length >= 6 &&
          tosChecked;
    });
  }

  String _cleanPhoneNumber(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.startsWith('7') || cleaned.startsWith('8')) {
      cleaned = cleaned.substring(1);
    }
    return cleaned;
  }

  void listenAuth(BuildContext context, AuthState state) {
    if (state is AuthLoaded) {
      Navigator.pushReplacementNamed(context, RoutingConst.main);
    }
  }

  void onAuthPressed() {
    final phone = _cleanPhoneNumber(_phoneController.text.trim());
    final password = _passwordController.text.trim();
    context.read<AuthCubit>().authNumber(phone, password);
  }

  void togglePasswordVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  void onPhoneFieldSubmitted(String text) {
    _passwordNode.requestFocus();
  }

  VoidCallback showResetPasswordModal() => () {
    ResetPasswordModal(phone: _phoneController.text).view(context);
  };

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: listenAuth,
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppbarWithLogos(),
              backgroundColor: Colors.white,
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      SizedBox(height: 80),
                      Text('Номер телефона', style: TextStyles.bodySmall),
                      SizedBox(height: 5),
                      NvTextField(
                        focusNode: _phoneNode,
                        controller: _phoneController,
                        textInputType: TextInputType.phone,
                        isPhone: true,
                        backgroundColor: Color(0xFFF2F1F0),
                        borderRadius: 12,
                        borderColor: Color(0xFFE0E0E0),
                        enableBorderColor: Color(0xFFE0E0E0),
                        onChanged: onTextFieldChanged,
                        onSubmitted: onPhoneFieldSubmitted,
                      ),
                      SizedBox(height: 14),
                      Text('Пароль', style: TextStyles.bodySmall),
                      SizedBox(height: 5),
                      NvTextField(
                        focusNode: _passwordNode,
                        controller: _passwordController,
                        obscureText: obscurePassword,
                        backgroundColor: Color(0xFFF2F1F0),
                        borderRadius: 12,
                        borderColor: Color(0xFFE0E0E0),
                        enableBorderColor: Color(0xFFE0E0E0),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: togglePasswordVisibility,
                        ),
                        onChanged: onTextFieldChanged,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: showResetPasswordModal,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            'Забыли пароль?',
                            style: TextStyles.bodySmall.copyWith(
                              color: AppColors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      TosCheckbox(
                        isChecked: tosChecked,
                        onChanged: onCheckChanged,
                      ),
                      SizedBox(height: 16),
                      SurvButton(
                        label: 'Продолжить',
                        onPressed: isFormFilled ? onAuthPressed : null,
                        color: Color(0xFFFF8F21),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (state is AuthLoading)
              Positioned.fill(
                child: Container(
                  color: AppColors.white.withAlpha(128),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.orange),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
