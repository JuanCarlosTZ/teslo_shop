import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    return const CustomGeometricalView(
      header: Icon(Icons.production_quantity_limits,
          size: 100, color: Colors.white),
      body: _FormView(),
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
          const SizedBox(height: 30),
          Text('Login', style: textStyles.titleLarge),
          const SizedBox(height: 80),
          const CustomTextFormField(label: 'Correo'),
          const SizedBox(height: 30),
          const CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
          ),
          const SizedBox(height: 30),
          CustomFilledButton(
            text: 'Iniciar sesión',
            buttonColor: Colors.black,
            expanded: true,
            onPressed: () {},
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
