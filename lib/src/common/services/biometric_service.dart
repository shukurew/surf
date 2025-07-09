import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Подтвердите личность через биометрию',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }

  Future<bool> canCheckBiometrics() => _auth.canCheckBiometrics;
}
