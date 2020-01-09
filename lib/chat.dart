import 'package:chatapp/login_screen.dart';
import 'package:flutter/material.dart';
import 'services/app_settings.dart';
import 'dart:io';
import 'registration_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'values/app_colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/values/app_colors.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key, @required this.chatDocument, @required this.currentUserDoc, @required this.chatName}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final DocumentSnapshot chatDocument;
  final DocumentSnapshot currentUserDoc;
  final String chatName;

  @override
  ChatPageState createState() => ChatPageState(chatDocument: this.chatDocument, currentUserDoc: this.currentUserDoc, chatName: this.chatName);
}

class ChatPageState extends State<ChatPage> {

  ChatPageState({Key key, @required this.chatDocument, @required this.currentUserDoc, @required this.chatName});

  bool workInProgress = false;
  final DocumentSnapshot chatDocument;
  final DocumentSnapshot currentUserDoc;
  final String chatName;

  TextEditingController textEditingController = new TextEditingController();
  ScrollController scrollController;
  var listMessages;
  File imageFile;
  String imageUrl;
  List<DocumentSnapshot> otherUsers;

  @override
  void initState() {
    super.initState();
    /*loadUserId().then((result) {
      setState(() {
        currentUserUid = result;
      });
      debugPrint("current User Id is " + currentUserUid);
    });*/

    loadUsers();
  }

  void loadUsers() async {
    otherUsers = new List<DocumentSnapshot>();
    chatDocument.reference.collection('users').getDocuments().then((docs) {
      docs.documents.remove(currentUserDoc);
      docs.documents.forEach((docRef) {
        docRef.data['userDoc'].get().then((doc) {
          this.setState(() {
            otherUsers.add(doc);
          });
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
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(chatName),
                margin: EdgeInsets.symmetric(horizontal: 10),
              )
            ],
          ),
        ),
        preferredSize: Size.fromHeight(75),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              buildListMessage(),

              // Input content
              buildInput(),
            ],
          ),
          workInProgress ? Container(
            child: Center(
                child: CircularProgressIndicator()
            ),
            color: Colors.transparent.withOpacity(0.8),
          ) : Container(),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.image),
                onPressed: displayImageGallery,
              ),
            ),
            color: Colors.white,
          ),
          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(),
                ),
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(top: new BorderSide(width: 0.5)), color: Colors.white),
    );
  }

  Future displayImageGallery() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        workInProgress = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        workInProgress = false;
        onSendMessage(imageUrl, 1);
      });

    }, onError: (err) {
      setState(() {
        workInProgress = false;
      });

    });

  }

  Widget buildListMessage() {
    return Flexible(
      child: chatDocument == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder(
        stream: Firestore.instance
            .collection('chats')
            .document(chatDocument.documentID)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(20)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator());
          } else {
            listMessages = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) => buildItem(index, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              reverse: true,
              controller: scrollController,
            );
          }
        },
      ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == currentUserDoc.documentID) {
      // Right (my message)
      return Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Text(currentUserDoc == null ? 'loading' : currentUserDoc.data['displayName']),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
          ),
          Row(
        children: <Widget>[
          document['type'] == 0
          // Text
              ? Container(
            child: Text(
              document['content'],
              style: TextStyle(color: Colors.white),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(color: AppColors.APP_BAR_BACKGROUND_COLOR, borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
          )
              : Container(
            child: Container(
              child: Material(
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    child: CircularProgressIndicator(),
                    width: 200.0,
                    height: 200.0,
                    padding: EdgeInsets.all(70.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Material(
                    child: Image.asset(
                      'images/img_not_available.jpeg',
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  ),
                  imageUrl: document['content'],
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                clipBehavior: Clip.hardEdge,
              ),
              padding: EdgeInsets.all(0),
            ),
            margin: EdgeInsets.only(bottom:  10.0, right: 10.0),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      )]);
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Text(getDisplayName(document.data['idFrom'])),
                      //otherUsers == null ? 'loading' : otherUsers.singleWhere((user) => user.documentID == document.data['idFrom']).data['displayName']),
                  //Text('loading')
                ],
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
            ),
            Row(
              children: <Widget>[
                document['type'] == 0
                    ? Container(
                  child: Text(
                    document['content'],
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(color: AppColors.APP_BAR_BACKGROUND_COLOR, borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(left: 10.0),
                )
                    : Container(
                  child: Container(
                    child: Material(
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(),
                          width: 200.0,
                          height: 200.0,
                          padding: EdgeInsets.all(70.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Material(
                          child: Image.asset(
                            'images/img_not_available.jpeg',
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          clipBehavior: Clip.hardEdge,
                        ),
                        imageUrl: document['content'],
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    padding: EdgeInsets.all(0),
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                )
              ],
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  String getDisplayName(String id) {
    if (otherUsers == null) {
      return 'loading';
    }
    DocumentSnapshot ss = otherUsers.singleWhere((user) => user.documentID == id);
    if (ss == null) {
      return 'loading';
    }
    return ss.data['displayName'];
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = Firestore.instance
          .collection('chats')
          .document(chatDocument.documentID)
          .collection('messages')
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': currentUserDoc.documentID,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });

      scrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }
}