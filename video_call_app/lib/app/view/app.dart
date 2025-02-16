import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:video_call_app/app/bloc/app_bloc.dart';
import 'package:video_call_app/app/view/app_view.dart';

class App extends StatelessWidget {
  const App({required this.user, required this.userRepository, super.key});

  final UserRepository userRepository;
  final User user;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: userRepository,
      child: BlocProvider(
        create: (_) => AppBloc(user: user, userRepository: userRepository),
        child: const AppView(),
      ),
    );
  }
}
