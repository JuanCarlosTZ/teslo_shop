import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/datasources/key_value_preference_datasource.dart';

class SharePreferenceDatasource extends KeyValuePreferenceDatasource {
  Future<SharedPreferences> getSharedPreference() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final prefes = await getSharedPreference();
    try {
      if (T == String) return prefes.getString(key) as T?;
      if (T == int) return prefes.getInt(key) as T?;

      return throw UnimplementedError('Get not implemented for type $T');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> removeKey<T>(String key) async {
    try {
      final prefes = await getSharedPreference();
      return await prefes.remove(key);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final prefes = await getSharedPreference();
    try {
      if (T == String) {
        await prefes.setString(key, value as String);
        return;
      }
      if (T == int) {
        await prefes.setInt(key, value as int) as T?;
        return;
      }

      throw UnimplementedError('Set not implemented for type $T');
    } catch (e) {
      rethrow;
    }
  }
}
