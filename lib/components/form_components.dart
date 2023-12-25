import 'package:flutter/material.dart';

class FormComponents {
  static BoxDecoration boxDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(50),
      ),
      color: Theme.of(context).primaryColor,
    );
  }

  static TextFormField buildTextFormField({
    required BuildContext context,
    required String hintText,
    required Widget icon,
    required String? Function(String? value)? validator,
    required void Function(String? value)? onSaved,
    void Function(String? value)? onChanged,
    FocusNode? focusNode,
    void Function()? onEditingComplete,
    bool obscure = false,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
    TextEditingController? controller,
  }) {
    return TextFormField(
      obscureText: obscure,
      controller: controller,
      focusNode: focusNode,
      initialValue: initialValue,
      cursorColor: Theme.of(context).colorScheme.onPrimary,
      keyboardType: keyboardType,
      style:
          Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 2,
          ),
          child: icon,
        ),
      ),
      onEditingComplete: onEditingComplete,
      onChanged: onChanged,
      validator: validator,
      onSaved: onSaved,
    );
  }
}
