abstract class KeyValuePreferenceService {
  Future<void> setKeyValue<T>(String key, T value);
  Future<T?> getValue<T>(String key);
  Future<bool> removeKey<T>(String key);
}
