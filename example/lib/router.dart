import 'package:example/screens/home/home.screen.dart';
import 'package:example/screens/menu/menu.screen.dart';
import 'package:example/screens/user/sign_in.screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey();
BuildContext get globalContext => globalNavigatorKey.currentContext!;

/// GoRouter
final router = GoRouter(
  // initialLocation: "/chatRoomScreen",
  navigatorKey: globalNavigatorKey,
  routes: [
    GoRoute(
      path: HomeScreen.routeName,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: MenuScreen.routeName,
      builder: (context, state) => const MenuScreen(),
    ),
    GoRoute(
      path: SignInScreen.routeName,
      builder: (context, state) => const SignInScreen(),
    ),
  ],
);
