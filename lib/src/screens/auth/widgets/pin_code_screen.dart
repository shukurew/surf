import 'package:flutter/material.dart';
import 'package:tms/src/screens/main/main_screen.dart';
import 'package:tms/src/screens/auth/widgets/pin_confirm_screen.dart';

class PinCodeScreen extends StatefulWidget {
  const PinCodeScreen({super.key});

  @override
  State<PinCodeScreen> createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  String _pin = '';

  List<Widget> _buildPinIndicators() {
    return List.generate(4, (index) {
      bool filled = index < _pin.length;
      return AnimatedContainer(
        duration: Duration(milliseconds: 150),
        width: 16,
        height: 16,
        margin: EdgeInsets.symmetric(horizontal: 8),
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
        Future.delayed(Duration(milliseconds: 300), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PinConfirmScreen(initialPin: _pin),
            ),
          );
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => MainScreen()),
                (route) => false,
              );
            },
            child: Text('Пропустить', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Создайте код доступа',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'SF-Pro',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Код доступа должен состоять из 4 цифр',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'SF-Pro',
                color: Color(0xFF888B94),
              ),
            ),
            SizedBox(height: 150),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPinIndicators(),
            ),
            SizedBox(height: 32),
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
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildKeyButton('4'),
                      _buildKeyButton('5'),
                      _buildKeyButton('6'),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildKeyButton('7'),
                      _buildKeyButton('8'),
                      _buildKeyButton('9'),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(width: 60),
                      _buildKeyButton('0'),
                      IconButton(
                        onPressed: _handleDelete,
                        icon: Icon(Icons.backspace),
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
    );
  }

  Widget _buildKeyButton(String digit) {
    return TextButton(
      onPressed: () => _handleDigitInput(digit),
      style: TextButton.styleFrom(minimumSize: Size(64, 64)),
      child: Text(digit, style: TextStyle(fontSize: 24, color: Colors.black)),
    );
  }
}
