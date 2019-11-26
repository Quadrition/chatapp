import 'package:chatapp/chat.dart';
import 'package:chatapp/login_screen.dart';
import 'package:flutter/material.dart';
import 'services/app_settings.dart';
import 'registration_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewChatScreen extends StatefulWidget {
  NewChatScreen({Key key, @required this.currentUserId}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String currentUserId;

  @override
  NewChatScreenState createState() => NewChatScreenState(currentUserId: currentUserId);
}

class NewChatScreenState extends State<NewChatScreen> {

  NewChatScreenState({Key key, @required this.currentUserId});

  bool workInProgress = false;
  final String currentUserId;

  List<ListItem<DocumentSnapshot>> list;

  @override
  void initState() {

    super.initState();
    /*loadUserId().then((result) {
      setState(() {
        currentUserUid = result;
      });
      debugPrint("current User Id is " + currentUserUid);
    });*/

    populateList();

  }

  void populateList() async {
    list = new List<ListItem<DocumentSnapshot>>();
    Firestore.instance
        .collection('users')
        .snapshots()
        .listen((snapshot) {
      snapshot.documents.forEach((document) {
        setState(() {
          list.add(new ListItem(document));
        });

      });
    });

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
          title: Text('Select contacts'),
          ),
        preferredSize: Size.fromHeight(75),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: buildItem,
                    itemCount: list.length
                  )
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
        onPressed: _createNewChat,
        child: Icon(Icons.send),
      ),
    );
  }

  Widget buildItem(BuildContext context, int index) {
    if (list[index].data.data['uid'] == currentUserId) {
      return Container();
    } else {
      child: Container(
        child : GestureDetector(
          onTap: () {
            if (list.any((item) => item.isSelected)) {
              setState(() {
                list[index].isSelected = !list[index].isSelected;
              });
            }
          },
          onLongPress: () {
            setState(() {
              list[index].isSelected = true;
            });
          },
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
                        list[index].data.data['displayName']
                    ),
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }

  void _createNewChat() {

  }

}

class ListItem<T> {
  bool isSelected = false;
  T data;
  ListItem(this.data);
}