import '../../infraestructure/datasources/share_preference_datasource.dart';
import '../../domain/datasources/key_value_preference_datasource.dart';
import '../../domain/repositories/key_value_preference_repository.dart';

class KeyValuePreferenceRepositoryImpl extends KeyValuePreferenceRepository {
  final KeyValuePreferenceDatasource datasource;

  KeyValuePreferenceRepositoryImpl({KeyValuePreferenceDatasource? datasource})
      : datasource = datasource ?? SharePreferenceDatasource();
  @override
  Future<T?> getValue<T>(String key) async {
    return await datasource.getValue(key);
  }

  @override
  Future<bool> removeKey<T>(String key) async {
    return await datasource.removeKey(key);
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    return await datasource.setKeyValue(key, value);
  }
}
