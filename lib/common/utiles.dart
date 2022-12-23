import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showsnackbar(BuildContext context, String textt) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(textt)));
}
