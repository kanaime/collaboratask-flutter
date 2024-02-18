// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      project: json['project'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      creator: json['creator'] as int,
      localId: json['localId'] as int?,
      id: json['id'] as int?,
      creationDate: json['creationDate'] as String,
      lastUpdate: json['lastUpdate'] as String,
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'localId': instance.localId,
      'id': instance.id,
      'creationDate': instance.creationDate,
      'lastUpdate': instance.lastUpdate,
      'name': instance.name,
      'description': instance.description,
      'status': instance.status,
      'creator': instance.creator,
      'project': instance.project,
    };
