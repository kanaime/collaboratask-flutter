import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

import '../ressources/synchronizable_entity.dart';
import 'UserInfo.dart';

part 'ProjectUser.g.dart';

@Entity(primaryKeys: ['localId'])
@JsonSerializable()
class ProjectUser extends SynchronizableEntity {
  final int projectId;
  final int userId;



  ProjectUser(
      {
        required this.projectId,
        required this.userId,
        required int? localId,
        required int? id,
        required String creationDate,
        required String lastUpdate,
      }) : super(localId, id, creationDate, lastUpdate);

  factory ProjectUser.fromJson(Map<String, dynamic> json) {
    try {
      return _$ProjectUserFromJson(json);
    } catch (error) {
      throw ("An error occured while transforming ProjectUser.fromJson, $error in $json");
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return _$ProjectUserToJson(this);
    } catch (error) {
      throw ("An error occured while transforming ProjectUser.toJson, $error");
    }
  }
}
