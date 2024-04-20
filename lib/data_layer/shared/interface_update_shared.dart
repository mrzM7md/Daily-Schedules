abstract class IUpdateShared<T> {
  Future<void> update(T model);
  Future<void> updateIsFavorite({required bool isFavorite, required String modelId});
}