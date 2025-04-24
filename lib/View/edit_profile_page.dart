import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Database/avatar_db.dart';

class EditProfilePage extends StatefulWidget {
  final String initialName;
  final String initialEmail;

  const EditProfilePage({
    super.key,
    required this.initialName,
    required this.initialEmail,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String email;
  File? _imageFile;
  String? _savedAvatarPath;

  @override
  void initState() {
    super.initState();
    name = widget.initialName;
    email = widget.initialEmail;
    _loadSavedAvatar();
  }

  Future<void> _loadSavedAvatar() async {
    final path = await AvatarDB.getAvatarPath();
    if (path != null && mounted) {
      setState(() {
        _savedAvatarPath = path;
        _imageFile = File(path);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      await AvatarDB.saveAvatarPath(file.path);
      setState(() {
        _imageFile = file;
      });
    }
  }

  Future<void> _saveToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': name,
        'email': email,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge!.color;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: textColor),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : const AssetImage('assets/food-delivery(foodel)/me2024.jpg')
                          as ImageProvider,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (val) => name = val ?? '',
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (val) => email = val ?? '',
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  _formKey.currentState!.save();
                  await _saveToFirebase();
                  Navigator.pop(context, {
                    'name': name,
                    'email': email,
                  });
                },
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
