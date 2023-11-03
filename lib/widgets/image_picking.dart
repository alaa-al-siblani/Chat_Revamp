import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePick extends StatefulWidget {
  final Function setImage;

  const ImagePick(this.setImage,{super.key});

  @override
  State<ImagePick> createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {
  File? _pickedImage;
 
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.white,
        backgroundImage: _pickedImage == null
            ? const AssetImage('assets/images/edit_profile.png')
            : FileImage(_pickedImage!) as ImageProvider,
      ),
      onTap: () async {
        final image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image != null) {
          setState(() {
            _pickedImage = File(image.path);
          });
          widget.setImage(_pickedImage);
        }
      },
    );
  }
}
