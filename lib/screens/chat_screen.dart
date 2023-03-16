import 'package:flutter/material.dart';
import 'package:massanger/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User logInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final massageTextControllor = TextEditingController();
  final _auth = FirebaseAuth.instance;

  late String massageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        logInUser = user;
        print(logInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void massageStreem() async {
    await for (var sanpshot in _firestore.collection('massages').snapshots()) {
      for (var massage in sanpshot.docs) {
        print(massage.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                massageStreem();
                // _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MassagesStreem(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: massageTextControllor,
                      onChanged: (value) {
                        massageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      massageTextControllor.clear();
                      _firestore.collection('massages').add({
                        'text': massageText,
                        'sender': logInUser.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MassagesStreem extends StatelessWidget {
  const MassagesStreem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('massages').snapshots(),
      builder: (context, snapshot) {
        List<MasssageBuble> massageBubbles = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final massages = snapshot.data?.docs.reversed;
        for (var massage in massages!) {
          final data = massage.data() as Map;
          final massageText = data['text'];
          final massageSender = data['sender'];

          final currentUser = logInUser.email;


          final massageBuble = MasssageBuble(
            text: massageText,
            sender: massageSender,
            isMe: currentUser == massageSender,
          );
          massageBubbles.add(massageBuble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: massageBubbles,
          ),
        );
      },
    );
  }
}

class MasssageBuble extends StatelessWidget {
  MasssageBuble({required this.text, required this.sender, required this.isMe});
  final String text;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
          Material(
            borderRadius: isMe ? BorderRadius.only(
              topLeft:  Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ) :BorderRadius.only(
              topRight:  Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            elevation: 5,
            color:isMe ? Colors.lightBlueAccent : Colors.blueGrey.shade200,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text,
                style:  TextStyle(
                  fontSize: 20,
                  color: isMe ?Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// StreamBuilder(
//     stream: _firestore.collection('massages').snapshots(),
//     builder: (context, snapshot) {
//       if (!snapshot.hasData) {
//         return Center(child: CircularProgressIndicator());
//       }
//       List <Text> widgets = [];
//       for (var doc in snapshot.data!.docs) {
//         widgets.add(
//           Text("${doc['text']} from ${doc['sender']}"),
//         );
//       }
//       return Column(children: widgets);
//     }),
