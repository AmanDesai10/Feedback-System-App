import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField(
      {Key? key,
      required this.title,
      required this.hintText,
      required this.onChanged,
      this.validator,
      this.isObscure = false,
      this.suffixIcon})
      : super(key: key);

  final String title;
  final String hintText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool isObscure;
  final Widget? suffixIcon;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return TextFormField(
      cursorColor: theme.colorScheme.secondary,
      keyboardType: TextInputType.emailAddress,
      cursorRadius: Radius.circular(16.0),
      // initialValue: widget.initialValue,
      cursorWidth: 1.0,
      autocorrect: false,
      obscureText: isObscure,
      onChanged: onChanged,
      style: theme.textTheme.headline6!.copyWith(fontSize: 16),
      validator: validator,
      // textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: title,
        alignLabelWithHint: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: BorderSide(color: Colors.grey.shade400)),

        hintText: hintText,
        contentPadding: EdgeInsets.all(16 * 1.4).copyWith(right: 16 * 1.4 * 2),
        labelStyle: theme.textTheme.bodyText2!
            .copyWith(fontSize: 20.0, color: Colors.grey[400]),
        // errorText: 'widget.errorText',
        hintStyle: theme.textTheme.bodyText2!
            .copyWith(fontSize: 16.0, color: Colors.grey.shade400),
      ),
    );
  }
}

class ReadOnlyTextField extends StatelessWidget {
  const ReadOnlyTextField({
    Key? key,
    required this.value,
  }) : super(key: key);
  final String value;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return TextFormField(
      readOnly: true,
      initialValue: value,
      style: theme.textTheme.headline6!.copyWith(fontSize: 18),
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade400)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey)),
        contentPadding: EdgeInsets.all(16.0).copyWith(right: 16 * 1.4 * 2),
      ),
    );
  }
}
