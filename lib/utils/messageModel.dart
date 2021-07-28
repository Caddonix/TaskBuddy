class MessageModel {
  String type; // "source" or "destination" to align it on the UI
  String message;
  MessageModel({required this.message, required this.type});
}