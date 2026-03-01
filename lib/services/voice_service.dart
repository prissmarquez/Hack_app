import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_application_2/services/config.dart';

class VoiceService {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  // Modelo de Gemini
  late final GenerativeModel _model;
  bool _isModelInitialized = false;

  // Nombre del usuario
  String _userName = "Usuario";

  bool get isListening => _speechToText.isListening;

  // Callback para cuando la IA está procesando
  Function(bool)? onThinking;

  // Callback para cuando hay un error
  Function(String)? onError;

  /// Prompt del sistema para Goyo
  final String _systemPrompt = """
Eres Goyo, un asistente virtual cariñoso, paciente y respetuoso, diseñado para ser el "nieto digital" de adultos mayores en México. Tu objetivo principal es ayudarlos con trámites, tecnología y recordarles sus medicinas, haciéndolos sentir acompañados y capaces.

Tus Reglas de Personalidad:
Tono: Háblale al usuario siempre de "usted". Usa un tono cálido, empático y con modismos mexicanos suaves y respetuosos (ej. "¡Claro que sí!", "No se preocupe", "Con mucho gusto").
Brevedad: Tus respuestas serán leídas en voz alta por un sistema (TTS), así que DEBEN ser muy cortas. Máximo 2 o 3 oraciones. Ve directo al grano, pero con cariño.
Claridad: Si explicas un trámite, dalo en máximo 3 pasos súper sencillos. Cero jerga técnica.
Contexto: El sistema te enviará el nombre del usuario antes de su mensaje (ej. "[Nombre: Don Arturo]"). Úsalo para saludarlo ocasionalmente.

Tus Reglas de Integración:
Regla de Estrés: Si notas que el usuario está frustrado, triste o enojado, responde con empatía. PERO, al final añade exactamente esta etiqueta oculta: [FLAG_ESTRES].
Regla de Medicinas: Si pide un recordatorio de medicina, confirma y añade al final esta etiqueta: [JSON_MED: {"medicina": "nombre", "hora": "HH:MM"}].
""";

  /// Inicializa ambos motores (Micro y Altavoz)
  /// [onSilence] se ejecuta automáticamente cuando el abuelo deja de hablar.
  Future<void> init({
    required Function() onSilence,
    Function(bool)? onThinking,
    Function(String)? onError,
    String userName = "Usuario",
  }) async {
    // Guardar callbacks
    this.onThinking = onThinking;
    this.onError = onError;
    _userName = userName;

    // Inicializar speech to text
    await _speechToText.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          onSilence();
        }
      },
    );

    // Configurar TTS
    await _flutterTts.setLanguage("es-MX");
    await _flutterTts.setSpeechRate(0.45);
    await _flutterTts.setPitch(1.1);

    // Inicializar Gemini (usando la API key de config)
    try {
      _model = GenerativeModel(
        model: geminiModel,
        apiKey: geminiApiKey,
        systemInstruction: Content.system(_systemPrompt),
      );
      _isModelInitialized = true;
    } catch (e) {
      _isModelInitialized = false;
      this.onError?.call("Error al inicializar la IA: $e");
    }
  }

  /// Empieza a escuchar y va devolviendo el texto en tiempo real
  Future<void> startListening({
    required Function(String) onTextRecognized,
    Function(String)? onFinalResult,
  }) async {
    await _flutterTts.stop();
    await _speechToText.listen(
      onResult: (result) {
        onTextRecognized(result.recognizedWords);
        
        // Si es el resultado final, notificar
        if (result.finalResult && onFinalResult != null) {
          onFinalResult(result.recognizedWords);
        }
      },
      pauseFor: const Duration(seconds: 3),
      localeId: "es_MX",
    );
  }

  /// Detiene la escucha manualmente
  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  /// Envía texto a Gemini y obtiene respuesta
  Future<String?> sendToAI(String text) async {
    if (!_isModelInitialized) {
      onError?.call("La IA no está inicializada");
      return null;
    }

    if (text.trim().isEmpty) {
      return null;
    }

    try {
      onThinking?.call(true);

      final promptFinal = "[Nombre: $_userName] $text";
      
      final response = await _model.generateContent([
        Content.text(promptFinal),
      ]);

      onThinking?.call(false);

      var textoBruto = response.text ?? "Perdón, no le entendí bien.";
      
      // Limpiar etiquetas especiales
      textoBruto = textoBruto.replaceAll('[FLAG_ESTRES]', '');
      textoBruto = textoBruto.replaceAll(RegExp(r'\[JSON_MED:\s*\{.*?\}\s*\]'), '');
      textoBruto = textoBruto.trim();

      return textoBruto;
    } catch (e) {
      onThinking?.call(false);
      onError?.call("Error al comunicarse con la IA: $e");
      return "Ay caray, algo falló con el internet o la llave. ¿Me repite?";
    }
  }

  /// Hace que Goyo hable.
  Future<void> speak(String text) async {
    if (text.isEmpty) return;
    await _flutterTts.speak(text);
  }

  /// Método completo: escuchar, enviar a IA y responder con voz
  Future<void> listenAndRespond({
    required Function(String) onTextRecognized,
  }) async {
    // Primero escuchar
    await startListening(
      onTextRecognized: onTextRecognized,
      onFinalResult: (recognizedText) async {
        // Cuando termine de escuchar, enviar a IA
        final response = await sendToAI(recognizedText);
        
        if (response != null && response.isNotEmpty) {
          // Hablar la respuesta
          await speak(response);
        }
      },
    );
  }

  /// Detiene todo (escucha y voz)
  Future<void> stopAll() async {
    await _speechToText.stop();
    await _flutterTts.stop();
  }
}
