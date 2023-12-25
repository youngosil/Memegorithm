import 'dart:io';
import 'dart:js_util';
import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:html' as html;

import 'package:flutter/services.dart';
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
import 'package:memegorithm_web/pages/home_screen.dart';

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

  final TextEditingController titleController = TextEditingController();
  String selectedText = '';
  String textContent = '';
  Timer? _debounceTimer;

  @override
  void dispose() {
    // Dispose of the TextEditingController when not needed
    for (var controller in textControllers) {
      controller.dispose();
    }
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
                                      color: Colors.black,
                                      fontSize: 30))),
                          const SizedBox(height: 30),
                          Column(children: widgetList),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _addTextField();
                                },
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all<Size>(
                                      const Size(110, 30)),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.grey), // 배경색
                                  elevation: MaterialStateProperty.all<double>(
                                      1), // 그림자
                                  padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(vertical: 10),
                                  ), // 내부 여백
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    const RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.black), // 테두리 색
                                    ),
                                  ),
                                ),
                                child: const Text('글 추가',
                                    style: TextStyle(
                                        fontFamily: 'Gulim',
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _pickImage();
                                },
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all<Size>(
                                      const Size(110, 30)),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.grey), // 배경색
                                  elevation: MaterialStateProperty.all<double>(
                                      1), // 그림자
                                  padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(vertical: 10),
                                  ), // 내부 여백
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    const RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.black), // 테두리 색
                                    ),
                                  ),
                                ),
                                child: const Text('이미지 추가',
                                    style: TextStyle(
                                        fontFamily: 'Gulim',
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),
                          ElevatedButton(
                            onPressed: () {
                              _submitPost();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                          user: widget.user,
                                          authService: widget._authService)));
                            },
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all<Size>(
                                  const Size(110, 30)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.grey), // 배경색
                              elevation:
                                  MaterialStateProperty.all<double>(1), // 그림자
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 16),
                              ), // 내부 여백
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                const RoundedRectangleBorder(
                                  side:
                                      BorderSide(color: Colors.black), // 테두리 색
                                ),
                              ),
                            ),
                            child: const Text('저장하기',
                                style: TextStyle(
                                    fontFamily: 'Gulim',
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      )),
                  const SizedBox(height: 30),
                ],
              ),
            ))));
  }

  void _addTextField() {
    TextEditingController controller = TextEditingController();
    textControllers.add(controller);

    controller.addListener(() {
      _updateSelectedText(controller);
    });

    /*setState(() {
      widgetList.add(
        Theme(
            data: Theme.of(context).copyWith(
                textSelectionTheme: const TextSelectionThemeData(
                    selectionColor: Color(0xffFFFF00))),
            child: TextField(
                controller: controller,
                onChanged: (text) {
                  // Update the contentList when the text changes
                  int index = textControllers.indexOf(controller);
                  if (index >= 0 && index < contentList.length) {
                    contentList[index] = text;
                  }
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '내용을 입력하세요...',
                  hintStyle: TextStyle(fontFamily: 'Gulim', color: Colors.grey),
                ),
                style: const TextStyle(
                    fontFamily: 'Gulim', color: Colors.black, fontSize: 18),
                cursorColor: Colors.black,
                maxLines: 5)),
      );
      contentList.add('');
    });*/
    setState(() {
      widgetList.add(
        TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '내용을 입력하세요...',
              hintStyle: TextStyle(fontFamily: 'Gulim', color: Colors.grey),
            ),
            style: const TextStyle(
                fontFamily: 'Gulim', color: Colors.black, fontSize: 18),
            cursorColor: Colors.black,
            maxLines: 5,
            onChanged: (text) {
              // Update the contentList when the text changes
              int index = textControllers.indexOf(controller);
              if (index >= 0 && index < contentList.length) {
                contentList[index] = text;
              }
            }),
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
    // Use File? instead of File
    html.File? imgFile = (await ImagePickerWeb.getImageAsFile());

    if (imgFile != null) {
      String name = await _uploadImage(imgFile);
      Widget image = await getImage(name);

      setState(() {
        widgetList.add(image);
        contentList.add(name);
      });
    }
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

  Future<Widget> getImage(String imageName) async {
    final ref = FirebaseStorage.instance.ref().child('$imageName.jpg');

    try {
      var url = await ref.getDownloadURL();
      print(url);
      return Image.network(url, width: 300);
    } catch (e) {
      print('Error loading image: $e');
      return const Text(
          'Error loading image'); // Return a placeholder or handle the error accordingly
    }
  }

  void _submitPost() async {
    List<Content> contents = [];

    print(widgetList.length);
    print(contentList.length);

    int j = 0;
    for (int i = 0; i < widgetList.length; i++) {
      var content = widgetList[i];
      if (content is TextField) {
        // Text content
        contents.add(Content(type: 'text', content: textControllers[j].text));
        j++;
      } else if (content is Image) {
        // Image content
        // Upload image to Firebase Storage and get the download URL
        contents.add(Content(type: 'image', content: contentList[i]));
      }
    }

    Post post = Post(
        title: titleController.text,
        user: widget.user.email ?? '',
        contents: contents);

    // Now, you have title and contents
    // Call your FirebaseService to upload the post
    try {
      print('check');
      await FirebaseFirestore.instance.collection('posts').add(post.toMap());
      // Successfully added post to Firestore
    } catch (error) {
      print('Error uploading post to Firestore: $error');
    }
  }

  Future<String> _uploadImage(html.File data) async {
    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();

    String name = '${Random().nextInt(10000) + 1336}';
    print(name);

    // Create a reference to "mountains.jpg"
    final mountainsRef = storageRef.child('$name.jpg');
    print(mountainsRef);

    // Create a reference to 'images/mountains.jpg'
    final mountainImagesRef = storageRef.child(name);

    // While the file names are the same, the references point to different files
    //assert(mountainsRef.name == mountainImagesRef.name);
    //assert(mountainsRef.fullPath != mountainImagesRef.fullPath);

    try {
      // Upload raw data.
      await mountainsRef.putBlob(data);
      return name;
    } catch (e) {
      print("Error: uploading image to Firestore");
      return "";
    }
  }

  void _updateSelectedText(TextEditingController controller) {
    // Cancel the previous debounce timer
    _debounceTimer?.cancel();

    // Create a new debounce timer
    _debounceTimer = Timer(const Duration(milliseconds: 700), () {
      // Get the selection
      TextSelection selection = controller.selection;

      // Check if there is any selection
      if (selection.end != null) {
        // Extract the selected text
        String newText =
            controller.text.substring(selection.start, selection.end);

        // Check if the text has changed
        if (newText != selectedText && newText != "") {
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
    // String url = 'http://165.132.46.82:30527/'; // When using vessl
    String url = 'https://memegorithm.ngrok.io/'; // When using ngrok
    Map<String, String> headers = {"Content-Type": "application/json"};
    String jsonBody = json.encode({'text': message});

    // POST 요청을 보내고 응답을 받음
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    var data = json.decode(utf8.decode(response.bodyBytes));

    String id = data['image_id'];
    print(id);
    Widget imageWidget = await getImage(id);

    setState(() {
      widgetList.add(imageWidget);
      contentList.add(id);
    });
    return utf8.decode(response.bodyBytes);
  }
}
