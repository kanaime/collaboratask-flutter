import 'package:intl/intl.dart';

import '../Task.dart';
import '../UserInfo.dart';

class ProjectInfo{
  final int? id;
  final int? localId;
  late final String name;
  late final String description;
  late final String status;
  final int creator;
  final String creationDate;
  final String lastUpdate;
  final List<UserInfo>? userInfos;
  late final List<int>? users;

  ProjectInfo({
    this.id,
    this.localId,
    required this.name,
    required this.description,
    required this.status,
    required this.creator,
    required this.creationDate,
    required this.lastUpdate,
    required this.users,
    this.userInfos,
  });

  factory ProjectInfo.fromJson(Map<String, dynamic> json) {
    return ProjectInfo(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      creator: json['creator'],
      creationDate: json['creationDate'],
      lastUpdate: json['lastUpdate'],
      users: json['users'] != null ? (json['users'] as List).map((i) => i as int).toList() : null,
      userInfos: json['userInfos'] != null ? (json['userInfos'] as List).map((i) => UserInfo.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'creator': creator,
      'creationDate': creationDate,
      'lastUpdate': lastUpdate,
      'users': users,
      'userInfos': userInfos,
    };
  }

  String parseCreationDate() {
    DateTime dateTime = DateTime.parse(creationDate);
    String stringDate = DateFormat('dd/MM/yyyy').format(dateTime);
    return stringDate;
  }

  String parseLastUpdate() {
    DateTime dateTime = DateTime.parse(lastUpdate);
    String stringDate = DateFormat('dd/MM/yyyy').format(dateTime);
    return stringDate;
  }






}