import 'package:floor/floor.dart';

import '../models/User.dart';
import '../ressources/synchronizable_dao.dart';



@dao
abstract class UserDao implements SynchronizableDao<User> {

  @Query('SELECT * FROM User WHERE id = :id')
  Future<User?> getByServerId(int id);

  @Query('SELECT * FROM User WHERE localId = :id')
  Stream<User?> getByLocalId(int id);

  @Query('DELETE FROM User WHERE localId = :localId')
  Future<void> deleteByLocalId(int localId);

  @Query('DELETE FROM User WHERE id = :serverId')
  Future<void> deleteByServerId(int serverId);

  @Query("SELECT * FROM User ORDER BY creationDate DESC")
  Future<List<User>> getAll();

  @Query("SELECT * FROM User LEFT JOIN ProjectUser ON User.id = ProjectUser.userId AND ProjectUser.projectId = :projectId WHERE User.id = :userId")
  Future<List<User>> findUserInProject(int userId, int projectId);

  @Query("SELECT User.* FROM User LEFT JOIN ProjectUser ON User.id = ProjectUser.userId WHERE ProjectUser.projectId = :projectId")
  Future<List<User>> getUsersInProject(int projectId);

  @Query('SELECT * FROM User WHERE token IS NOT NULL LIMIT 1')
  Stream<User?> getCurrentUser();


  @Query("DELETE FROM User")
  Future<void> deleteAll();


}