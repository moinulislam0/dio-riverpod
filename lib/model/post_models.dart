// lib/models/post_model.dart
class PostModel {
  final int? id;
  final int userId;
  final String title;
  final String body;

  PostModel({
    this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  // Server থেকে আসা JSON কে Object বানায়
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
    );
  }

  // Object কে JSON বানায় (Server এ পাঠানোর জন্য)
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
    };
  }
}