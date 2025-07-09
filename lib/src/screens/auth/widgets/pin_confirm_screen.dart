import 'package:flutter/material.dart';
import 'package:tms/src/screens/main/main_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';

class PinConfirmScreen extends StatefulWidget {
  final String initialPin;
  const PinConfirmScreen({super.key, required this.initialPin});

  @override
  State<PinConfirmScreen> createState() => _PinConfirmScreenState();
}

class _PinConfirmScreenState extends State<PinConfirmScreen> {
  String _pin = '';

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
        if (_pin == widget.initialPin) {
          context.read<AuthCubit>().savePinCode(_pin).then((_) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => MainScreen()),
              (route) => false,
            );
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Код не совпадает, попробуйте ещё раз'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _pin = '';
          });
        }
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

  VoidCallback onSkipPressed() => () {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => MainScreen()),
      (route) => false,
    );
  };

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailed) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: BackButton(color: Colors.black),
          actions: [
            TextButton(
              onPressed: onSkipPressed,
              child: const Text(
                'Пропустить',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Подтвердите код доступа',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'SF-Pro',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Код доступа должен состоять из 4 цифр',
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
