import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../database/models/User.dart';
import '../database/models/UserInfo.dart';

class CircleUserAvatar extends StatelessWidget {
  final double radius;
  final double borderWidth;
  final Color borderColor;
  final Color backgroundColor;
  final UserInfo? user;

  //final UserInfo? userInfo;

  CircleUserAvatar({
    this.backgroundColor = Colors.grey,
    this.user,
    //this.userInfo,
    this.radius = 30,
    this.borderWidth = 2,
    this.borderColor = Colors.white,
  });

  getInitials() {
    if (user?.firstName != null && user?.lastName != null) {
      return user!.firstName[0].toUpperCase() + user!.lastName[0].toUpperCase();
    } else if (user?.firstName != null) {
      return user!.firstName[0].toUpperCase();
    } else if (user?.lastName != null) {
      return user!.lastName[0].toUpperCase();
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      backgroundImage: user?.avatar != null
          ? NetworkImage(user?.avatar ?? "")
          : null,
      child: user?.avatar != null
          ? null
          : Text(
              getInitials(),
              style: TextStyle(
                color: Colors.white,
                fontSize: radius * 0.6,
              ),
            ),
    );
  }
}
