// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ProjectDao? _projectDaoInstance;

  TaskDao? _taskDaoInstance;

  UserDao? _userDaoInstance;

  UserInfoDao? _userInfoDaoInstance;

  ProjectUserDao? _projectUserDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Project` (`name` TEXT NOT NULL, `description` TEXT NOT NULL, `status` TEXT NOT NULL, `creator` INTEGER NOT NULL, `localId` INTEGER, `id` INTEGER, `creationDate` TEXT NOT NULL, `lastUpdate` TEXT NOT NULL, PRIMARY KEY (`localId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Task` (`name` TEXT NOT NULL, `description` TEXT NOT NULL, `status` TEXT NOT NULL, `creator` INTEGER NOT NULL, `project` INTEGER NOT NULL, `localId` INTEGER, `id` INTEGER, `creationDate` TEXT NOT NULL, `lastUpdate` TEXT NOT NULL, PRIMARY KEY (`localId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UserInfo` (`firstName` TEXT NOT NULL, `lastName` TEXT NOT NULL, `email` TEXT NOT NULL, `avatar` TEXT, `localId` INTEGER, `id` INTEGER, `creationDate` TEXT NOT NULL, `lastUpdate` TEXT NOT NULL, PRIMARY KEY (`localId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `User` (`firstName` TEXT NOT NULL, `lastName` TEXT NOT NULL, `email` TEXT NOT NULL, `firebaseId` TEXT NOT NULL, `avatar` TEXT, `token` TEXT, `localId` INTEGER, `id` INTEGER, `creationDate` TEXT NOT NULL, `lastUpdate` TEXT NOT NULL, PRIMARY KEY (`localId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ProjectUser` (`projectId` INTEGER NOT NULL, `userId` INTEGER NOT NULL, `localId` INTEGER, `id` INTEGER, `creationDate` TEXT NOT NULL, `lastUpdate` TEXT NOT NULL, PRIMARY KEY (`localId`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ProjectDao get projectDao {
    return _projectDaoInstance ??= _$ProjectDao(database, changeListener);
  }

  @override
  TaskDao get taskDao {
    return _taskDaoInstance ??= _$TaskDao(database, changeListener);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  UserInfoDao get userInfoDao {
    return _userInfoDaoInstance ??= _$UserInfoDao(database, changeListener);
  }

  @override
  ProjectUserDao get projectUserDao {
    return _projectUserDaoInstance ??=
        _$ProjectUserDao(database, changeListener);
  }
}

class _$ProjectDao extends ProjectDao {
  _$ProjectDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _projectInsertionAdapter = InsertionAdapter(
            database,
            'Project',
            (Project item) => <String, Object?>{
                  'name': item.name,
                  'description': item.description,
                  'status': item.status,
                  'creator': item.creator,
                  'localId': item.localId,
                  'id': item.id,
                  'creationDate': item.creationDate,
                  'lastUpdate': item.lastUpdate
                },
            changeListener),
        _projectUpdateAdapter = UpdateAdapter(
            database,
            'Project',
            ['localId'],
            (Project item) => <String, Object?>{
                  'name': item.name,
                  'description': item.description,
                  'status': item.status,
                  'creator': item.creator,
                  'localId': item.localId,
                  'id': item.id,
                  'creationDate': item.creationDate,
                  'lastUpdate': item.lastUpdate
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Project> _projectInsertionAdapter;

  final UpdateAdapter<Project> _projectUpdateAdapter;

  @override
  Stream<Project?> getByLocalId(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Project WHERE localId = ?1',
        mapper: (Map<String, Object?> row) => Project(
            name: row['name'] as String,
            description: row['description'] as String,
            status: row['status'] as String,
            creator: row['creator'] as int,
            localId: row['localId'] as int?,
            id: row['id'] as int?,
            creationDate: row['creationDate'] as String,
            lastUpdate: row['lastUpdate'] as String),
        arguments: [id],
        queryableName: 'Project',
        isView: false);
  }

  @override
  Stream<Project?> getByServerId(int serverId) {
    return _queryAdapter.queryStream('SELECT * FROM Project WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Project(
            name: row['name'] as String,
            description: row['description'] as String,
            status: row['status'] as String,
            creator: row['creator'] as int,
            localId: row['localId'] as int?,
            id: row['id'] as int?,
            creationDate: row['creationDate'] as String,
            lastUpdate: row['lastUpdate'] as String),
        arguments: [serverId],
        queryableName: 'Project',
        isView: false);
  }

  @override
  Future<void> deleteByLocalId(int localId) async {
    await _queryAdapter.queryNoReturn('DELETE FROM Project WHERE localId = ?1',
        arguments: [localId]);
  }

  @override
  Future<void> deleteByServerId(int serverId) async {
    await _queryAdapter.queryNoReturn('DELETE FROM Project WHERE id = ?1',
        arguments: [serverId]);
  }

  @override
  Future<List<Project>> getAll() async {
    return _queryAdapter.queryList(
        'SELECT * FROM Project ORDER BY creationDate DESC',
        mapper: (Map<String, Object?> row) => Project(
            name: row['name'] as String,
            description: row['description'] as String,
            status: row['status'] as String,
            creator: row['creator'] as int,
            localId: row['localId'] as int?,
            id: row['id'] as int?,
            creationDate: row['creationDate'] as String,
            lastUpdate: row['lastUpdate'] as String));
  }

  @override
  Future<List<Project>> getByUserId(int userId) async {
    return _queryAdapter.queryList('SELECT * FROM Project WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => Project(
            name: row['name'] as String,
            description: row['description'] as String,
            status: row['status'] as String,
            creator: row['creator'] as int,
            localId: row['localId'] as int?,
            id: row['id'] as int?,
            creationDate: row['creationDate'] as String,
            lastUpdate: row['lastUpdate'] as String),
        arguments: [userId]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Project');
  }

  @override
  Future<int> insert(Project item) {
    return _projectInsertionAdapter.insertAndReturnId(
        item, OnConflictStrategy.rollback);
  }

  @override
  Future<List<int>> insertAll(List<Project> entitiesToCreate) {
    return _projectInsertionAdapter.insertListAndReturnIds(
        entitiesToCreate, OnConflictStrategy.rollback);
  }

  @override
  Future<int> updateAll(List<Project> entitiesToUpdate) {
    return _projectUpdateAdapter.updateListAndReturnChangedRows(
        entitiesToUpdate, OnConflictStrategy.ignore);
  }

  @override
  Future<int> update(Project entity) {
    return _projectUpdateAdapter.updateAndReturnChangedRows(
        entity, OnConflictStrategy.ignore);
  }
}

class _$TaskDao extends TaskDao {
  _$TaskDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _taskInsertionAdapter = InsertionAdapter(
            database,
            'Task',
            (Task item) => <String, Object?>{
                  'name': item.name,
                  'description': item.description,
                  'status': item.status,
                  'creator': item.creator,
                  'project': item.project,
                  'localId': item.localId,
                  'id': item.id,
                  'creationDate': item.creationDate,
                  'lastUpdate': item.lastUpdate
                },
            changeListener),
        _taskUpdateAdapter = UpdateAdapter(
            database,
            'Task',
            ['localId'],
            (Task item) => <String, Object?>{
                  'name': item.name,
                  'description': item.description,
                  'status': item.status,
                  'creator': item.creator,
                  'project': item.project,
                  'localId': item.localId,
                  'id': item.id,
                  'creationDate': item.creationDate,
                  'lastUpdate': item.lastUpdate
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Task> _taskInsertionAdapter;

  final UpdateAdapter<Task> _taskUpdateAdapter;

  @override
  Stream<Task?> getByLocalId(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Task WHERE localId = ?1',
        mapper: (Map<String, Object?> row) => Task(
            project: row['project'] as int,
            name: row['name'] as String,
            description: row['description'] as String,
            status: row['status'] as String,
            creator: row['creator'] as int,
            localId: row['localId'] as int?,
            id: row['id'] as int?,
            creationDate: row['creationDate'] as String,
            lastUpdate: row['lastUpdate'] as String),
        arguments: [id],
        queryableName: 'Task',
        isView: false);
  }

  @override
  Future<void> deleteByLocalId(int localId) async {
    await _queryAdapter.queryNoReturn('DELETE FROM Task WHERE localId = ?1',
        arguments: [localId]);
  }

  @override
  Future<void> deleteByServerId(int serverId) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Task WHERE id = ?1', arguments: [serverId]);
  }

  @override
  Stream<Task?> getByServerId(int serverId) {
    return _queryAdapter.queryStream('SELECT * FROM Task WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Task(
            project: row['project'] as int,
            name: row['name'] as String,
            description: row['description'] as String,
            status: row['status'] as String,
            creator: row['creator'] as int,
            localId: row['localId'] as int?,
            id: row['id'] as int?,
            creationDate: row['creationDate'] as String,
            lastUpdate: row['lastUpdate'] as String),
        arguments: [serverId],
        queryableName: 'Task',
        isView: false);
  }

  @override
  Future<List<Task>> getAll() async {
    return _queryAdapter.queryList(
        'SELECT * FROM Task ORDER BY creationDate DESC',
        mapper: (Map<String, Object?> row) => Task(
            project: row['project'] as int,
            name: row['name'] as String,
            description: row['description'] as String,
            status: row['status'] as String,
            creator: row['creator'] as int,
            localId: row['localId'] as int?,
            id: row['id'] as int?,
            creationDate: row['creationDate'] as String,
            lastUpdate: row['lastUpdate'] as String));
  }

  @override
  Future<List<Task>> getAllByProjectId(int projectId) async {
    return _queryAdapter.queryList('SELECT * FROM Task WHERE project = ?1',
        mapper: (Map<String, Object?> row) => Task(
            project: row['project'] as int,
            name: row['name'] as String,
            description: row['description'] as String,
            status: row['status'] as String,
            creator: row['creator'] as int,
            localId: row['localId'] as int?,
            id: row['id'] as int?,
            creationDate: row['creationDate'] as String,
            lastUpdate: row['lastUpdate'] as String),
        arguments: [projectId]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Task');
  }

  @override
  Future<int> insert(Task item) {
    return _taskInsertionAdapter.insertAndReturnId(
        item, OnConflictStrategy.rollback);
  }

  @override
  Future<List<int>> insertAll(List<Task> entitiesToCreate) {
    return _taskInsertionAdapter.insertListAndReturnIds(
        entitiesToCreate, OnConflictStrategy.rollback);
  }

  @override
  Future<int> updateAll(List<Task> entitiesToUpdate) {
    return _taskUpdateAdapter.updateListAndReturnChangedRows(
        entitiesToUpdate, OnConflictStrategy.ignore);
  }

  @override
  Future<int> update(Task entity) {
    return _taskUpdateAdapter.updateAndReturnChangedRows(
        entity, OnConflictStrategy.ignore);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'User',
            (User item) => <String, Object?>{
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'email': item.email,
                  'firebaseId': item.firebaseId,
                  'avatar': item.avatar,
                  'token': item.token,
                  'localId': item.localId,
                  'id': item.id,
                  'creationDate': item.creationDate,
                  'lastUpdate': item.lastUpdate
                },
            changeListener),
        _userUpdateAdapter = UpdateAdapter(
            database,
            'User',
            ['localId'],
            (User item) => <String, Object?>{
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'email': item.email,
                  'firebaseId': item.firebaseId,
                  'avatar': item.avatar,
                  'token': item.token,
                  'localId': item.localId,
                  'id': item.id,
                  'creationDate': item.creationDate,
                  'lastUpdate': item.lastUpdate
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final UpdateAdapter<User> _userUpdateAdapter;

  @override
  Future<User?> getByServerId(int id) async {
    return _queryAdapter.query('SELECT * FROM User WHERE id = ?1',
        mapper: (Map<String, Object?> row) => User(
            row['avatar'] as String?, row['token'] as String?,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            email: row['email'] as String,
            firebaseId: row['firebaseId'] as String,
            localId: row['localId'] as int?,
            id: row['id'] as int?,
            creationDate: row['creationDate'] as String,
            lastUpdate: row['lastUpdate'] as String),
        arguments: [id]);
  }

  @override
  Stream<User?> getByLocalId(int id) {
    return _queryAdapter.queryStream('SELECT * FROM User WHERE localId = ?1',
        mapper: (Map<String, Object?> row) => User(
            row['avatar'] as String?, row['token'] as String?,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            email: row['email'] as String,
            firebaseId: row['firebaseId'] as String,
            localId: row['localId'] as int?,
            id: row['id'] as int?,
            creationDate: row['creationDate'] as String,
            lastUpdate: row['lastUpdate'] as String),
        arguments: [id],
        queryableName: 'User',
        isView: false);
  }

  @override
  Future<void> deleteByLocalId(int localId) async {
    await _queryAdapter.queryNoReturn('DELETE FROM User WHERE localId = ?1',
        arguments: [localId]);
  }

  @override
  Future<void> deleteByServerId(int serverId) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM User WHERE id = ?1', arguments: [serverId]);
  }

  @override
  Future<List<User>> getAll() async {
    return _queryAdapter.queryList(
        'SELECT * FROM User ORDER BY creationDate DESC',
        mapper: (Map<String, Object?> row) => User(
            row['avatar'] as String?, row['token'] as String?,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            email: row['email'] as String,
            firebaseId: row['firebaseId'] as String,
            localId: row['localId'] as int?,
            id: row['id'] as int?,
            creationDate: row['creationDate'] as String,
            lastUpdate: row['lastUpdate'] as String));
  }

  @override
  Future<List<User>> findUserInProject(
    int userId,
    int projectId,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM User LEFT JOIN ProjectUser ON User.id = ProjectUser.userId AND ProjectUser.projectId = ?2 WHERE User.id = ?1',
        mapper: (Map<String, Object?> row) => User(row['avatar'] as String?, row['token'] as String?, firstName: row['firstName'] as String, lastName: row['lastName'] as String, email: row['email'] as String, firebaseId: row['firebaseId'] as String, localId: row['localId'] as int?, id: row['id'] as int?, creationDate: row['creationDate'] as String, lastUpdate: row['lastUpdate'] as String),
        arguments: [userId, projectId]);
  }

  @override
  Future<List<User>> getUsersInProject(int projectId) async {
    return _queryAdapter.queryList(
        'SELECT User.* FROM User LEFT JOIN ProjectUser ON User.id = ProjectUser.userId WHERE ProjectUser.projectId = ?1',
        mapper: (Map<String, Object?> row) => User(row['avatar'] as String?, row['token'] as String?, firstName: row['firstName'] as String, lastName: row['lastName'] as String, email: row['email'] as String, firebaseId: row['firebaseId'] as String, localId: row['localId'] as int?, id: row['id'] as int?, creationDate: row['creationDate'] as String, lastUpdate: row['lastUpdate'] as String),
        arguments: [projectId]);
  }

  @override
  Stream<User?> getCurrentUser() {
    return _queryAdapter.queryStream(
        'SELECT * FROM User WHERE token IS NOT NULL LIMIT 1',
        mapper: (Map<String, Object?> row) => User(
            row['avatar'] as String?, row['token'] as String?,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            email: row['email'] as String,
            firebaseId: row['firebaseId'] as String,
            localId: row['localId'] as int?,
            id: row['id'] as int?,
            creationDate: row['creationDate'] as String,
            lastUpdate: row['lastUpdate'] as String),
        queryableName: 'User',
        isView: false);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM User');
  }

  @override
  Future<int> insert(User item) {
    return _userInsertionAdapter.insertAndReturnId(
        item, OnConflictStrategy.rollback);
  }

  @override
  Future<List<int>> insertAll(List<User> entitiesToCreate) {
    return _userInsertionAdapter.insertListAndReturnIds(
        entitiesToCreate, OnConflictStrategy.rollback);
  }

  @override
  Future<int> updateAll(List<User> entitiesToUpdate) {
    return _userUpdateAdapter.updateListAndReturnChangedRows(
        entitiesToUpdate, OnConflictStrategy.ignore);
  }

  @override
  Future<int> update(User entity) {
    return _userUpdateAdapter.updateAndReturnChangedRows(
        entity, OnConflictStrategy.ignore);
  }
}

class _$UserInfoDao extends UserInfoDao {
  _$UserInfoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _userInfoInsertionAdapter = InsertionAdapter(
            database,
            'UserInfo',
            (UserInfo item) => <String, Object?>{
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'email': item.email,
                  'avatar': item.avatar,
                  'localId': item.localId,
                  'id': item.id,
                  'creationDate': item.creationDate,
                  'lastUpdate': item.lastUpdate
                },
            changeListener),
        _userInfoUpdateAdapter = UpdateAdapter(
            database,
            'UserInfo',
            ['localId'],
            (UserInfo item) => <String, Object?>{
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'email': item.email,
                  'avatar': item.avatar,
                  'localId': item.localId,
                  'id': item.id,
                  'creationDate': item.creationDate,
                  'lastUpdate': item.lastUpdate
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserInfo> _userInfoInsertionAdapter;

  final UpdateAdapter<UserInfo> _userInfoUpdateAdapter;

  @override
  Stream<UserInfo?> getByLocalId(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM UserInfo WHERE localId = ?1',
        mapper: (Map<String, Object?> row) => UserInfo(row['avatar'] as String?,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            email: row['email'] as String,
            localId: row['localId'] as int?,
            id: row['id'] as int?,
            creationDate: row['creationDate'] as String,
            lastUpdate: row['lastUpdate'] as String),
        arguments: [id],
        queryableName: 'UserInfo',
        isView: false);
  }

  @override
  Stream<UserInfo?> getByServerId(int serverId) {
    return _queryAdapter.queryStream('SELECT * FROM UserInfo WHERE id = ?1',
        mapper: (Map<String, Object?> row) => UserInfo(row['avatar'] as String?,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            email: row['email'] as String,
            localId: row['localId'] as int?,
            id: row['id'] as int?,
            creationDate: row['creationDate'] as String,
            lastUpdate: row['lastUpdate'] as String),
        arguments: [serverId],
        queryableName: 'UserInfo',
        isView: false);
  }

  @override
  Future<void> deleteByLocalId(int localId) async {
    await _queryAdapter.queryNoReturn('DELETE FROM UserInfo WHERE localId = ?1',
        arguments: [localId]);
  }

  @override
  Future<void> deleteByServerId(int serverId) async {
    await _queryAdapter.queryNoReturn('DELETE FROM UserInfo WHERE id = ?1',
        arguments: [serverId]);
  }

  @override
  Future<List<UserInfo>> getUserInfosInProject(int projectId) async {
    return _queryAdapter.queryList(
        'SELECT UserInfo.* FROM UserInfo LEFT JOIN ProjectUser ON (UserInfo.id = ProjectUser.userId) WHERE ProjectUser.projectId = ?1',
        mapper: (Map<String, Object?> row) => UserInfo(row['avatar'] as String?, firstName: row['firstName'] as String, lastName: row['lastName'] as String, email: row['email'] as String, localId: row['localId'] as int?, id: row['id'] as int?, creationDate: row['creationDate'] as String, lastUpdate: row['lastUpdate'] as String),
        arguments: [projectId]);
  }

  @override
  Future<List<UserInfo>> getAll() async {
    return _queryAdapter.queryList(
        'SELECT * FROM UserInfo ORDER BY creationDate DESC',
        mapper: (Map<String, Object?> row) => UserInfo(row['avatar'] as String?,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            email: row['email'] as String,
            localId: row['localId'] as int?,
            id: row['id'] as int?,
            creationDate: row['creationDate'] as String,
            lastUpdate: row['lastUpdate'] as String));
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM UserInfo');
  }

  @override
  Future<int> insert(UserInfo item) {
    return _userInfoInsertionAdapter.insertAndReturnId(
        item, OnConflictStrategy.rollback);
  }

  @override
  Future<List<int>> insertAll(List<UserInfo> entitiesToCreate) {
    return _userInfoInsertionAdapter.insertListAndReturnIds(
        entitiesToCreate, OnConflictStrategy.rollback);
  }

  @override
  Future<int> updateAll(List<UserInfo> entitiesToUpdate) {
    return _userInfoUpdateAdapter.updateListAndReturnChangedRows(
        entitiesToUpdate, OnConflictStrategy.ignore);
  }

  @override
  Future<int> update(UserInfo entity) {
    return _userInfoUpdateAdapter.updateAndReturnChangedRows(
        entity, OnConflictStrategy.ignore);
  }
}

class _$ProjectUserDao extends ProjectUserDao {
  _$ProjectUserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _projectUserInsertionAdapter = InsertionAdapter(
            database,
            'ProjectUser',
            (ProjectUser item) => <String, Object?>{
                  'projectId': item.projectId,
                  'userId': item.userId,
                  'localId': item.localId,
                  'id': item.id,
                  'creationDate': item.creationDate,
                  'lastUpdate': item.lastUpdate
                },
            changeListener),
        _projectUserUpdateAdapter = UpdateAdapter(
            database,
            'ProjectUser',
            ['localId'],
            (ProjectUser item) => <String, Object?>{
                  'projectId': item.projectId,
                  'userId': item.userId,
                  'localId': item.localId,
                  'id': item.id,
                  'creationDate': item.creationDate,
                  'lastUpdate': item.lastUpdate
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ProjectUser> _projectUserInsertionAdapter;

  final UpdateAdapter<ProjectUser> _projectUserUpdateAdapter;

  @override
  Stream<ProjectUser?> getByLocalId(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM ProjectUser WHERE localId = ?1',
        mapper: (Map<String, Object?> row) => ProjectUser(
            projectId: row['projectId'] as int,
            userId: row['userId'] as int,
            localId: row['localId'] as int?,
            id: row['id'] as int?,
            creationDate: row['creationDate'] as String,
            lastUpdate: row['lastUpdate'] as String),
        arguments: [id],
        queryableName: 'ProjectUser',
        isView: false);
  }

  @override
  Stream<ProjectUser?> getByServerId(int serverId) {
    return _queryAdapter.queryStream('SELECT * FROM ProjectUser WHERE id = ?1',
        mapper: (Map<String, Object?> row) => ProjectUser(
            projectId: row['projectId'] as int,
            userId: row['userId'] as int,
            localId: row['localId'] as int?,
            id: row['id'] as int?,
            creationDate: row['creationDate'] as String,
            lastUpdate: row['lastUpdate'] as String),
        arguments: [serverId],
        queryableName: 'ProjectUser',
        isView: false);
  }

  @override
  Future<void> deleteByLocalId(int localId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM ProjectUser WHERE localId = ?1',
        arguments: [localId]);
  }

  @override
  Future<void> deleteByProjectId(int projectId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM ProjectUser WHERE projectId = ?1',
        arguments: [projectId]);
  }

  @override
  Future<void> deleteByServerId(int serverId) async {
    await _queryAdapter.queryNoReturn('DELETE FROM ProjectUser WHERE id = ?1',
        arguments: [serverId]);
  }

  @override
  Future<List<ProjectUser>> getAll() async {
    return _queryAdapter.queryList(
        'SELECT * FROM ProjectUser ORDER BY creationDate DESC',
        mapper: (Map<String, Object?> row) => ProjectUser(
            projectId: row['projectId'] as int,
            userId: row['userId'] as int,
            localId: row['localId'] as int?,
            id: row['id'] as int?,
            creationDate: row['creationDate'] as String,
            lastUpdate: row['lastUpdate'] as String));
  }

  @override
  Future<List<ProjectUser>> getByProjectId(int projectId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ProjectUser WHERE projectId = ?1',
        mapper: (Map<String, Object?> row) => ProjectUser(
            projectId: row['projectId'] as int,
            userId: row['userId'] as int,
            localId: row['localId'] as int?,
            id: row['id'] as int?,
            creationDate: row['creationDate'] as String,
            lastUpdate: row['lastUpdate'] as String),
        arguments: [projectId]);
  }

  @override
  Future<List<ProjectUser>> getByUserId(int userId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ProjectUser WHERE userId = ?1',
        mapper: (Map<String, Object?> row) => ProjectUser(
            projectId: row['projectId'] as int,
            userId: row['userId'] as int,
            localId: row['localId'] as int?,
            id: row['id'] as int?,
            creationDate: row['creationDate'] as String,
            lastUpdate: row['lastUpdate'] as String),
        arguments: [userId]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM ProjectUser');
  }

  @override
  Future<int> insert(ProjectUser item) {
    return _projectUserInsertionAdapter.insertAndReturnId(
        item, OnConflictStrategy.rollback);
  }

  @override
  Future<List<int>> insertAll(List<ProjectUser> entitiesToCreate) {
    return _projectUserInsertionAdapter.insertListAndReturnIds(
        entitiesToCreate, OnConflictStrategy.rollback);
  }

  @override
  Future<int> updateAll(List<ProjectUser> entitiesToUpdate) {
    return _projectUserUpdateAdapter.updateListAndReturnChangedRows(
        entitiesToUpdate, OnConflictStrategy.ignore);
  }

  @override
  Future<int> update(ProjectUser entity) {
    return _projectUserUpdateAdapter.updateAndReturnChangedRows(
        entity, OnConflictStrategy.ignore);
  }
}
