import 'dart:convert';
import 'dart:js_interop';

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
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/memegorithm_base.png'),
                    fit: BoxFit.cover)),
            child: SingleChildScrollView(
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
                      width: 800,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        verticalDirection: VerticalDirection.down,
                        children: [
                          const SizedBox(height: 30),
                          Text(post.title,
                              style: const TextStyle(
                                  fontFamily: 'Gulim',
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 700, // SizedBox의 width를 800으로 제한
                            child: Text(
                              post.user,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                  fontFamily: 'Gulim', fontSize: 15),
                            ),
                          ),
                          const SizedBox(height: 50),
                          SizedBox(
                              child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: post.contents.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  getContentWidget(post.contents[index]),
                                  const SizedBox(
                                      height:
                                          5), // 각 아이템 사이에 간격을 주기 위한 SizedBox
                                ],
                              );
                            },
                          ))
                        ],
                      )),
                  const SizedBox(height: 30),
                ],
              ),
            ))));
  }

  Future<Widget> getImage(String imageName) async {
    final ref = FirebaseStorage.instance.ref().child('$imageName.jpg');

    try {
      var url = await ref.getDownloadURL();
      print(url);
      return Image.network(url, width: 250, height: 250);
    } catch (e) {
      print('Error loading image: $e');
      return const Text(
          'Error loading image'); // Return a placeholder or handle the error accordingly
    }
  }

  Widget getContentWidget(Content content) {
    if (content.type == 'text') {
      return Text(content.content,
          textAlign: TextAlign.center,
          style: const TextStyle(fontFamily: 'Gulim', fontSize: 18));
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
