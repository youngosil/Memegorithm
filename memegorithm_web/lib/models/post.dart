import 'package:memegorithm_web/models/content.dart';

class Post {
  final String user;
  final String title;
  List<Content> contents;

  Post({
    required this.user,
    required this.title,
    required this.contents,
  });

  // Factory method to create a Post instance from a map
  factory Post.fromMap(Map<String, dynamic> map) {
    // Convert 'contents' from List<dynamic> to List<Content>
    List<Content> contents = (map['contents'] as List?)
            ?.map(
              (contentMap) => Content.fromMap(contentMap),
            )
            .toList() ??
        [];

    return Post(
      user: map['user'] ?? '',
      title: map['title'] ?? '',
      contents: contents,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'user': user,
      'contents': contents.map((content) => content.toMap()).toList(),
      // Add other fields as needed
    };
  }
}
