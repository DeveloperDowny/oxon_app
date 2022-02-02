import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Concern with ChangeNotifier {
  final String issueType;
  final String description;
  final String issueID;
  final String authority;
  // final String userID;

  Concern({
    required this.authority,
    required this.issueType,
    required this.description,
    required this.issueID,
    // required this.userID
  });
}
