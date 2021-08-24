class MessageModel {
  String type; // "source" or "destination" to align it on the UI
  String message;
  String time;
  MessageModel({required this.message, required this.type,required this.time});
}