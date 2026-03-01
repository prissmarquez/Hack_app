import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool get isListening => _speechToText.isListening;

  /// Inicializa ambos motores (Micro y Altavoz)
  /// [onSilence] se ejecuta automáticamente cuando el abuelo deja de hablar.
  Future<void> init({required Function() onSilence}) async {
    await _speechToText.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          onSilence();
        }
      },
    );

    await _flutterTts.setLanguage("es-MX");
    await _flutterTts.setSpeechRate(0.45);
    await _flutterTts.setPitch(1.1);
  }

  /// Empieza a escuchar y va devolviendo el texto en tiempo real
  Future<void> startListening({
    required Function(String) onTextRecognized,
  }) async {
    await _flutterTts.stop();
    await _speechToText.listen(
      onResult: (result) {
        onTextRecognized(result.recognizedWords);
      },
      pauseFor: const Duration(seconds: 3),
    );
  }

  /// Detiene la escucha manualmente
  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  /// Hace que Goyo hable.
  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }
}
