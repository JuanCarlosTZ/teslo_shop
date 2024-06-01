import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

class _FormView extends StatelessWidget {
  const _FormView();

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: Column(
        children: [
          Text('Nueva cuenta', style: textStyles.titleMedium),
          const SizedBox(height: 60),
          const CustomTextFormField(label: 'Nombre completo'),
          const SizedBox(height: 30),
          const CustomTextFormField(label: 'Correo'),
          const SizedBox(height: 30),
          const CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
          ),
          const SizedBox(height: 30),
          const CustomTextFormField(
            label: 'Repetir la contraseña',
            obscureText: true,
          ),
          const SizedBox(height: 30),
          CustomFilledButton(
            text: 'Crear',
            buttonColor: Colors.black,
            expanded: true,
            onPressed: () {},
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
