import 'package:vibration/vibration.dart';

class VibrationService {
  void vibrate() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate();
    }
  }
}
