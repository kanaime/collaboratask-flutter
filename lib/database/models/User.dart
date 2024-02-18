import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

import '../ressources/synchronizable_entity.dart';

part 'User.g.dart';

@Entity(primaryKeys: ['localId'])
@JsonSerializable()
class User extends SynchronizableEntity {
  final String firstName;
  final String lastName;
  final String email;
  final String firebaseId;
  final String? avatar;
  final String? token;


  User(
      this.avatar,
      this.token,
      {
        required this.firstName,
        required this.lastName,
        required this.email,
        required this.firebaseId,
        required int? localId,
        required int? id,
        required String creationDate,
        required String lastUpdate,
      }) : super(localId, id, creationDate, lastUpdate);

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return _$UserFromJson(json);
    } catch (error) {
      throw ("An error occured while transforming User.fromJson, $error in $json");
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return _$UserToJson(this);
    } catch (error) {
      throw ("An error occured while transforming User.toJson, $error");
    }
  }
}
