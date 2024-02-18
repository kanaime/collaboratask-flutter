import 'package:collaboratask/database/models/UserInfo.dart';
import 'package:collaboratask/database/ressources/synchronizable_entity.dart';
import 'package:collaboratask/database/ressources/synchronizable_repository.dart';

import '../daos/UserInfoDao.dart';

class UserInfoRepository extends SynchronizableRepository<UserInfo>{
  static final UserInfoRepository _instance = UserInfoRepository._internal();

  factory UserInfoRepository() {
    return _instance;
  }

  UserInfoRepository._internal();
  
  
  @override
  deleteByLocalId(int localId) {
    return (dao as UserInfoDao).deleteByLocalId(localId);
  }

  @override
  deleteByServerId(int serverId) {
    return (dao as UserInfoDao).deleteByServerId(serverId);
  }

  @override
  Future<List<UserInfo>> getAll() {
    return (dao as UserInfoDao).getAll();
  }

  @override
  Future<UserInfo?> getByLocalId(int entityId) {
    return (dao as UserInfoDao).getByLocalId(entityId).first;
  }

  @override
  Future<UserInfo?> getByServerId(int entityId) {
    return (dao as UserInfoDao).getByServerId(entityId).first;
  }


  @override
  saveAll(List<UserInfo> entitiesToCreate, List<UserInfo> entitiesToUpdate) {
    return (dao as UserInfoDao).insertAll(entitiesToCreate);
  }

  Future<int> insert(UserInfo userInfo) async {
    userInfo.localId = await (dao as UserInfoDao).insert(userInfo);
    return userInfo.localId!;
  }

  @override
  Future<UserInfo> fromJson(Map<String, dynamic> json)async {
    return UserInfo.fromJson(json);
  }

  @override
  Future<List<UserInfo>> getUserInfosInProject(int projectId) {
    return (dao as UserInfoDao).getUserInfosInProject(projectId);
  }
  @override
  Future<Map<String, dynamic>> toJson(UserInfo entity) async{
    return entity.toJson();
  }
  @override
  Future<void> deleteAll()async {
    return await (dao as UserInfoDao).deleteAll();
  }

}