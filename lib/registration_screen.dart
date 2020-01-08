import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'services/app_settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'services/http_services.dart';
import 'package:flutter/services.dart';
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

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //for each form field a textcontroller is needed
  final myPasswordController = TextEditingController();
  final myConfirmPasswordController = TextEditingController();
  final myEmailController = TextEditingController();
  final myDisplayNameController = TextEditingController();
  bool workInProgress = false;

  String errorMessage = null;

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myPasswordController.dispose();
    myConfirmPasswordController.dispose();
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
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.chevron_left),
                            iconSize: 50,
                            color: AppColors.LOGIN_BUTTON_COLOR,
                            onPressed: () {
                              _goBack();
                            }
                        )
                      ],
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
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
                                  iconName: 'appAsset_85.png'
                                ),
                                FormFieldWidget(
                                  hintText: "display_name",
                                  validatorFunction: (value) {
                                    if (value.isEmpty) {
                                      return "missing_display_name";
                                    }
                                  },
                                  textFieldController: myDisplayNameController,
                                  iconName: "appAsset_96.png",
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
                  ],
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
      return "missing_username";
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
      // The pattern of the email didn't match the regex above.
      return "not_valid_email";
    }

    return null;
  }

  _closeMessage() async {
    setState(() {
      this.errorMessage = null;
    });
  }

  _registerNewUser() async {

    setState(() {
      this.workInProgress = true;
    });

    // Unfocus password field so the keyboard is hidden when button is clicked
    FocusScope.of(context).requestFocus(FocusNode());

    FirebaseUser user;

    // Checks if input values are correct
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: myEmailController.text, password: myPasswordController.text);
      user = result.user;
    } catch(signInError) {
      if (signInError is PlatformException) {
        //debugPrint(signInError.code);
        switch(signInError.code) {
          case 'ERROR_INVALID_EMAIL ':
            setState(() {
              this.errorMessage = 'invalid_email';
              this.workInProgress = false;
            });
            return;
          case 'ERROR_WEAK_PASSWORD':
            setState(() {
              this.errorMessage = 'weak_password';
              this.workInProgress = false;
            });
            return;
          case 'ERROR_EMAIL_ALREADY_IN_USE':
            setState(() {
              this.errorMessage = 'email_already_in_use';
              this.workInProgress = false;
            });
            return;
        }
      }
    }

    // Adds uid to config
    var appSettings = await AppSettingsService.getInstance();
    appSettings.idUser = user.uid;
    appSettings.displayNameUser = myDisplayNameController.text;

    Firestore.instance.collection('users').document(user.uid).setData({
      'email': user.email,
      'displayName': myDisplayNameController.text,
      'id': user.uid,
      'createdAt': DateTime.now().toString(),
    });

    setState(() {
      this.workInProgress = false;
    });
    //Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }
  _goBack() async {
    //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    Navigator.pop(context);
  }
}
