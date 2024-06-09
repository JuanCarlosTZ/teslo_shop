import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/feature/auth/auth.dart';
import 'package:teslo_shop/feature/shared/shared.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: const CustomGeometricalView(
        header: Icon(Icons.production_quantity_limits,
            size: 100, color: Colors.white),
        body: _FormView(),
      ),
    );
  }
}

class _FormView extends ConsumerWidget {
  const _FormView();

  showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthUserState>(authUserProvider, (previous, next) {
      if (next.status == AuthStatus.authorized) {
        showSnackbar(context, 'Sesión iniciada');
        return;
      }

      showSnackbar(context, next.message);
    });

    final textStyles = Theme.of(context).textTheme;
    final loginForm = ref.watch(loginFormProvider);
    final isPosted = loginForm.isPosted;
    final isPosting = loginForm.isPosting;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Text('Login', style: textStyles.titleLarge),
          const SizedBox(height: 80),

          ///*Email
          CustomTextFormField(
            label: 'Correo',
            required: loginForm.email.isRequired,
            onChanged: ref.read(loginFormProvider.notifier).onEmailChange,
            errorMessage: !isPosted
                ? null
                : ref.watch(loginFormProvider).email.emailError(),
          ),
          const SizedBox(height: 30),

          ///*Password
          CustomTextFormField(
            label: 'Contraseña',
            required: loginForm.password.isRequired,
            obscureText: true,
            onChanged: ref.read(loginFormProvider.notifier).onPasswordChange,
            onFieldSubmitted: (value) =>
                ref.read(loginFormProvider.notifier).onSubmitted(),
            errorMessage: !isPosted
                ? null
                : ref.watch(loginFormProvider).password.passwordError(),
          ),
          const SizedBox(height: 30),

          ///*Iniciar sesión Button
          CustomFilledButton(
            text: 'Iniciar sesión',
            buttonColor: Colors.black,
            expanded: true,
            onPressed: isPosting
                ? null
                : ref.read(loginFormProvider.notifier).onSubmitted,
          ),

          const SizedBox(height: 10),

          isPosting
              ? const SizedBox(
                  height: 60, child: Center(child: CircularProgressIndicator()))
              : const SizedBox(
                  height: 60,
                ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿No tienes cuenta?'),
              TextButton(
                  onPressed: () {
                    context.push(PathParameter.registerPath);
                  },
                  child: const Text('Crea una aquí')),
            ],
          ),
        ],
      ),
    );
  }
}
