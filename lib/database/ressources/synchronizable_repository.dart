
import 'synchronizable_dao.dart';
import 'synchronizable_entity.dart';

abstract class SynchronizableRepository<T extends SynchronizableEntity> {
  late SynchronizableDao dao;

  setDao(SynchronizableDao dao) {
    this.dao = dao;
  }
  Future<SynchronizableEntity>fromJson(Map<String, dynamic> json);
  Future<Map<String, dynamic>> toJson(T entity);

  Future<SynchronizableEntity?> getByLocalId(int entityId);

  Future<SynchronizableEntity?> getByServerId(int entityId);

  Future<List<SynchronizableEntity>> getAll();

  deleteByServerId(int serverId);

  saveAll(List<T> entitiesToCreate, List<T> entitiesToUpdate);

  deleteByLocalId(int localId);
}
