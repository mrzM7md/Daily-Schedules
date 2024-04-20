import 'package:daily_schedules/data_layer/shared/interface_insert_shared.dart';
import 'package:daily_schedules/shared/constants/tables_names.dart';
import 'package:daily_schedules/shared/local/sqldb.dart';
import '../../../shared/data_layer/models/category_model.dart';
import '../../../shared/services/services_locator.dart';

class InsertCategoriesDBServices extends IInsertShared<Category> {
  @override
  Future<void> setAll(Category category) async {
    await sl<SqlDb>().insertData("""
      INSERT INTO '$categories' VALUES (
        '${category.id}',
        '${category.name}',
        '${DateTime.now()}'
      )
    """);
  }
}