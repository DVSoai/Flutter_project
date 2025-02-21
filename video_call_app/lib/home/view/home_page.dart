import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_call_app/navigation/view/bottom_nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return HomeView(navigationShell: navigationShell);
  }
}

class HomeView extends StatefulWidget {
  const HomeView({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bottomNavigationBar:
          BottomNavBar(navigationShell: widget.navigationShell),
      body: widget.navigationShell,
    );
  }
}
