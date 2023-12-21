import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memegorithm_web/firebase_authentication.dart';
import 'package:memegorithm_web/models/content.dart';
import 'package:memegorithm_web/models/post.dart';
import 'package:memegorithm_web/pages/post/write_post_screen.dart';

import 'post/post_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  final User user;
  final AuthenticationService _authService;

  const HomeScreen({
    Key? key,
    required this.user,
    required AuthenticationService authService,
  })  : _authService = authService,
        super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Post> posts;

  @override
  void initState() {
    super.initState();
    // Fetch posts when the HomeScreen is initialized
    _fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/memegorithm_base.png'),
                    fit: BoxFit.cover)),
            child: Container(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 30),
                    child: const Text(
                      '밈고리즘',
                      style: TextStyle(
                          fontSize: 50,
                          fontFamily: 'Chanel',
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.user.email}님의 블로그',
                        style: const TextStyle(
                            fontSize: 30,
                            fontFamily: 'Gulim',
                            color: Colors.black),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          widget._authService.signOut();
                        },
                        child: const Text('로그아웃',
                            style: TextStyle(
                                fontFamily: 'Gulim', color: Colors.black)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                      child: FutureBuilder(
                          future: _fetchPosts(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              List<Post> posts = snapshot.data as List<Post>;

                              return ListView.builder(
                                itemCount: posts.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: const SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: Image(
                                            image: AssetImage(
                                                'images/file_icon.png'),
                                            fit: BoxFit.fill)),
                                    title: Text(posts[index].title),
                                    // 글을 눌렀을 때 글 상세 페이지로 이동하는 로직 추가
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PostDetailScreen(
                                                      post: posts[index])));
                                    },
                                  );
                                },
                              );
                            }
                          })),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WritePostScreen(
                                user: widget.user,
                                authService: widget._authService)),
                      );
                    },
                    child: const Text('글쓰기',
                        style: TextStyle(
                            fontFamily: 'Gulim', color: Colors.black)),
                  ),
                ],
              ),
            )));
  }

  Future<List<Post>> _fetchPosts() async {
    List<Post> posts = [];

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('posts')
              .where('user', isEqualTo: widget.user.email)
              .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in querySnapshot.docs) {
        // Access the data from the document
        Map<String, dynamic> data = documentSnapshot.data();

        // Create a Post instance
        Post post = Post.fromMap(data);
        posts.add(post);
      }

      // TODO: Use the 'posts' list in your application logic
    } catch (error) {
      print('Error fetching posts: $error');
    }

    return posts;
  }
}
