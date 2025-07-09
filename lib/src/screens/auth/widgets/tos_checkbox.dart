import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TosCheckbox extends StatelessWidget {
  const TosCheckbox({super.key, required this.isChecked, this.onChanged});

  final bool isChecked;
  final ValueChanged<bool?>? onChanged;

  void openTermsAndConditions() {
    launchUrl(
      Uri.parse(
        'https://nls.kz/storage/files/e4/4a/87ebe1e86da0ecd887b773c62cf731c85221.pdf',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return Color(0xFF00AAFF);
            }
            return Color(0xFFF2F1F0);
          }),
          checkColor: WidgetStateProperty.all(Colors.white),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          side: BorderSide.none,
        ),
      ),
      child: CheckboxListTile(
        value: isChecked,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        onChanged: onChanged,
        splashRadius: 0,
        title: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(color: Color(0xFF828282)),
                  children: [
                    TextSpan(text: 'Я ознакомлен с '),
                    TextSpan(
                      text: 'Пользовательским соглашением',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = openTermsAndConditions,
                    ),
                    TextSpan(text: ' и '),
                    TextSpan(
                      text:
                          'Положением об обработке и защите персональных данных',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = openTermsAndConditions,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
