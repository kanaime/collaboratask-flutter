// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProjectUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectUser _$ProjectUserFromJson(Map<String, dynamic> json) => ProjectUser(
      projectId: json['projectId'] as int,
      userId: json['userId'] as int,
      localId: json['localId'] as int?,
      id: json['id'] as int?,
      creationDate: json['creationDate'] as String,
      lastUpdate: json['lastUpdate'] as String,
    );

Map<String, dynamic> _$ProjectUserToJson(ProjectUser instance) =>
    <String, dynamic>{
      'localId': instance.localId,
      'id': instance.id,
      'creationDate': instance.creationDate,
      'lastUpdate': instance.lastUpdate,
      'projectId': instance.projectId,
      'userId': instance.userId,
    };
