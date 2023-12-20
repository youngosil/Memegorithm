import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';

class WritePostScreen extends StatefulWidget {
  static const routeName = '/home/write';

  const WritePostScreen({Key? key}) : super(key: key);

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
            fit: BoxFit.cover,
          ),
        ),
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
                    color: Colors.black,
                  ),
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
                          onPressed: _addTextField,
                          child: const Text('Add TextField'),
                        ),
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: const Text('Pick Image'),
                        ),
                      ],
                    ),
                    if (textFields.isNotEmpty) ...textFields
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _addTextField() {
    setState(() {
      textFields.add(
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Enter your text',
            ),
          ),
        ),
      );
    });
  }

  Future<void> _pickImage() async {
    try {
      final Image image =
          await ImagePickerWeb.getImageAsWidget() as Image;

      setState(() {
        textFields.add(image);
      });
    } catch (e) {
      // Handle image picking errors here
      print('Error picking image: $e');
    }
  }
}

