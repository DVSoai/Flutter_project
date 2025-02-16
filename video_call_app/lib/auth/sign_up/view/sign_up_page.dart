import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:user_repository/user_repository.dart';
import 'package:video_call_app/auth/cubit/auth_cubit.dart';
import 'package:video_call_app/auth/sign_up/cubit/sign_up_cubit.dart';
import 'package:video_call_app/auth/sign_up/widgets/sign_up_footer.dart';
import 'package:video_call_app/auth/sign_up/widgets/sign_up_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SignUpCubit(userRepository: context.read<UserRepository>()),
      child: const SignUpView(),
    );
  }
}

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomInset: true,
      releaseFocus: true,
      body: AppConstrainedScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * .2),
            const SignUpForm(),
            const SizedBox(height: AppSpacing.md),
            const Spacer(),
            SignUpFooter(
              text: 'Sign in',
              onTap: () {
                context.read<AuthCubit>().changeAuth(showLogin: true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
