import 'package:chatapp/chat.dart';
import 'package:chatapp/login_screen.dart';
import 'package:flutter/material.dart';
import 'services/app_settings.dart';
import 'registration_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewChatScreen extends StatefulWidget {
  NewChatScreen({Key key, @required this.currentUserDoc}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final DocumentSnapshot currentUserDoc;

  @override
  NewChatScreenState createState() => NewChatScreenState(currentUserDoc: currentUserDoc);
}

class NewChatScreenState extends State<NewChatScreen> {

  NewChatScreenState({Key key, @required this.currentUserDoc});

  bool workInProgress = false;

  final DocumentSnapshot currentUserDoc;
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
    Firestore.instance.collection('users').getDocuments().then((stream) {
      stream.documents.forEach((document) {
        setState(() {
          if (document.documentID != currentUserDoc.documentID) {
            list.add(new ListItem(document));
          }
        });
        });
      });

//    list = [];
//    for (int i = 0; i < 10; i++)
//      list.add(ListItem<String>("item $i"));
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
        onPressed: _createNewChat,
        child: Icon(Icons.send),
      ),
    );
  }

  Widget buildItem(BuildContext context, int index) {
//    if (list[index].data.data['uid'] == currentUserId) {
//      return Container();
//    } else {
      return Container(
        color: list[index].isSelected ? Colors.red[100] : Colors.white,
        child : GestureDetector(
          onTap: () {
            setState(() {
              list[index].isSelected = !list[index].isSelected;
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
//    }
  }

  void _createNewChat() async {
    List<DocumentSnapshot> selectedUsers = new List<DocumentSnapshot>();
    list.where((item) => item.isSelected).forEach((item) {

      selectedUsers.add(item.data);
    });

    if (selectedUsers.length == 1) {
      DocumentSnapshot peerDoc = selectedUsers[0];
      currentUserDoc.reference.collection('chatHistory').getDocuments().then((documents) {
        bool found = false;
        documents.documents.forEach((curDocument) {
          if (curDocument.data['peerId'] == peerDoc.documentID)
          {
              curDocument.data['chatDoc'].get().then((ds) {

              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(chatDocument: ds, chatName: curDocument.data['chatName'], currentUserDoc: currentUserDoc)));
            });
            found = true;
            return;
          }
        });
        if (!found)
        {
          Firestore.instance.collection('chats').add({
            'isGroup': false
          }).then((ref) {
            ref.collection('users').document(currentUserDoc.documentID).setData({
              'userId': currentUserDoc.documentID,
              'userDoc': currentUserDoc.reference
            });
            ref.collection('users').document(peerDoc.documentID).setData({
              'userId': peerDoc.documentID,
              'userDoc': peerDoc.reference
            });

            currentUserDoc.reference.collection('chatHistory').document(ref.documentID).setData({
              'chatName': peerDoc.data['displayName'],
              'chatDoc': ref,
              'peerId': peerDoc.documentID
            });
            peerDoc.reference.collection('chatHistory').document(ref.documentID).setData({
              'chatName': currentUserDoc.data['displayName'],
              'chatDoc': ref,
              'peerId': currentUserDoc.documentID
            });

            ref.get().then((chatDoc) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(chatDocument: chatDoc, chatName: peerDoc.data['displatName'], currentUserDoc: currentUserDoc)));
            });
          });
        }
      });
    }
    else {
      //TODO grupni chat

      String thisChatName = '';
      Firestore.instance.collection('chats').add({
        'isGroup': true
      }).then((ref) {
        selectedUsers.add(currentUserDoc);
        selectedUsers.forEach((user) {
          ref.collection('users').document(user.documentID).setData({
            'userId': user.documentID,
            'userDoc': user.reference
          });

          String chatName = '';
          selectedUsers.forEach((curUser) {
            if (curUser.documentID != user.documentID) {
              chatName += curUser.data['displayName'] + ', ';
            }
            if (user.documentID == currentUserDoc.documentID) {
              if (curUser.documentID != currentUserDoc.documentID) {
                thisChatName += curUser.data['displayName'] + ', ';
              }

            }
          });
          chatName = chatName.substring(0, chatName.length - 2);
          user.reference.collection('chatHistory').document(ref.documentID).setData({
            'chatName': chatName,
            'chatDoc': ref
          });
        });

        ref.get().then((chatDoc) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(chatDocument: chatDoc, chatName: thisChatName, currentUserDoc: currentUserDoc)));
        });
      });

    }

    Navigator.pop(context);
  }
}

class ListItem<T> {
  bool isSelected = false;
  T data;
  ListItem(this.data);
}