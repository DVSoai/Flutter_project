import 'package:firebase_authentication_client/firebase_authentication_client.dart';
import 'package:user_repository/user_repository.dart';
import 'package:video_call_app/app/view/app.dart';
import 'package:video_call_app/bootstrap.dart';

void main() => bootstrap(() async {
      final firebaseAuthenticationClient = FirebaseAuthenticationClient();
      final userRepository =
          UserRepository(authenticationClient: firebaseAuthenticationClient);

      return App(
        userRepository: userRepository,
        user: await userRepository.user.first,
      );
    });
