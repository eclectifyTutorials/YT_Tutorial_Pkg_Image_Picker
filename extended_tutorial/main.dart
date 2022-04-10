// ignore_for_file: prefer_const_declarations

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart'; /// EXTENDED

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ImagePicker _picker = ImagePicker();
  final double padding = 20.0;
  
  XFile? pickedFile;

  /// EXTENDED
  @override
  void initState() {
    super.initState();
    loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: ListView(
          children: [
            SizedBox(height: padding,),
            ElevatedButton(onPressed: pickImage, child: const Text("Pick Image")),
            SizedBox(height: padding/2,),
            ElevatedButton(onPressed: capturePhoto, child: const Text("Capture Photo")),
            SizedBox(height: padding/2,),
            ElevatedButton(onPressed: pickVideo, child: const Text("Pick Video")),
            SizedBox(height: padding/2,),
            ElevatedButton(onPressed: captureVideo, child: const Text("Capture Video")),
            SizedBox(height: padding/2,),
            ElevatedButton(onPressed: pickMultipleImages, child: const Text("Pick Multiple Images")),
            SizedBox(height: padding/2,),
            !kIsWeb && pickedFile!=null? Image.file(File(pickedFile!.path)) : Container(),
            pickedFile!=null? SizedBox(height: padding,) : Container(),
          ],
        ),
      ),
    );
  }

  /// Pick an image
  void pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        pickedFile = image;
      });
      saveImage(image); /// EXTENDED
    }
  }

  /// EXTENDED
  void saveImage(XFile img) async {
    // Step 3: Get directory where we can duplicate selected file.
    final String path = (await getApplicationDocumentsDirectory()).path;

    File convertedImg = File(img.path);

    // Step 4: Copy the file to a application document directory.
    // final fileName = basename(convertedImg.path);
    final String fileName = "the_image.jpg";
    final File localImage = await convertedImg.copy('$path/$fileName');
    print("Saved image under: $path/$fileName");
  }
  /// EXTENDED
  void loadImage() async {
    final String fileName = "the_image.jpg";
    final String path = (await getApplicationDocumentsDirectory()).path;

    if (File('$path/$fileName').existsSync()) {
      print("Image exists. Loading it...");
      setState(() {
        pickedFile = XFile('$path/$fileName');
      });
    }
  }

  /// Capture a photo
  void capturePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        pickedFile = photo;
      });
    }
  }

  /// Pick a video
  void pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        pickedFile = video;
      });
    }
  }

  /// Capture a video
  void captureVideo() async {
    final XFile? capturedVideo = await _picker.pickVideo(source: ImageSource.camera);
    if (capturedVideo != null) {
      setState(() {
        pickedFile = capturedVideo;
      });
    }
  }

  /// Pick multiple images
  void pickMultipleImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    //TODO: do something with images
  }

}

