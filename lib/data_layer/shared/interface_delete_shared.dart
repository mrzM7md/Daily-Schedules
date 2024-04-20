abstract class IDeleteShared<T> {
  void deleteAll();
  Future<void> deleteById(String id);
}