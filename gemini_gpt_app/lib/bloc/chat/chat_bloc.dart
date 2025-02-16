import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemini_gpt_app/bloc/chat/chat_event.dart';
import 'package:gemini_gpt_app/bloc/chat/chat_state.dart';
import 'package:gemini_gpt_app/models/message_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final List<MessageModel> _messages = [];

  ChatBloc() : super(ChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    try {
      _messages.add(MessageModel(text: event.userMessage, isUser: true));
      emit(ChatLoading());

      final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: dotenv.env['GOOGLE_API_KEY']!,
      );

      final response =
          await model.generateContent([Content.text(event.userMessage)]);

      _messages.add(
          MessageModel(text: response.text ?? "No response", isUser: false));

      emit(ChatLoaded(List.from(_messages)));
    } catch (e) {
      emit(ChatError("Error: $e"));
    }
  }
}
