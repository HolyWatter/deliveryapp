
import 'package:delivery_app/common/const/colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final String? hintText;
  final String? errorText;
  final bool isPassword;
  final ValueChanged<String>? onChanged;

  

  const CustomTextField({super.key, this.hintText, this.errorText, this.isPassword = false , required this.onChanged});

  @override
  Widget build(BuildContext context) {

    const baseBorder = OutlineInputBorder(
          borderSide: BorderSide(
            color : INPUT_BORDER_COLOR,
            width: 1,
          )
        );

    return TextFormField(
      obscureText: isPassword,
      cursorColor: PRIMARY_COLOR,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        hintText: hintText,
        hintStyle: const TextStyle(
          color : BDOY_TEXT_COLOR,
          fontSize: 14
        ),
        errorText: errorText,
        fillColor: INPUT_BG_COLOR,
        filled: true,
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR
          )
        )
      ),
    );
  }
}