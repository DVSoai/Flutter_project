import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_gpt_app/bloc/chat/chat_bloc.dart';
import 'package:gemini_gpt_app/bloc/chat/chat_event.dart';
import 'package:gemini_gpt_app/bloc/chat/chat_state.dart';

import 'package:gemini_gpt_app/bloc/theme/theme_bloc.dart';
import 'package:gemini_gpt_app/bloc/theme/theme_event.dart';
import 'package:gemini_gpt_app/bloc/theme/theme_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            elevation: 1,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('assets/gpt-robot.png'),
                    const SizedBox(width: 10),
                    Text('Gemini GPT',
                        style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
                GestureDetector(
                  child: Icon(
                    themeState.themeMode == ThemeMode.dark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    color: themeState.themeMode == ThemeMode.dark
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.primary,
                  ),
                  onTap: () {
                    context.read<ThemeBloc>().add(const ToggleThemeEvent());
                  },
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              // Hiển thị tin nhắn
              Expanded(
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, homeState) {
                    if (homeState is ChatLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (homeState is ChatError) {
                      return Center(
                          child: Text(homeState.error,
                              style: TextStyle(color: Colors.red)));
                    } else if (homeState is ChatLoaded) {
                      return ListView.builder(
                        itemCount: homeState.messages.length,
                        itemBuilder: (context, index) {
                          final message = homeState.messages[index];
                          return ListTile(
                            title: Align(
                              alignment: message.isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: message.isUser
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.secondary,
                                  borderRadius: message.isUser
                                      ? const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20))
                                      : const BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          topLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                ),
                                child: Text(message.text,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: message.isUser
                                                ? Colors.white
                                                : Colors.black)),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const Center(child: Text("Start a conversation"));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 32, top: 16, left: 16, right: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          style: Theme.of(context).textTheme.titleSmall,
                          decoration: InputDecoration(
                            hintText: 'Write your message',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      BlocBuilder<ChatBloc, ChatState>(
                        builder: (context, state) {
                          bool isLoading = state is ChatLoading;
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: GestureDetector(
                              child: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(),
                                    )
                                  : Image.asset('assets/send.png'),
                              onTap: isLoading
                                  ? null
                                  : () {
                                      if (controller.text.isNotEmpty) {
                                        context.read<ChatBloc>().add(
                                            SendMessageEvent(
                                                controller.text.trim()));
                                        controller.clear();
                                      }
                                    },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
