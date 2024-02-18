import 'package:floor/floor.dart';

import '../models/UserInfo.dart';
import '../ressources/synchronizable_dao.dart';



@dao
abstract class UserInfoDao implements SynchronizableDao<UserInfo> {
  @Query('SELECT * FROM UserInfo WHERE localId = :id')
  Stream<UserInfo?> getByLocalId(int id);

  @Query('SELECT * FROM UserInfo WHERE id = :serverId')
  Stream<UserInfo?> getByServerId(int serverId);

  @Query('DELETE FROM UserInfo WHERE localId = :localId')
  Future<void> deleteByLocalId(int localId);

  @Query('DELETE FROM UserInfo WHERE id = :serverId')
  Future<void> deleteByServerId(int serverId);

  @Query("SELECT UserInfo.* FROM UserInfo LEFT JOIN ProjectUser ON (UserInfo.id = ProjectUser.userId) WHERE ProjectUser.projectId = :projectId")
  Future<List<UserInfo>> getUserInfosInProject(int projectId);

  @Query("SELECT * FROM UserInfo ORDER BY creationDate DESC")
  Future<List<UserInfo>> getAll();




  @Query("DELETE FROM UserInfo")
  Future<void> deleteAll();


}