import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
abstract class SynchronizableEntity {
  @PrimaryKey(autoGenerate: true)
  int? localId;
  int? id;
  String creationDate;
  String lastUpdate;

  SynchronizableEntity(this.localId, this.id, this.creationDate, this.lastUpdate);
}
