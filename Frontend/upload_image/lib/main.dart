import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Image Upload Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  bool _uploading = false; // Flag to track upload progress
  final picker = ImagePicker();

  Future getImageAndUpload(ImageSource source) async {
    setState(() {
      _uploading = true; // Start upload process, set uploading flag to true
    });

    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.102:3000/upload'),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _image!.path,
        ),
      );

      var response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final imageUrl = 'http://192.168.1.102:3000$responseData';
        print('Image uploaded successfully. Image URL: $imageUrl');
      }

      setState(() {
        _uploading =
            false; // Upload process completed, set uploading flag to false
      });
    } else {
      setState(() {
        _uploading = false; // No image selected, set uploading flag to false
      });
    }
  }

  bool _dummyStateVariable = false;
  void refreshPage() {
    // Setting a dummy state variable to trigger a rebuild
    setState(() {
      _dummyStateVariable = !_dummyStateVariable;
      _uploading =
          true; // Set uploading flag to true to show progress indicator
    });

    // Simulate a delay for demonstration purposes
    Future.delayed(Duration(seconds: 2), () {
      // Reset the uploading flag after the delay
      setState(() {
        _uploading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Image Upload Example'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: refreshPage,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: CircleAvatar(
                radius: 150,
                backgroundColor: Colors.blue,
                backgroundImage:
                    NetworkImage('http://192.168.1.102:3000/avi-image'),
                child: Text(
                  '\n\n\n\n\n\n\n\n\n    Fetched Image',
                  style: TextStyle(color: Colors.yellow),
                ),
              ),
            ),
            Expanded(
              child: _uploading
                  ? CircularProgressIndicator() // Show progress indicator if uploading
                  : _image == null
                      ? Text('No image selected.')
                      : Image.file(_image!),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => getImageAndUpload(ImageSource.gallery),
                  child: Text('Select Image'),
                ),
                ElevatedButton(
                  onPressed: () => getImageAndUpload(ImageSource.camera),
                  child: Text('Take Photo'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Image Upload Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   File? _image;
//   bool _uploading = false; // Flag to track upload progress
//   final picker = ImagePicker();
//
//   Future getImageAndUpload(ImageSource source) async {
//     setState(() {
//       _uploading = true; // Start upload process, set uploading flag to true
//     });
//
//     final pickedFile = await picker.pickImage(source: source);
//
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('http://192.168.1.102:3000/upload'),
//       );
//
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'image',
//           _image!.path,
//         ),
//       );
//
//       var response = await request.send();
//       if (response.statusCode == 200) {
//         final responseData = await response.stream.bytesToString();
//         final imageUrl = 'http://192.168.1.102:3000$responseData';
//         print('Image uploaded successfully. Image URL: $imageUrl');
//       }
//
//       setState(() {
//         _uploading =
//             false; // Upload process completed, set uploading flag to false
//       });
//     } else {
//       setState(() {
//         _uploading = false; // No image selected, set uploading flag to false
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text('Image Upload Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Expanded(
//               child: CircleAvatar(
//                 radius: 150,
//                 backgroundColor: Colors.blue,
//                 backgroundImage:
//                     NetworkImage('http://192.168.1.102:3000/avi-image'),
//                 child: Text(
//                   '\n\n\n\n\n\n\n\n\n    Fetched Image',
//                   style: TextStyle(color: Colors.yellow),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: _uploading
//                   ? CircularProgressIndicator() // Show progress indicator if uploading
//                   : _image == null
//                       ? Text('No image selected.')
//                       : Image.file(_image!),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () => getImageAndUpload(ImageSource.gallery),
//                   child: Text('Select Image'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => getImageAndUpload(ImageSource.camera),
//                   child: Text('Take Photo'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
