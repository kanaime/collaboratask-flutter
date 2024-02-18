import 'package:floor/floor.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import '../ressources/synchronizable_entity.dart';

part 'Task.g.dart';

@Entity(primaryKeys: ['localId'])
@JsonSerializable()
class Task extends SynchronizableEntity {
  final String name;
  final String description;
  final String status;
  final int creator;
  final int project;



  Task(

      {
        required this.project,
        required this.name,
        required this.description,
        required this.status,
        required this.creator,
        required int? localId,
        required int? id,
        required String creationDate,
        required String lastUpdate,
      }) : super(localId, id, creationDate, lastUpdate);

  factory Task.fromJson(Map<String, dynamic> json) {
    try {
      return _$TaskFromJson(json);
    } catch (error) {
      throw ("An error occured while transforming Task.fromJson, $error in $json");
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return _$TaskToJson(this);
    } catch (error) {
      throw ("An error occured while transforming Task.toJson, $error");
    }
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
