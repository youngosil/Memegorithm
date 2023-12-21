class Content {
  final String type;
  final String content;

  Content({
    required this.type,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'content': content
      // Add other fields as needed
    };
  }

  factory Content.fromMap(Map<String, dynamic> map) {
    return Content(
      type: map['type'] ?? '',
      content: map['content'] ?? '',
    );
  }
}
