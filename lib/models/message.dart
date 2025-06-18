class Message {
  final String? content;
  final String? photo;
  final DateTime? time;

  final String? user_id;
  final String? chat_id;

  Message({
    required this.content,
    required this.user_id,
    required this.chat_id,
    required this.photo,
    required this.time,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'] ?? null,
      user_id: json['user_id'] ?? null,
      chat_id: json['chat_id'] ?? null,
      photo: json['photo'] ?? null,
      time: json['time'] == null ? null : DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() => {
        'content': content ?? null,
        'user_id': user_id ?? null,
        'chat_id': chat_id ?? null,
        'photo': photo ?? null,
        'time': time == null ? null : time!.toIso8601String(),
      };
}
