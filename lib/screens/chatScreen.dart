// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:flutter_linkify/flutter_linkify.dart';
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';
//
//
// class ChatScreen extends StatefulWidget {
//   final String user;
//   final String userEmail;
//
//   ChatScreen({this.user, this.userEmail});
//
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController messageController = TextEditingController();
//   ScrollController _scrollController = ScrollController();
//   final user = "Purva Anjarlekar";
//
//   final List chats = [
//     {
//       "sender": "purva@gmail.com",
//       "message": "Hello",
//       "timestamp": DateTime.now(),
//     },
//     {
//       "sender": "abhay@gmail.com",
//       "message": "How you doin !",
//       "timestamp": DateTime.now(),
//     },
//     {
//       "sender": "purva@gmail.com",
//       "message": "I'm fine, wbu?",
//       "timestamp": DateTime.now(),
//     },
//     {
//       "sender": "abhay@gmail.com",
//       "message": "Kya batau, jindagi itti kharab chal rahi hai!",
//       "timestamp": DateTime.now(),
//     },
//   ];
//
//   _chatBubble(
//       UserCredentials authUser, Message message, bool isMe) {
//     if (isMe) {
//       return Column(
//         children: <Widget>[
//           Container(
//             alignment: Alignment.topRight,
//             child: Container(
//               constraints: BoxConstraints(
//                 maxWidth: MediaQuery.of(context).size.width * 0.80,
//               ),
//               padding: EdgeInsets.all(10),
//               margin: EdgeInsets.symmetric(vertical: 5),
//               decoration: BoxDecoration(
//                 // color: Theme.of(context).primaryColor,
//                 // color: Color(0xFFFEEFEC),
//                 color: Colors.cyan.shade100,
//                 borderRadius: BorderRadius.only(
//                   topRight: Radius.circular(15),
//                   topLeft: Radius.circular(15),
//                   bottomLeft: Radius.circular(15),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     spreadRadius: 1,
//                     blurRadius: 1,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Linkify(
//                     onOpen: (link) async {
//                       if (await canLaunch(link.url)) {
//                         await launch(link.url);
//                       } else {
//                         throw 'Could not launch $link';
//                       }
//                     },
//                     text: message.text,
//                     style: TextStyle(color: Colors.black87,),
//                     linkStyle: TextStyle(color: Colors.red.shade600),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     message.time,
//                     style: TextStyle(
//                       fontSize: 10.5,
//                       color: Colors.black45,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       );
//     } else {
//       return Column(
//         children: <Widget>[
//           Container(
//             alignment: Alignment.topLeft,
//             child: Container(
//               constraints: BoxConstraints(
//                 maxWidth: MediaQuery.of(context).size.width * 0.80,
//               ),
//               padding: EdgeInsets.all(10),
//               margin: EdgeInsets.symmetric(vertical: 5),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topRight: Radius.circular(15),
//                   topLeft: Radius.circular(15),
//                   bottomRight: Radius.circular(15),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.3),
//                     spreadRadius: 1,
//                     blurRadius: 1,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Linkify(
//                     onOpen: (link) async {
//                       if (await canLaunch(link.url)) {
//                         await launch(link.url);
//                       } else {
//                         throw 'Could not launch $link';
//                       }
//                     },
//                     text: message.text,
//                     style: TextStyle(color: Colors.black87,),
//                     linkStyle: TextStyle(color: Colors.red.shade600),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     message.time,
//                     style: TextStyle(
//                       fontSize: 10.5,
//                       color: Colors.black45,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       );
//     }
//   }
//
//   _sendMessageArea(UserCredentials authUser) {
//     return Container(
//       padding: EdgeInsets.all(8),
//       height: 70,
//       color: Colors.white,
//       child: Row(
//         children: <Widget>[
//           IconButton(
//             icon: Icon(Icons.photo),
//             iconSize: 25,
//             color: Theme.of(context).primaryColor,
//             onPressed: () {},
//           ),
//           Expanded(
//             child: TextField(
//               onTap: () {
//                 Timer(
//                     Duration(milliseconds: 300),
//                         () => _scrollController
//                         .jumpTo(_scrollController.position.maxScrollExtent));
//               },
//
//               minLines: 1, //Normal textInputField will be displayed
//               maxLines: 7,
//               controller: messageController,
//               decoration: InputDecoration.collapsed(
//                 hintText: 'Send a message...',
//               ),
//               textCapitalization: TextCapitalization.sentences,
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.send),
//             iconSize: 25,
//             color: Theme.of(context).primaryColor,
//             onPressed: () async {
//               var message = messageController.text.trim();
//               setState(() {
//                 messageController.clear();
//               });
//               Timer(
//                   Duration(milliseconds: 500),
//                       () => _scrollController
//                       .jumpTo(_scrollController.position.maxScrollExtent));
//               if (message != "") {
//                 await FirebaseFirestore.instance
//                     .collection("Users")
//                     .doc(authUser.email)
//                     .collection("Chats")
//                     .doc(widget.userEmail)
//                     .update({
//                   "chats": FieldValue.arrayUnion(
//                     [
//                       {
//                         "message": message,
//                         "sender": authUser.email,
//                         "timestamp": DateTime.now(),
//                       }
//                     ],
//                   ),
//                 });
//                 await FirebaseFirestore.instance
//                     .collection("Users")
//                     .doc(widget.userEmail)
//                     .collection("Chats")
//                     .doc(authUser.email)
//                     .update({
//                   "chats": FieldValue.arrayUnion([
//                     {
//                       "message": message,
//                       "sender": authUser.email,
//                       "timestamp": DateTime.now(),
//                     }
//                   ])
//                 });
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Timer(
//       Duration(milliseconds: 200),
//           () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent),
//     );
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.grey[100],
//         appBar: AppBar(
//           brightness: Brightness.dark,
//           centerTitle: true,
//           title: RichText(
//             textAlign: TextAlign.center,
//             text: TextSpan(
//               text: user,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//           leading: IconButton(
//               icon: Icon(Icons.arrow_back_ios),
//               color: Colors.white,
//               onPressed: () {
//                 Navigator.pop(context);
//               }),
//         ),
//         body: Column(
//           children: <Widget>[
//             StreamBuilder(
//                 stream: FirebaseFirestore.instance
//                     .collection("Users")
//                     .doc(authUser.email)
//                     .collection("Chats")
//                     .doc(widget.userEmail)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     var docRef = snapshot.data;
//                     var messages = docRef["chats"];
//                     return Expanded(
//                       child: ListView.builder(
//                         controller: _scrollController,
//                         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                         itemCount: messages.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           var timestamp =
//                           messages[index]["timestamp"].toDate().toString();
//                           final DateTime docDateTime =
//                           DateTime.parse(timestamp);
//                           var time =
//                           DateFormat("dd MMM HH:mm").format(docDateTime);
//                           final Message message = Message(
//                               sender: messages[index]["sender"],
//                               text: messages[index]["message"],
//                               time: time,
//                               unread: false);
//                           final bool isMe =
//                               messages[index]["sender"] == authUser.email;
//                           prevUserId = messages[index]["sender"];
//                           return _chatBubble(
//                               authUser, message, isMe);
//                         },
//                       ),
//                     );
//                   }
//                   if (snapshot.hasError) {
//                     return Center(
//                       child: Text("Please check your internet connection"),
//                     );
//                   }
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }),
//             _sendMessageArea(authUser),
//           ],
//         ),
//       ),
//     );
//   }
// }
