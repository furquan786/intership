import 'package:flutter/material.dart';

const textfield_design = InputDecoration(
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
    hintText: 'Enter Your E-Mail',
    hintStyle: TextStyle(
      color: Colors.white70,
    ));