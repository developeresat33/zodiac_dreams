class RequestModel {
  String? receiveName;
  String? request_uid;
  String? sender_uid;
  String? receive_uid;
  String? sender;
  String? senderName;
  String? receive;
  String? comment;
  String? reply;
  bool? isFinish;
  RequestModel({
    this.receiveName,
    this.request_uid,
    this.sender_uid,
    this.receive_uid,
    this.sender,
    this.senderName,
    this.receive,
    this.comment,
    this.reply,
    this.isFinish = false,
  });
  Map<String, dynamic> toJson() {
    return {
      'receiveName': receiveName,
      'sender': sender,
      'senderName': senderName,
      'receive': receive,
      'comment': comment,
      'reply': reply,
      'isFinish': isFinish,
      'sender_uid': sender_uid,
      'receive_uid': receive_uid,
      'request_uid': request_uid
    };
  }
}
