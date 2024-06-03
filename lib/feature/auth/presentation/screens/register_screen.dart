import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/feature/auth/auth.dart';
import 'package:teslo_shop/feature/auth/presentation/providers/providers.dart';

import 'package:teslo_shop/feature/shared/shared.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _RegisterView(),
    );
  }
}

class _RegisterView extends StatelessWidget {
  const _RegisterView();

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    return CustomGeometricalView(
      headerHeight: 150,
      header: // Icon Banner
          Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                if (!context.canPop()) return;
                context.pop();
              },
              icon: const Icon(Icons.arrow_back_rounded,
                  size: 40, color: Colors.white)),
          const Spacer(flex: 1),
          Text('Crear cuenta',
              style: textStyles.titleLarge?.copyWith(color: Colors.white)),
          const Spacer(flex: 2),
        ],
      ),
      body: const _FormView(),
    );
  }
}

class _FormView extends ConsumerWidget {
  const _FormView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;
    final isPosted = ref.watch(registerFormProvider).isPosted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: Column(
        children: [
          Text('Nueva cuenta', style: textStyles.titleMedium),

          ///*Username
          const SizedBox(height: 60),
          CustomTextFormField(
            label: 'Nombre completo',
            onChanged: ref.read(registerFormProvider.notifier).onUsernameChange,
            errorMessage: !isPosted
                ? null
                : ref.watch(registerFormProvider).username.usernameError(),
          ),

          ///*Email
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Correo',
            onChanged: ref.read(registerFormProvider.notifier).onEmailChange,
            errorMessage: !isPosted
                ? null
                : ref.watch(registerFormProvider).email.emailError(),
          ),

          ///*Passwor
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            onChanged: ref.read(registerFormProvider.notifier).onPasswordChange,
            errorMessage: !isPosted
                ? null
                : ref.watch(registerFormProvider).password.passwordError(),
          ),

          ///*ConfirmPassword
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Repetir la contraseña',
            obscureText: true,
            onChanged:
                ref.read(registerFormProvider.notifier).onConfirmPasswordChange,
            errorMessage: !isPosted
                ? null
                : ref
                    .watch(registerFormProvider)
                    .confirmPassword
                    .confirmPasswordError(),
          ),

          ///*Button create
          const SizedBox(height: 30),
          CustomFilledButton(
            text: 'Crear',
            buttonColor: Colors.black,
            expanded: true,
            onPressed: () {
              ref.read(registerFormProvider.notifier).onSubmitted();
            },
          ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿Ya tienes tu cuenta?'),
              TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('Ingresar aquí')),
            ],
          ),
        ],
      ),
    );
  }
}
