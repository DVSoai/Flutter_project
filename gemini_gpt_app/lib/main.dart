import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemini_gpt_app/bloc/chat/chat_bloc.dart';
import 'package:gemini_gpt_app/bloc/theme/theme_bloc.dart';
import 'package:gemini_gpt_app/bloc/theme/theme_state.dart';
import 'package:gemini_gpt_app/pages/onboarding.dart';
import 'package:gemini_gpt_app/utils/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(create: (_) => ChatBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Gemini GPT',
            darkTheme: darkMode,
            theme: lightMode,
            themeMode: state.themeMode,
            debugShowCheckedModeBanner: false,
            home: const Onboarding(),
          );
        },
      ),
    );
  }
}
