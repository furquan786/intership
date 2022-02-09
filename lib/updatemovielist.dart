import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intership/buttons.dart';
import 'package:intership/firebasemodel/firesebase.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Updatemovielist extends StatefulWidget {
  Map url;
  Map movie;
  Databse db;
  Updatemovielist({required this.movie, required this.db, required this.url});
  @override
  _UpdatemovielistState createState() => _UpdatemovielistState();
}

class _UpdatemovielistState extends State<Updatemovielist> {
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
    movienameeditingcontroller.text = widget.movie['name'];
    directoreditingcontroller.text = widget.movie['director'];
    super.initState();
  }
  final formKey = GlobalKey<FormState>();
bool saving =false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: saving,
          child: SingleChildScrollView(
            reverse:  true,
            child: Padding(
              padding: const EdgeInsets.only(top: 78.0, left: 15, right: 13),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 18,
                    ),
                    TextFormField(
                      validator: (val) {
                        return val!.length < 0
                            ? "Please Enter Movie Name"
                            : null;
                      },
                      controller: movienameeditingcontroller,
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
                      validator: (val) {
                        return val!.length < 0
                            ? "Please Enter Director"
                            : null;
                      },
                      controller: directoreditingcontroller,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black),
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
                        title: 'Update',
                        color: Colors.lightGreen,
                        onPress: () {
                          setState(() {
                            saving = true;
                          });
                          if(formKey.currentState!.validate()){
                            widget.db.update(
                              widget.movie['id'],
                              movienameeditingcontroller.text,
                              directoreditingcontroller.text,
                            );
                            Navigator.pop(context, true);
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
