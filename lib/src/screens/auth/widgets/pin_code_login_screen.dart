import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../auth_screen.dart';

class PinCodeLoginScreen extends StatefulWidget {
  const PinCodeLoginScreen({super.key});

  @override
  State<PinCodeLoginScreen> createState() => _PinCodeLoginScreenState();
}

class _PinCodeLoginScreenState extends State<PinCodeLoginScreen> {
  String _pin = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryBiometricAuth();
    });
  }

  Future<void> _tryBiometricAuth() async {
    context.read<AuthCubit>().authenticateWithBiometrics();
  }

  List<Widget> _buildPinIndicators() {
    return List.generate(4, (index) {
      bool filled = index < _pin.length;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 16,
        height: 16,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: filled ? Colors.orange : Colors.grey[300],
          shape: BoxShape.circle,
        ),
      );
    });
  }

  void _handleDigitInput(String digit) {
    if (_pin.length < 4) {
      setState(() {
        _pin += digit;
      });
      if (_pin.length == 4) {
        context.read<AuthCubit>().verifyPinCode(_pin);
      }
    }
  }

  void _handleDelete() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void authListener(BuildContext context, AuthState state) {
    if (state is AuthFailed) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message)));
      setState(() => _pin = '');
    } else if (state is PinCodeBlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Превышено количество попыток. Используйте обычную авторизацию',
          ),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const AuthScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: authListener,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed:
                  () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const AuthScreen()),
                  ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Введите PIN-код',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'SF-Pro',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Введите ваш PIN-код для входа',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'SF-Pro',
                    color: Color(0xFF888B94),
                  ),
                ),
                const SizedBox(height: 150),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPinIndicators(),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildKeyButton('1'),
                          _buildKeyButton('2'),
                          _buildKeyButton('3'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildKeyButton('4'),
                          _buildKeyButton('5'),
                          _buildKeyButton('6'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildKeyButton('7'),
                          _buildKeyButton('8'),
                          _buildKeyButton('9'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(width: 60),
                          _buildKeyButton('0'),
                          IconButton(
                            onPressed: _handleDelete,
                            icon: const Icon(Icons.backspace),
                            iconSize: 28,
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      TextButton.icon(
                        onPressed: _tryBiometricAuth,
                        icon: const Icon(Icons.fingerprint, size: 28),
                        label: const Text(
                          'Использовать биометрию',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildKeyButton(String digit) {
    return TextButton(
      onPressed: () => _handleDigitInput(digit),
      style: TextButton.styleFrom(minimumSize: const Size(64, 64)),
      child: Text(
        digit,
        style: const TextStyle(fontSize: 24, color: Colors.black),
      ),
    );
  }
}
