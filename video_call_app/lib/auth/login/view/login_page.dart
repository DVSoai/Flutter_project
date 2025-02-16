import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:video_call_app/auth/cubit/auth_cubit.dart';
import 'package:video_call_app/auth/login/cubit/login_cubit.dart';
import 'package:video_call_app/auth/login/widgets/login_footer.dart';
import 'package:video_call_app/auth/login/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginCubit(userRepository: context.read<UserRepository>()),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomInset: true,
      releaseFocus: true,
      body: AppConstrainedScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * .2),
            const LoginForm(),
            const SizedBox(height: AppSpacing.md),
            const Spacer(),
            LoginFooter(
              text: 'Sign up',
              onTap: () {
                context.read<AuthCubit>().changeAuth(showLogin: false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
