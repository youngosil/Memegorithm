class Content {
  final String type;
  final String content;

  Content({
    required this.type,
    required this.content,
  });

  factory Content.fromMap(Map<String, dynamic> map) {
    return Content(
      type: map['type'] ?? '',
      content: map['content'] ?? '',
    );
  }
}
