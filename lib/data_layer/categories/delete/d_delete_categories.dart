import 'package:daily_schedules/data_layer//shared/interface_delete_shared.dart';
import 'package:daily_schedules/shared/constants/tables_names.dart';
import 'package:daily_schedules/shared/data_layer/models/category_model.dart';
import 'package:daily_schedules/shared/local/sqldb.dart';
import 'package:daily_schedules/shared/services/services_locator.dart';

class DeleteCategoriesDBServices extends IDeleteShared<Category> {
  @override
  void deleteAll() {}

  @override
  Future<void> deleteById(String categoryId) async {
    await sl<SqlDb>().deleteData("""
      DELETE FROM '$categories' WHERE id = '$categoryId'
    """);
  }

}
