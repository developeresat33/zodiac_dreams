class RequestModel {
  String? receiveName;
  String? request_uid;
  String? sender_uid;
  String? receive_uid;
  bool? isQuestionAsked;
  String? senderName;
  String? comment;
  String? reply;
  String? question;
  String? replyQuestion;
  bool? isFinish;
  bool? isRated;
  DateTime? created_at;
  double? rate;
  RequestModel(
      {this.receiveName,
      this.request_uid,
      this.sender_uid,
      this.receive_uid,
      this.senderName,
      this.comment,
      this.reply,
      this.isFinish = false,
      this.isQuestionAsked = false,
      this.isRated = false,
      this.created_at,
      this.question,
      this.replyQuestion,
      this.rate = 0.0});
  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'receiveName': receiveName,
      'senderName': senderName,
      'comment': comment,
      'reply': reply,
      'isFinish': isFinish,
      'sender_uid': sender_uid,
      'receive_uid': receive_uid,
      'request_uid': request_uid,
      'created_at': created_at,
      'isQuestionAsked': isQuestionAsked,
      'reply_question': replyQuestion,
      'question': question,
      'isRated': isRated
    };
  }
}
