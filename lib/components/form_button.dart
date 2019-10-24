import 'package:flutter/material.dart';
import '../values/app_colors.dart';
import '../values/app_dimens.dart';


class FormButtonWidget extends StatelessWidget{

  FormButtonWidget({String text, Function onPressed})
      : text = text,
        onPressed = onPressed;

  final String text;
  final Function onPressed;

  // Create constant constructor
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: AppDimens.MAIN_BUTTON_SIDE_MARGIN, right: AppDimens.MAIN_BUTTON_SIDE_MARGIN),
      child: MaterialButton(
        onPressed: () {
          onPressed();
        },
        color: AppColors.LOGIN_BUTTON_COLOR,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style: new TextStyle(
                fontSize: AppDimens.LOGIN_BUTTON_TEXT_SIZE,
                color: AppColors.LOGIN_BACKGROUND_COLOR,
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.LOGIN_BUTTON_CIRCULAR_BORDER_RADIUS)),
        padding: EdgeInsets.all(AppDimens.LOGIN_BUTTON_PADDING),
        height: AppDimens.LOGIN_BUTTON_HEIGHT,
      ),
    );
  }
}