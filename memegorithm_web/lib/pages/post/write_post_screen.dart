import 'dart:io';
import 'dart:js_util';
import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:memegorithm_web/firebase_authentication.dart';
import 'package:memegorithm_web/models/content.dart';
import 'package:memegorithm_web/models/post.dart';

class WritePostScreen extends StatefulWidget {
  static const routeName = '/home/write';
  final User user;
  final AuthenticationService _authService;

  const WritePostScreen({
    Key? key,
    required this.user,
    required AuthenticationService authService,
  })  : _authService = authService,
        super(key: key);

  @override
  _WritePostState createState() => _WritePostState();
}

class _WritePostState extends State<WritePostScreen> {
  List<Widget> widgetList = [];
  List<String> contentList = [];
  List<TextEditingController> textControllers = [];
  List<File> imgList = [];

  final TextEditingController titleController = TextEditingController();
  String selectedValue = '';

  final TextEditingController _textEditingController = TextEditingController();
  String selectedText = '';
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();

    // Add a listener to the TextEditingController
    _textEditingController.addListener(_updateSelectedText);
  }

  @override
  void dispose() {
    // Dispose of the TextEditingController when not needed
    for (var controller in textControllers) {
      controller.dispose();
    }
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/memegorithm_base.png'),
                    fit: BoxFit.cover)),
            child: SingleChildScrollView(
                child: Container(
              constraints:
                  BoxConstraints(minHeight: MediaQuery.of(context).size.height),
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
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height - 150),
                      padding: const EdgeInsets.symmetric(
                          vertical: 50, horizontal: 40),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        children: [
                          SizedBox(
                              child: TextField(
                                  controller: titleController,
                                  decoration: const InputDecoration(
                                    hintText: '제목',
                                    hintStyle: TextStyle(
                                        fontFamily: 'Gulim',
                                        color: Colors.grey),
                                  ),
                                  style: const TextStyle(
                                      fontFamily: 'Gulim',
                                      color: Colors.black))),
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextField(
                              controller: _textEditingController,
                              decoration: const InputDecoration(
                                hintText: 'Type something...',
                              ),
                              maxLines: 10,
                            ),
                          ),
                          Column(children: widgetList),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _addTextField();
                                },
                                child: const Text('글 추가',
                                    style: TextStyle(
                                        fontFamily: 'Gulim',
                                        color: Colors.black)),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _pickImage();
                                },
                                child: const Text('이미지추가',
                                    style: TextStyle(
                                        fontFamily: 'Gulim',
                                        color: Colors.black)),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: _submitPost,
                            child: const Text('저장하기',
                                style: TextStyle(
                                    fontFamily: 'Gulim', color: Colors.black)),
                          ),
                        ],
                      )),
                  const SizedBox(height: 30),
                ],
              ),
            ))));
  }

  void _addTextField() {
    //File file = newObject();
    /*setState(() {
      widgetList.add(
        const TextField(
          decoration: InputDecoration(
            hintText: 'Enter text...',
          ),
        ),
      );
      contentList.add('');
      //imgList.add(file);*/

    TextEditingController controller = TextEditingController();
    textControllers.add(controller);

    setState(() {
      widgetList.add(
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter text...',
          ),
          onChanged: (text) {
            // Update the contentList when the text changes
            int index = textControllers.indexOf(controller);
            if (index >= 0 && index < contentList.length) {
              contentList[index] = text;
            }
          },
        ),
      );
      contentList.add('');
    });
  }

  /*Future<Uint8List?> getFileUint8List(File file) async {
    final completer = Completer<Uint8List>();

    final reader = FileReader();

    // Set up the callback for when the file has been loaded
    reader.onLoad.listen((_) {
      // Convert the result to Uint8List
      final Uint8List uint8List =
          Uint8List.fromList(reader.result as List<int>);
      completer.complete(uint8List);
    });

    // Read the file as an array buffer
    reader.readAsArrayBuffer(file);

    // Wait for the file to be loaded
    try {
      return await completer.future;
    } catch (e) {
      print('Error reading file: $e');
      return null;
    }
  }*/

  Future<void> _pickImage() async {
    /*File imgFile = ImagePickerWeb.getImageAsFile() as File;
    String name = 'test1';

    setState(() {
      widgetList.add(image!);
      contentList.add(image.toString());
      //imgList.add(imageFile);
    });*/
  }

  /*Future<void> _pickImage() async {
    File? imageFile =
        (await ImagePickerWeb.getMultiImagesAsFile())?[0] as File?;
    final name = imageFile?.readAsString();

    setState(() {
      widgetList.add(Image.file(imageFile!));
      contentList.add(name as String);
      imgList.add(imageFile);
    });
  }*/

  void _submitPost() async {
    List<Content> contents = [];

    for (int i = 0; i < widgetList.length; i++) {
      var content = widgetList[i];
      if (content is TextField) {
        // Text content
        contents.add(Content(type: 'text', content: textControllers[i].text));
      } else if (content is Image) {
        // Image content
        // Upload image to Firebase Storage and get the download URL
        contents.add(Content(type: 'image', content: contentList[i]));
        _uploadImage(contentList[i], imgList[i]);
      }
    }

    Post post = Post(
        title: titleController.text,
        user: widget.user.email ?? '',
        contents: contents);

    // Now, you have title and contents
    // Call your FirebaseService to upload the post
    try {
      await FirebaseFirestore.instance.collection('posts').add(post.toMap());
      // Successfully added post to Firestore
    } catch (error) {
      print('Error uploading post to Firestore: $error');
    }
  }

  void _uploadImage(String name, File data) async {
    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();

    // Create a reference to "mountains.jpg"
    final mountainsRef = storageRef.child(name);

    // Create a reference to 'images/mountains.jpg'
    final mountainImagesRef = storageRef.child(data.toString());

    // While the file names are the same, the references point to different files
    assert(mountainsRef.name == mountainImagesRef.name);
    assert(mountainsRef.fullPath != mountainImagesRef.fullPath);

    try {
      // Upload raw data.
      await mountainsRef.putFile(data);
    } catch (e) {
      print("Error: uploading image to Firestore");
    }
  }

  void _updateSelectedText() {
    // Cancel the previous debounce timer
    _debounceTimer?.cancel();

    // Create a new debounce timer
    _debounceTimer = Timer(const Duration(milliseconds: 700), () {
      // Get the selection
      TextSelection selection = _textEditingController.selection;

      // Check if there is any selection
      if (selection.end != null) {
        // Extract the selected text
        String newText = _textEditingController.text
            .substring(selection.start, selection.end);

        // Check if the text has changed
        if (newText != selectedText) {
          selectedText = newText;
          Future<String> res = sendPostRequest(selectedText);
          setState(() {
            print('Selected Text Changed: $selectedText');
            print(res);
          });
        }
      } else {
        // No selection
        if (selectedText.isNotEmpty) {
          selectedText = '';
          setState(() {
            print('Selected Text Changed: $selectedText');
          });
        }
      }
    });
  }

  Future<String> sendPostRequest(String message) async {
    String url = 'http://165.132.46.82:30527/';
    Map<String, String> headers = {"Content-Type": "application/json"};
    //Map<String, dynamic> data = {'text': message};
    String jsonBody = json.encode({'text': message});

    // POST 요청을 보내고 응답을 받음
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    print(utf8.decode(response.bodyBytes));
    return utf8.decode(response.bodyBytes);
  }
}
