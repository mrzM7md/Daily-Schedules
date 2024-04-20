abstract class IGetShared<T> {
  Future<List<T>> getAll();
  Future<List<T>> find({required String keyWord});
}