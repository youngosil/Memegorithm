
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:memegorithm_web/models/content.dart';
import 'package:memegorithm_web/models/post.dart';

class PostDetailScreen extends StatelessWidget {
  static const routeName = '/home/post';
  final Post post;

  const PostDetailScreen({Key? key, required this.post}) : super(key: key);

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
                  Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        children: [
                          Text(post.title),
                          Text(post.user),
                          SizedBox(
                              height: 500,
                              child: ListView.builder(
                                itemCount: post.contents.length,
                                itemBuilder: (context, index) {
                                  return getContentWidget(post.contents[index]);
                                },
                              ))
                        ],
                      )),
                  const SizedBox(height: 30),
                ],
              ),
            )));
  }

  Future<Widget> getImage(String imageName) async {
    final ref = FirebaseStorage.instance.ref().child(imageName);

    try {
      var url = await ref.getDownloadURL();
      return Image.network(url, width: 100, height: 100);
    } catch (e) {
      print('Error loading image: $e');
      return const Text(
          'Error loading image'); // Return a placeholder or handle the error accordingly
    }
  }

  Widget getContentWidget(Content content) {
    if (content.type == 'text') {
      return Text(content.content);
    } else {
      return FutureBuilder<Widget>(
        future: getImage(content.content),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data ?? Container(); // Return the image widget
          } else {
            return const CircularProgressIndicator(); // Show a loading indicator while fetching the image
          }
        },
      );
    }
  }
}
