import 'package:chatapp/chat.dart';
import 'package:chatapp/login_screen.dart';
import 'package:chatapp/new_chat.dart';
import 'package:flutter/material.dart';
import 'services/app_settings.dart';
import 'registration_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: <String, WidgetBuilder>{
        '/loginscreen': (BuildContext context) => new LoginScreen(),
        '/mainscreen': (BuildContext context) => new MyHomePage(),
        '/registrationscreen': (BuildContext context) => new RegistrationScreen(),
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title = "Chat App";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  _MyHomePageState({Key key});

  bool workInProgress = false;
  String currentUserUid;

  @override
  void initState() {
    debugPrint("main init state");
    checkFirstRun();
    super.initState();
    /*loadUserId().then((result) {
      setState(() {
        currentUserUid = result;
      });
      debugPrint("current User Id is " + currentUserUid);
    });*/
  }

  List<Choice> choices = const <Choice>[
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];

  checkFirstRun() async {
    debugPrint("check first run started");
    var instance = await AppSettingsService.getInstance();
    bool _firstRun = instance.isFirstRun;
    debugPrint("first run value is: " + _firstRun.toString());
    if (_firstRun) {
      debugPrint("first run");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );

    } else {
      debugPrint("not first run");
      currentUserUid = await instance.uIdUser;
      //TODO navigate to main screen
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  child: Image.asset("res/img/login_screen_icon.png", scale: 6, width: 50, height: 50),
                ),
              ),
              Container(
                child: Text('Chat App'),
                margin: EdgeInsets.symmetric(horizontal: 10),
              )
            ],
          ),
          actions: <Widget>[
            PopupMenuButton<Choice>(
              onSelected: onItemMenuPress,
              itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                      value: choice,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            choice.icon,
                          ),
                          Container(
                            width: 10.0,
                          ),
                          Text(
                            choice.title,
                          ),
                        ],
                      ));
                }).toList();
              },
            ),
          ],
        ),
        preferredSize: Size.fromHeight(75),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: StreamBuilder(
              stream: Firestore.instance.collection('users').document(currentUserUid).collection('chatHistory').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                    ),
                  );
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) => buildItem(context, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                  );
                }
              },
            ),
          ),
          workInProgress ? Container(
            child: Center(
                child: CircularProgressIndicator()
            ),
            color: Colors.transparent.withOpacity(0.8),
          ) : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToNewChat,
        tooltip: 'New chat',
        child: Icon(Icons.add),
      ),
    );
  }

  _goToNewChat() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewChatScreen(currentUserId : this.currentUserUid)));
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document['uid'] == currentUserUid) {
      return Container();
    } else {
        child: Container(
            child : FlatButton(
              child: Row(
                children: <Widget>[
                  Material(
                    child: Icon(
                      Icons.account_circle,
                      size: 50.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    clipBehavior: Clip.hardEdge,
                  ),
                  Flexible(
                    child: Container(
                      child: Container(
                        child: Text(
                          getGroupName(document)
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      margin: EdgeInsets.only(left: 20.0),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatPage(
                          currentUserId: currentUserUid,
                          groupChatId: document.data['uids']
                        )));
              },
                padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          ),
          margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }

  String getGroupName(DocumentSnapshot document) {
    Firestore.instance.collection('messages').document(document.data['groupId']).get().then((groupDoc) {
      document = groupDoc;
    });
    if (document.data['isGroup']) {
      return document.data['groupName'];
    }
    else {
      String peerId = document.data['first'];
      if (peerId == currentUserUid) {
        peerId = document.data['second'];
      }

      Firestore.instance.collection('users').document(peerId).get().then((document) {
        return document.data['displayName'];
      });
    }

    throw Exception();
  }


  void onItemMenuPress(Choice choice) {
    if (choice.title == 'Log out') {
      handleSignOut();
    }
  }

  Future<Null> handleSignOut() async {
    this.setState(() {
      workInProgress = true;
    });

    var appSettings = await AppSettingsService.getInstance();
    appSettings.uIdUser = '';

    this.setState(() {
      workInProgress = false;
    });

    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyApp()), (Route<dynamic> route) => false);
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
