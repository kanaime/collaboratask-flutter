// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['avatar'] as String?,
      json['token'] as String?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      firebaseId: json['firebaseId'] as String,
      localId: json['localId'] as int?,
      id: json['id'] as int?,
      creationDate: json['creationDate'] as String,
      lastUpdate: json['lastUpdate'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'localId': instance.localId,
      'id': instance.id,
      'creationDate': instance.creationDate,
      'lastUpdate': instance.lastUpdate,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'firebaseId': instance.firebaseId,
      'avatar': instance.avatar,
      'token': instance.token,
    };
