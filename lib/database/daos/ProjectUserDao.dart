import 'package:floor/floor.dart';

import '../models/ProjectUser.dart';
import '../ressources/synchronizable_dao.dart';



@dao
abstract class ProjectUserDao implements SynchronizableDao<ProjectUser> {
  @Query('SELECT * FROM ProjectUser WHERE localId = :id')
  Stream<ProjectUser?> getByLocalId(int id);

  @Query('SELECT * FROM ProjectUser WHERE id = :serverId')
  Stream<ProjectUser?> getByServerId(int serverId);

  @Query('DELETE FROM ProjectUser WHERE localId = :localId')
  Future<void> deleteByLocalId(int localId);

  @Query('DELETE FROM ProjectUser WHERE projectId = :projectId')
  Future<void> deleteByProjectId(int projectId);

  @Query('DELETE FROM ProjectUser WHERE id = :serverId')
  Future<void> deleteByServerId(int serverId);

  @Query("SELECT * FROM ProjectUser ORDER BY creationDate DESC")
  Future<List<ProjectUser>> getAll();

  @Query("SELECT * FROM ProjectUser WHERE projectId = :projectId")
  Future<List<ProjectUser>> getByProjectId(int projectId);

  @Query("SELECT * FROM ProjectUser WHERE userId = :userId")
  Future<List<ProjectUser>> getByUserId(int userId);

  @Query("DELETE FROM ProjectUser")
  Future<void> deleteAll();


}