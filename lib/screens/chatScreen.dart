import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:taskbuddy/utils/messageModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  final String user;
  final String userEmail;
  ChatScreen({this.user, this.userEmail});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  final userId = "my_secret_user_id";
  final targetId = "target_users_secret_user_id";
  IO.Socket socket;
  List<MessageModel> messages = [];

  void connect() {
    // TODO: Replace the connection url with the actual server url
    socket = IO.io("http://localhost:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();

    // TODO: Replace the "userId" with the unique user id provided while signing up then user
    socket.emit("signin", userId);

    socket.onConnect((data) {
      print("connected $data");
      socket.on("message", (data) {
        setMessage("destination", data["message"]);
      });
    });
    // Or we can do
    // print(socket.connected); // returns bool for connection status
  }

  @override
  void initState() {
    super.initState();
    connect();
  }

  void sendMessage(String message, dynamic sourceId, dynamic targetId) {
    setMessage("source", message);
    socket.emit("message",
        {"message": message, "sourceId": sourceId, "targetId": targetId});
  }

  void setMessage(String type, String message) {
    MessageModel messageModel = MessageModel(type: type, message: message);
    setState(() {
      messages.add(messageModel);
    });
  }

  _chatBubble(MessageModel model) {
    if (model.type == "source") {
      // Returns chat bubble aligned to the right side of the screen
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                // color: Color(0xFFFEEFEC),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.white.withOpacity(0.2),
                //     spreadRadius: 1,
                //     blurRadius: 1,
                //   ),
                // ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Linkify(
                    onOpen: (link) async {
                      if (await canLaunch(link.url)) {
                        await launch(link.url);
                      } else {
                        throw 'Could not launch $link';
                      }
                    },
                    text: model.message,
                    linkStyle: TextStyle(color: Colors.blue.shade600),
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // Text(
                  //   model.time,
                  //   style: TextStyle(
                  //     fontSize: 10.5,
                  //     color: Colors.black45,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      // return chat bubble aligned to the right side of the screen
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.3),
                //     spreadRadius: 1,
                //     blurRadius: 1,
                //   ),
                // ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Linkify(
                    onOpen: (link) async {
                      if (await canLaunch(link.url)) {
                        await launch(link.url);
                      } else {
                        throw 'Could not launch $link';
                      }
                    },
                    text: model.message,
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                    linkStyle: TextStyle(color: Colors.blue.shade600),
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // Text(
                  //   message.time,
                  //   style: TextStyle(
                  //     fontSize: 10.5,
                  //     color: Colors.black45,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  _sendMessageArea() {
    return Container(
      padding: EdgeInsets.all(8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              onTap: () {
                Timer(
                    Duration(milliseconds: 300),
                    () => _scrollController
                        .jumpTo(_scrollController.position.maxScrollExtent));
              },

              minLines: 1, //Normal textInputField will be displayed
              maxLines: 7,
              controller: messageController,
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              var message = messageController.text.trim();
              setState(() {
                messageController.clear();
              });
              Timer(
                  Duration(milliseconds: 500),
                  () => _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent));
              if (message != "") {
                sendMessage(message, userId, targetId);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(milliseconds: 200),
      () =>
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          brightness: Brightness.dark,
          centerTitle: true,
          title: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "Target User Name",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Column(
          children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _chatBubble(messages[index]);
              },
            ),

            // TextField and Send button
            _sendMessageArea(),

          ],
        ),
      ),
    );
  }
}
