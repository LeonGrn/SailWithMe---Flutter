import 'package:SailWithMe/config/palette.dart';
import 'package:SailWithMe/widgets/text_field_container.dart';
import 'package:flutter/material.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: Palette.kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: Palette.kPrimaryColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: Palette.kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
