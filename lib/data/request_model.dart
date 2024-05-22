class RequestModel {
  String? receiveName;
  int? request_id;
  String? sender;
  String? receive;
  String? comment;
  String? reply;
  bool? isFinish;
  RequestModel({
    this.receiveName,
    this.request_id,
    this.sender,
    this.receive,
    this.comment,
    this.reply,
    this.isFinish = false,
  });
  Map<String, dynamic> toJson() {
    return {
      'receiveName': receiveName,
      'request_id': request_id,
      'sender': sender,
      'receive': receive,
      'comment': comment,
      'reply': reply,
      'isFinish': isFinish
    };
  }
}
