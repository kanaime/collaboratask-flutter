import 'package:floor/floor.dart';

import '../models/Project.dart';
import '../ressources/synchronizable_dao.dart';



@dao
abstract class ProjectDao implements SynchronizableDao<Project> {
  @Query('SELECT * FROM Project WHERE localId = :id')
  Stream<Project?> getByLocalId(int id);

  @Query('SELECT * FROM Project WHERE id = :serverId')
  Stream<Project?> getByServerId(int serverId);

  @Query('DELETE FROM Project WHERE localId = :localId')
  Future<void> deleteByLocalId(int localId);

  @Query('DELETE FROM Project WHERE id = :serverId')
  Future<void> deleteByServerId(int serverId);

  @Query("SELECT * FROM Project ORDER BY creationDate DESC")
  Future<List<Project>> getAll();
  @Query("SELECT * FROM Project WHERE userId = :userId")
  Future<List<Project>>getByUserId(int userId);


  @Query("DELETE FROM Project")
  Future<void> deleteAll();


}