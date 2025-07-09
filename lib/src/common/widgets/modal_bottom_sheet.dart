import 'package:flutter/material.dart';
import 'package:tms/src/common/constants/color_constant.dart';
import 'package:tms/src/common/constants/text_styles.dart';

void showStyledModalBottomSheet(
  BuildContext context,
  String heading,
  Widget child,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    backgroundColor: AppColors.white,
    builder: (localContext) {
      return SafeArea(
        child: Wrap(
          children: [
            Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Text(
                        heading,
                        style: TextStyles.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20),
                    child,
                  ],
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pop(localContext);
                    },
                    iconSize: 24,
                    icon: Icon(Icons.close, color: AppColors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
