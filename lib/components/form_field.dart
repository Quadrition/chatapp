import 'package:flutter/material.dart';
import '../values/app_colors.dart';
import '../values/app_dimens.dart';


class FormFieldWidget extends StatelessWidget{

  FormFieldWidget({
    String hintText,
    Function onPressed,
    TextEditingController textFieldController,
    Function validatorFunction,
    TextInputType textInputType = TextInputType.text,
    bool isObscureText=false,
    String iconName =""})
      : hintText = hintText,
        onPressed = onPressed,
        textFieldController = textFieldController,
        validatorFunction = validatorFunction,
        textInputType = textInputType,
        isObscureText = isObscureText,
        iconName= "res/img/" + iconName;

  final String hintText;
  final Function onPressed;
  final textFieldController;
  final Function validatorFunction;
  final TextInputType textInputType;
  final isObscureText;
  final String iconName;

  // Create constant constructor
  @override
  Widget build(BuildContext context) {
    return Padding (
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        style: TextStyle(
          color: AppColors.LOGIN_TEXT_COLOR,
          fontSize: AppDimens.LOGIN_FIELD_TEXT_SIZE,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppColors.LOGIN_TEXT_COLOR,
            fontSize: AppDimens.LOGIN_FIELD_TEXT_SIZE,
          ),
          errorStyle: TextStyle(
            color: AppColors.LOGIN_BUTTON_COLOR,
            fontSize: AppDimens.LOGIN_ERROR_TEXT_SIZE,
          ),
          icon: isIcon() ? Image.asset(iconName, scale: 4, color: AppColors.LOGIN_ICON_COLOR) : null,
          //contentPadding: EdgeInsets.only(left: 20),
        ),
        validator: validatorFunction,
        keyboardType: textInputType,
        controller: textFieldController,
        obscureText: isObscureText,
      ),
    );
  }

  bool isIcon() {
    if (iconName == "res/img/") return false;
    return true;
  }
}