import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intership/signup.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'buttons.dart';
import 'constant.dart';
import 'movielist.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  late String username;
  TextEditingController emailtexteditinngcontroller = TextEditingController();
  TextEditingController passwordtexteditinngcontroller =
      TextEditingController();
  bool isobsecure = true;
  bool saving = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ModalProgressHUD(
          progressIndicator: CircularProgressIndicator(color: Colors.blue,),
          inAsyncCall: saving,
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
                        title: 'Login',
                        color: Colors.red,
                        onPress: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              saving = true;
                            });
                            try {
                              final user = await auth.signInWithEmailAndPassword(
                                  email: emailtexteditinngcontroller.text,
                                  password: passwordtexteditinngcontroller.text);
                              if(user!= null){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                  return MovieList();
                                }));
                                setState(() {
                                  saving = false;
                                });
                              }
                            }
                            catch(e){
                              print(e);
                            }
                          }
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Signup();
                            },
                          ),
                        );
                      },
                      child: const Text(
                        'Create new acount',
                        style: TextStyle(
                          fontSize: 22.4,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
