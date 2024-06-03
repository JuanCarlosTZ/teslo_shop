import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/feature/auth/presentation/providers/login_form_riverpod.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;
    final isPosted = ref.watch(loginFormProvider).isPosted;

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
            onChanged: ref.read(loginFormProvider.notifier).onEmailChange,
            errorMessage: !isPosted
                ? null
                : ref.watch(loginFormProvider).email.emailError(),
          ),
          const SizedBox(height: 30),

          ///*Password
          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            onChanged: ref.read(loginFormProvider.notifier).onPasswordChange,
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
            onPressed: () {
              ref.read(loginFormProvider.notifier).onSubmitted();
            },
          ),

          const SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿No tienes cuenta?'),
              TextButton(
                  onPressed: () {
                    context.push('/register');
                  },
                  child: const Text('Crea una aquí')),
            ],
          ),
        ],
      ),
    );
  }
}
