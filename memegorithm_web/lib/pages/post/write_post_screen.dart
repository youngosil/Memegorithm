import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';

class WritePostScreen extends StatefulWidget {
  static const routeName = '/home/write';
  const WritePostScreen({super.key});

  @override
  _WritePostState createState() => _WritePostState();
}

class _WritePostState extends State<WritePostScreen> {
  List<Widget> textFields = [];

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
                          fontFamily: 'Centennial',
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // 추가 버튼을 누를 때마다 새로운 텍스트 필드 추가
                                  setState(() {
                                    textFields.add(
                                      const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Enter your text',
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                                },
                                child: const Text('Add TextField'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // 추가 버튼을 누를 때마다 새로운 텍스트 필드 추가
                                  _pickImage();
                                },
                                child: const Text('Put Image'),
                              ),
                            ],
                          ),
                          textFields.isNotEmpty
                              ? textFields[0]
                              : const SizedBox()
                        ],
                      )),
                  const SizedBox(height: 30),
                ],
              ),
            )));
  }

  Future<void> _pickImage() async {
    final Image image = await ImagePickerWeb.getImageAsWidget() as Image;

    setState(() {
      textFields.add(image);
    });
  }
}
