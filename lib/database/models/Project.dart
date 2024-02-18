import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

import '../ressources/synchronizable_entity.dart';
import 'UserInfo.dart';

part 'Project.g.dart';

@Entity(primaryKeys: ['localId'])
@JsonSerializable()
class Project extends SynchronizableEntity {
  final String name;
  final String description;
  final String status;
  final int creator;



  Project(

      {
        required this.name,
        required this.description,
        required this.status,
        required this.creator,
        required int? localId,
        required int? id,
        required String creationDate,
        required String lastUpdate,
      }) : super(localId, id, creationDate, lastUpdate);

  factory Project.fromJson(Map<String, dynamic> json) {
    try {
      return _$ProjectFromJson(json);
    } catch (error) {
      throw ("An error occured while transforming Project.fromJson, $error in $json");
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return _$ProjectToJson(this);
    } catch (error) {
      throw ("An error occured while transforming Project.toJson, $error");
    }
  }
}
