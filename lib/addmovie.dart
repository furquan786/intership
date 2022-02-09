import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'buttons.dart';
import 'firebasemodel/firesebase.dart';

class AddMovie extends StatefulWidget {
  Databse db;
  AddMovie({required this.db});
  @override
  _AddMovieState createState() => _AddMovieState();
}

class _AddMovieState extends State<AddMovie> {
  Databse db = Databse();
  File? _image;
  final imagepicker = ImagePicker();
  Future imagepick() async {
    final pick = await imagepicker.pickImage(source: ImageSource.gallery);
    if (pick != null) {
      setState(() {
        _image = File(pick.path);
      });
    } else {
      showsnackbar('no image selected', Duration(milliseconds: 400));
    }
  }

  showsnackbar(String text, Duration d) {
    final snackbar = SnackBar(
      content: Text(text),
      duration: d,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  TextEditingController movienameeditingcontroller = TextEditingController();
  TextEditingController directoreditingcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }
  bool saving = false;

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          progressIndicator: CircularProgressIndicator(),
          inAsyncCall: saving,
          child: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.only(top: 68.0, left: 15, right: 13),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        imagepick();
                      },
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: _image == null
                            ? const AssetImage('images/profile.jpg')
                                as ImageProvider
                            : FileImage(_image!),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    TextFormField(
                      controller: movienameeditingcontroller,
                      validator: (val) {
                        return val!.length < 1
                            ? "Please Eneter Movie Name"
                            : null;
                      },
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                            width: 12.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.black26,
                        hintText: 'Movie Name',
                        hintStyle: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.12),
                    TextFormField(
                      controller: directoreditingcontroller,
                      validator: (val) {
                        return val!.length < 1 ? "Please Enter Director" : null;
                      },
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                            width: 12.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.black26,
                        hintText: 'Drector Name',
                        hintStyle: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Roundedbutton(
                        title: 'Add movie',
                        color: Colors.greenAccent,
                        onPress: () {
                          setState(() {
                            saving = true;
                          });
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              saving = true;
                            });
                            db
                                .uploadfile(
                                    _image!,
                                    movienameeditingcontroller.text,
                                    directoreditingcontroller.text)
                                .whenComplete(() {
                              Navigator.pop(context, true);
                            });
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
