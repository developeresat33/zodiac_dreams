class RequestModel {
  String? receiveName;
  String? request_uid;
  String? sender_uid;
  String? receive_uid;

  String? senderName;

  String? comment;
  String? reply;
  bool? isFinish;
  DateTime? created_at;
  RequestModel({
    this.receiveName,
    this.request_uid,
    this.sender_uid,
    this.receive_uid,
    this.senderName,
    this.comment,
    this.reply,
    this.isFinish = false,
    this.created_at,
  });
  Map<String, dynamic> toJson() {
    return {
      'receiveName': receiveName,
      'senderName': senderName,
      'comment': comment,
      'reply': reply,
      'isFinish': isFinish,
      'sender_uid': sender_uid,
      'receive_uid': receive_uid,
      'request_uid': request_uid,
      'created_at': created_at
    };
  }
}
