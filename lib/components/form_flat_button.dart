import 'package:flutter/material.dart';
import '../values/app_colors.dart';
import '../values/app_dimens.dart';


class FormFlatButtonWidget extends StatelessWidget{

  FormFlatButtonWidget({String text, Function onPressed})
      : text = text,
        onPressed = onPressed;

  final String text;
  final Function onPressed;

  // Create constant constructor
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: AppDimens.MAIN_BUTTON_SIDE_MARGIN, right: AppDimens.MAIN_BUTTON_SIDE_MARGIN),
      child: FlatButton(
        onPressed: () {
          onPressed();
        },
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style: new TextStyle(
                fontSize: AppDimens.LOGIN_REGISTER_TEXT_SIZE,
                color: AppColors.LOGIN_TEXT_COLOR,
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.LOGIN_BUTTON_CIRCULAR_BORDER_RADIUS)),
        padding: EdgeInsets.all(AppDimens.LOGIN_BUTTON_PADDING),
      ),
    );
  }
}