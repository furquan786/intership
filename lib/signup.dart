import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'buttons.dart';
import 'constant.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formKey = GlobalKey<FormState>();
  TextEditingController usernametexteditinngcontroller =
      TextEditingController();
  late String username;
  TextEditingController emailtexteditinngcontroller = TextEditingController();
  TextEditingController passwordtexteditinngcontroller =
      TextEditingController();
  bool isobsecure = true;
  bool _saving = false;
  final _auth = FirebaseAuth.instance;

  userinfo(usermap, uid) {
    FirebaseFirestore.instance.collection('users').doc(uid).set(usermap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        progressIndicator: CircularProgressIndicator(color: Colors.blue,),
        child: SingleChildScrollView(
          reverse: true,
          child: Container(
            padding: EdgeInsets.only(top: 300),
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/login.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: usernametexteditinngcontroller,
                    validator: (val) {
                      return val!.length < 3
                          ? 'Please Enter Valid UserName'
                          : null;
                    },
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 12.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.black26,
                        hintText: 'User Name',
                        hintStyle: TextStyle(
                          color: Colors.white70,
                        )),
                    onChanged: (value) {
                      username = value;
                    },
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    controller: emailtexteditinngcontroller,
                    validator: (val) {
                      return RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val!)
                          ? null
                          : "Please Enter Valid E-Mail";
                    },
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                    decoration: textfield_design,
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    controller: passwordtexteditinngcontroller,
                    validator: (val) {
                      return val!.length < 6
                          ? "Please Eneter Password 6+ Character"
                          : null;
                    },
                    textAlign: TextAlign.center,
                    obscureText: isobsecure,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isobsecure = !isobsecure;
                          });
                        },
                        icon: Icon(
                          isobsecure ? Icons.visibility : Icons.visibility_off,
                          color: Colors.red,
                          size: 28.0,
                        ),
                      ),
                      border: const OutlineInputBorder(
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
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Flexible(
                    child: Roundedbutton(
                      title: 'Sign Up',
                      color: Colors.red,
                      onPress: () async {
                        if (formKey.currentState!.validate()) {
                          Map<String, String> userinfomap = {
                            'username': username,
                          };
                          setState(() {
                            _saving = true;
                          });
                          try {
                            final newuser =
                                await _auth.createUserWithEmailAndPassword(
                                    email: emailtexteditinngcontroller.text,
                                    password:
                                        passwordtexteditinngcontroller.text);
                            userinfo(userinfomap, newuser.user!.uid);
                            if (newuser != null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LoginScreen();
                                  },
                                ),
                              );
                              setState(() {
                                _saving = false;
                              });
                            }
                          } catch (e) {
                            print(e);
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
