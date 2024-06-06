import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/feature/auth/auth.dart';

final authChangeNotifierProvider =
    ChangeNotifierProvider<AuthChangeNotifier>((ref) {
  final authUserNotifier = ref.read(authUserProvider.notifier);
  return AuthChangeNotifier(authUserNotifier: authUserNotifier);
});

class AuthChangeNotifier extends ChangeNotifier {
  final AuthUserNotifier _authUserNotifier;
  AuthStatus _authStatus = AuthStatus.checking;

  AuthChangeNotifier({
    required AuthUserNotifier authUserNotifier,
  }) : _authUserNotifier = authUserNotifier {
    onAuthChange();
  }

  void onAuthChange() {
    _authUserNotifier.addListener((state) {
      _authStatus = state.status;
      notifyListeners();
    });
  }

  AuthStatus get authStatus => _authStatus;
  set authStatus(AuthStatus authStatus) {
    _authStatus = authStatus;
    notifyListeners();
  }
}
