import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:env/env.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:user_repository/user_repository.dart';

import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required User user,
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(
          user.isAnonymous
              ? const AppState.unauthenticated()
              : AppState.authenticated(user),
        ) {
    on<AppLogoutRequested>(_onAppLogoutRequested);
    on<AppUserChanged>(_onUserChanged);

    _userSubscription =
        userRepository.user.listen(_userChanged, onError: addError);
  }

  final UserRepository _userRepository;

  StreamSubscription<User>? _userSubscription;

  void _userChanged(User user) => add(AppUserChanged(user));

  void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
    final user = event.user;

    void authenticate() {
      emit(AppState.authenticated(user));
      try {
        ZegoUIKitPrebuiltCallInvitationService().init(
          appID: 407423114,
          appSign:
              'd44f1a5449b219f874c013f1d4d5f604c2edafb21df93880448953ff7249a2ef',
          userID: user.id,
          userName: user.name,
          plugins: [ZegoUIKitSignalingPlugin()],
          notificationConfig: ZegoCallInvitationNotificationConfig(
            androidNotificationConfig: ZegoCallAndroidNotificationConfig(
              showFullScreen: true,
            ),
            iOSNotificationConfig: ZegoCallIOSNotificationConfig(
              systemCallingIconName: 'CallKitIcon',
            ),
          ),
          requireConfig: (ZegoCallInvitationData data) {
            final config = (data.invitees.length > 1)
                ? ZegoCallInvitationType.videoCall == data.type
                    ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                    : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
                : ZegoCallInvitationType.videoCall == data.type
                    ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                    : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

            config.topMenuBar.isVisible = true;
            config.topMenuBar.buttons
                .insert(0, ZegoCallMenuBarButtonName.minimizingButton);

            return config;
          },
        );
        debugPrint(
            'ZegoUIKitPrebuiltCallInvitationService initialized successfully');
      } catch (error, stackTrace) {
        debugPrint(
            'Error initializing ZegoUIKitPrebuiltCallInvitationService: $error');
        addError(error, stackTrace);
      }
    }

    switch (state.status) {
      case AppStatus.onboardingRequired:
      case AppStatus.authenticated:
      case AppStatus.unauthenticated:
        return user.isAnonymous
            ? emit(const AppState.unauthenticated())
            : authenticate();
    }
  }

  Future<void> _onAppLogoutRequested(
    AppLogoutRequested event,
    Emitter<AppState> emit,
  ) async {
    try {
      await _userRepository.logOut();
      await ZegoUIKitPrebuiltCallInvitationService().uninit();
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
