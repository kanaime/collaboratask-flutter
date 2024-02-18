import 'package:floor/floor.dart';

import '../models/Task.dart';
import '../ressources/synchronizable_dao.dart';



@dao
abstract class TaskDao implements SynchronizableDao<Task> {
  @Query('SELECT * FROM Task WHERE localId = :id')
  Stream<Task?> getByLocalId(int id);

  @Query('DELETE FROM Task WHERE localId = :localId')
  Future<void> deleteByLocalId(int localId);

  @Query('DELETE FROM Task WHERE id = :serverId')
  Future<void> deleteByServerId(int serverId);

  @Query('SELECT * FROM Task WHERE id = :serverId')
  Stream<Task?> getByServerId(int serverId);

  @Query("SELECT * FROM Task ORDER BY creationDate DESC")
  Future<List<Task>> getAll();

  @Query("SELECT * FROM Task WHERE project = :projectId")
  Future<List<Task>> getAllByProjectId(int projectId);


  @Query("DELETE FROM Task")
  Future<void> deleteAll();


}