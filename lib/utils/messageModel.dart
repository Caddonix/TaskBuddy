class MessageModel {
  String type; // "source" or "destination" to align it on the UI
  String message;
  MessageModel({this.message, this.type});
}