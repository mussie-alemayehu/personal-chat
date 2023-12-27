class Message {
  final String sentBy;
  final DateTime time;
  final String? text;
  final String? image;

//  final String? videoMessage;

  const Message({
    required this.sentBy,
    required this.time,
    this.text,
    this.image,
    // this.videoMessage,
  });
}
