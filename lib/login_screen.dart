import 'package:chatapp/main.dart';
import 'package:chatapp/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/app_settings.dart';
//import 'services/http_services.dart';
import 'values/app_dimens.dart';
import 'values/app_colors.dart';
import 'components/form_field.dart';
import 'components/form_button.dart';
import 'components/form_flat_button.dart';
//import 'components/error_dialog.dart';
//import 'services/firebase_notifications.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  //for each form field a textcontroller is needed
  final myPasswordController = TextEditingController();
  final myConfirmPasswordController = TextEditingController();
  final myEmailController = TextEditingController();
  bool workInProgress = false;

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String errorMessage = null;

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myPasswordController.dispose();
    myEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.LOGIN_BACKGROUND_COLOR,
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
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
                              hintText: "email",
                              validatorFunction: _validateEmail,
                              textFieldController: myEmailController,
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
                            Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: FormButtonWidget(
                                  text: "login",
                                  onPressed: () {
                                    // Validate will return true if the form is valid, or false if
                                    // the form is invalid.
                                    if (_formKey.currentState.validate()) {
                                      _login();
                                    }
                                  },
                                )
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: FormFlatButtonWidget(
                            text: "register",
                            onPressed: () {
                              // Validate will return true if the form is valid, or false if
                              // the form is invalid.
                                _goToRegistration();
                            },
                          )
                      ),
                    ]
                )
            ),
            workInProgress ? Container(
                child: Center(
                  child: CircularProgressIndicator()
                ),
                color: Colors.transparent.withOpacity(0.8),
              ) : Container(),
            errorMessage != null ? Container(
                child: AlertDialog(
                  title: Text('Error'),
                  content: Text(errorMessage),
                  actions: <Widget>[
                    FlatButton(
                        child: Text('Confirm'),
                        onPressed: _closeMessage
                    )
                  ],
                ),
                color: Colors.transparent.withOpacity(0.8),
            ) : Container()
          ],
        )
    );
  }
  String _validateEmail(String value) {
    //debugPrint("Value: " + value);
    if (value.isEmpty || value==null) {
      // The form is empty
      return "missing_email";
    }

    //if the username should be an email than you can do the following validation
    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (!regExp.hasMatch(value)) {
      // email is not valid
      return "invalid_mail";
    }

    return null;
  }

  _closeMessage() async {
    setState(() {
      this.errorMessage = null;
    });
  }

  _login() async {

    var instance = await AppSettingsService.getInstance();
    setState(() {
      this.workInProgress = true;
    });

    // Unfocus password field so the keyboard is hidden when button is clicked
    FocusScope.of(context).requestFocus(FocusNode());


    FirebaseUser user;

    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: myEmailController.text, password: myPasswordController.text);
      user = result.user;
    } catch(signInError) {

      // Checks if input values are correct
      if (signInError is PlatformException) {
        //debugPrint(signInError.code);
        switch(signInError.code) {
          case 'ERROR_USER_NOT_FOUND':
            setState(() {
              this.errorMessage = 'user_not_found';
              this.workInProgress = false;
            });
            return;
          case 'ERROR_INVALID_EMAIL':
            setState(() {
              this.errorMessage = 'invalid_mail';
              this.workInProgress = false;
            });
            return;
          case 'ERROR_WRONG_PASSWORD':
            setState(() {
              this.errorMessage = 'wrong_password';
              this.workInProgress = false;
            });
            return;
        }
      }
    }

    // Adds uid to config
    var appSettings = await AppSettingsService.getInstance();
    appSettings.uIdUser = user.uid;

    setState(() {
      this.workInProgress = false;
    });
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  _goToRegistration() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
  }

}






