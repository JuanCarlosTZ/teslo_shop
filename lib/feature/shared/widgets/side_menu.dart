import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/feature/auth/auth.dart';
import 'package:teslo_shop/feature/shared/widgets/custom_filled_button.dart';

class SideMenu extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const SideMenu({super.key, required this.scaffoldKey});

  @override
  ConsumerState<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends ConsumerState<SideMenu> {
  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final double firstPadding = forceTopPadding(context: context, padding: 44);
    return NavigationDrawer(
        elevation: 1,
        selectedIndex: navDrawerIndex,
        onDestinationSelected: (value) {
          setState(() {
            navDrawerIndex = value;
          });

          // final menuItem = appMenuItems[value];
          // context.push( menuItem.link );
          widget.scaffoldKey.currentState?.closeDrawer();
        },
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20, firstPadding, 16, 0),
            child: Text('Saludos', style: textStyles.titleMedium),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 16, 10),
            child: Text('Tony Stark', style: textStyles.titleSmall),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.home_outlined),
            label: Text('Productos'),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
            child: Divider(),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
            child: Text('Otras opciones'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: CustomFilledButton(
              text: 'Cerrar sesión',
              onPressed: () {
                ref.read(authUserProvider.notifier).setLogoutUser();
                widget.scaffoldKey.currentState?.closeDrawer();
              },
            ),
          )
        ]);
  }
}
