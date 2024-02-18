import '../database/models/UserInfo.dart';
import '../database/repository/ProjectRepository.dart';
import '../database/repository/UserInfoRepository.dart';

class UserInfoManager {
  static final UserInfoManager _singleton = UserInfoManager._internal();

  factory UserInfoManager() {
    return _singleton;
  }

  UserInfoManager._internal();

  Future<List<UserInfo>> getUsersForProject(int projectId) async {
    List<UserInfo> users = [];

    var project = await ProjectRepository().getByServerId(projectId);
    if (project != null) {
      List<UserInfo> usersFromDb = await UserInfoRepository().getUserInfosInProject(projectId);
      if (usersFromDb.isNotEmpty) {
        users.addAll(usersFromDb);
      }
    }
    return users;
  }

  Future<List<int>> getUsersIdForProject(int projectId) async {
    List<UserInfo> users = await getUsersForProject(projectId);
    List<int> usersId = [];
    for (var user in users) {
      usersId.add(user.id!);
    }
    return usersId;
  }
}
