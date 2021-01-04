import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app.dart';

class Chat extends StatefulWidget {
  static const String id = "CHAT";

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> callback(String docID, String uid) async {
    if (messageController.text.length > 0) {
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    //print(chats);
    var category;


    Future<void> _showMyDialog() async {

      var count = 0;

      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('✔️  Exit'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('채팅방 나가기'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.popUntil(context, (route) {
                    return count++ == 2;
                  });
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[100],
        title: Text("chat"),
        centerTitle: true,
        actions: <Widget>[],
      ),
      endDrawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Padding(
                padding: const EdgeInsets.only(top: 80, left: 5, bottom: 15),
                child: ListTile(
                  title: Text(
                    "chat",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blueAccent[100],
              ),
            ),
            Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: chats.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    List<dynamic> members;
                    members = snapshot.data['membersID'];
                    print(snapshot.data['membersID'].length);

                    return ListView.builder(
                        padding: EdgeInsets.only(top: 15),
                        itemCount: snapshot.data['membersID'].length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(members.elementAt(index).toString()),
                          );
                        });
                  },
                )),
            Container(
              // This align moves the children to the bottom
                color: Colors.blue[100],
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                        child: Column(
                          children: <Widget>[
                            Divider(height: 0),
                            ListTile(
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.exit_to_app,
                                  size: 30,
                                ),
                                onPressed: () {
                                  _showMyDialog();
                                  //removePinOrUser(arguments.docID, arguments.currentUID);
                                  //Navigator.of(context)
                                  //    .popUntil((route) => route.isFirst);
                                },
                              ),
                            )
                          ],
                        ))))
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chatRooms')
                    .doc(arguments.docID)
                    .collection('messages')
                    .orderBy('date')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  List<DocumentSnapshot> docs = snapshot.data.docs;

                  List<Widget> messages = docs
                      .map((doc) => Message(
                    from: doc['from'],
                    text: doc['text'],
                    me: arguments.currentUID == doc['from'],
                  ))
                      .toList();

                  return ListView(
                    controller: scrollController,
                    children: <Widget>[
                      ...messages,
                    ],
                  );
                },
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) =>
                          callback(arguments.docID, arguments.currentUID),
                      decoration: InputDecoration(
                        hintText: 'Enter a Message...',
                        border: const OutlineInputBorder(),
                      ),
                      controller: messageController,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: messageController.text.isEmpty
                          ? Colors.grey
                          : Colors.blue,
                    ),
                    onPressed: () {
                      callback(arguments.docID, arguments.currentUID);
                      messageController.clear();
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const SendButton({Key key, this.text, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.orange,
      onPressed: callback,
      child: Text(text),
    );
  }
}

class Message extends StatelessWidget {
  final String from;
  final String text;

  final bool me;

  const Message({Key key, this.from, this.text, this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(from);
    return Container(
      child: Column(
        crossAxisAlignment:
        me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            from,
          ),
          Container(
            margin: me ? EdgeInsets.only(right: 20) : EdgeInsets.only(left: 20),
            child: Material(
              color: me ? Colors.blueAccent[100] : Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0),
              elevation: 6.0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                child: Text(
                  text,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
