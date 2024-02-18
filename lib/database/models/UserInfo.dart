import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

import '../ressources/synchronizable_entity.dart';

part 'UserInfo.g.dart';

@Entity(primaryKeys: ['localId'])
@JsonSerializable()
class UserInfo extends SynchronizableEntity {
  final String firstName;
  final String lastName;
  final String email;
  final String? avatar;


  UserInfo(
      this.avatar,
      {
        required this.firstName,
        required this.lastName,
        required this.email,
        required int? localId,
        required int? id,
        required String creationDate,
        required String lastUpdate,
      }) : super(localId, id, creationDate, lastUpdate);

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    try {
      return _$UserInfoFromJson(json);
    } catch (error) {
      throw ("An error occured while transforming UserInfo.fromJson, $error in $json");
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return _$UserInfoToJson(this);
    } catch (error) {
      throw ("An error occured while transforming UserInfo.toJson, $error");
    }
  }
}
