class Chat {
  final int id;
  final int userId;
  final String userName;
  final String? lastMessage;
  final DateTime lastMessageAt;
  final int unreadCount;

  Chat({
    required this.id,
    required this.userId,
    required this.userName,
    this.lastMessage,
    required this.lastMessageAt,
    required this.unreadCount,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: int.tryParse(json['id'].toString()) ?? 0,
      userId:  int.tryParse(json['user_id'].toString()) ?? 0,
      userName: json['user_name'] ?? '',
      lastMessage: json['last_message'] ?? '',
      lastMessageAt: DateTime.parse(json['last_message_at'] ?? '1970-01-01T00:00:00.000Z'), 
      unreadCount:int.tryParse(json['unreadCount'].toString()) ?? 0,
    );
  }
  Chat copyWith({
  int? id,
  int? userId,
  String? userName,
  String? lastMessage,
  DateTime? lastMessageAt,
  int? unreadCount,
}) {
  return Chat(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    userName: userName ?? this.userName,
    lastMessage: lastMessage ?? this.lastMessage,
    lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    unreadCount: unreadCount ?? this.unreadCount,
  );
}
}