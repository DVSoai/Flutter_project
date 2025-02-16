import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final String userMessage;
  const SendMessageEvent(this.userMessage);

  @override
  List<Object?> get props => [userMessage];
}
