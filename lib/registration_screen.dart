import 'package:flutter/material.dart';
import 'services/app_settings.dart';
//import 'services/http_services.dart';
import 'values/app_dimens.dart';
import 'values/app_colors.dart';
import 'components/form_field.dart';
import 'components/form_button.dart';
//import 'components/error_dialog.dart';
//import 'services/firebase_notifications.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<RegistrationScreen> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  //for each form field a textcontroller is needed
  final myPasswordController = TextEditingController();
  final myConfirmPasswordController = TextEditingController();
  final myUsernameController = TextEditingController();
  bool workInProgress = false;

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myPasswordController.dispose();
    myConfirmPasswordController.dispose();
    myUsernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.LOGIN_BACKGROUND_COLOR,
        body: workInProgress ? CircularProgressIndicator() : SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0),
                  ),
                  Container(
                    child: Image.asset("res/img/login_screen_icon.png", scale: 6,),
                    height: 100,
                    width: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FormFieldWidget(
                          hintText: "username",
                          validatorFunction: _validateUsername,
                          textFieldController: myUsernameController,
                          textInputType: TextInputType.emailAddress,
                          iconName: "appAsset_85.png",
                        ),
                        FormFieldWidget(
                          hintText: "password",
                          validatorFunction: (value) {
                            if (value.isEmpty) {
                              return "missing_password";
                            }
                          },
                          textFieldController: myPasswordController,
                          iconName: "appAsset_97.png",
                          isObscureText: true,
                        ),
                        FormFieldWidget(
                          hintText: "password_repeat",
                          validatorFunction: (value) {
                            if (value!=myPasswordController.text) {
                              return "password_does_not_match";
                            }
                          },
                          textFieldController: myConfirmPasswordController,
                          iconName: "appAsset_97.png",
                          isObscureText: true,
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: FormButtonWidget(
                              text: "registration",
                              onPressed: () {
                                // Validate will return true if the form is valid, or false if
                                // the form is invalid.
                                if (_formKey.currentState.validate()) {
                                  _registerNewUser();
                                }
                              },
                            )
                        ),
                      ],
                    ),
                  ),
                ]
            )
        )
    );
  }
  String _validateUsername(String value) {
    //debugPrint("Value: " + value);
    if (value.isEmpty || value==null) {
      // The form is empty
      return "missing_username";
    }

    //if the username should be an email than you can do the following validation
    // This is just a regular expression for email addresses
    /*String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      // So, the email is valid
      return null;
    }

    // The pattern of the email didn't match the regex above.
    return "not_valid_email";

     */
    return null;
  }

    _registerNewUser() async {

    var instance = await AppSettingsService.getInstance();
    setState(() {
      this.workInProgress = true;
    });

    //insert a function which registers the new user with the firebase service

    setState(() {
      this.workInProgress = false;
    });

  }
  
}






