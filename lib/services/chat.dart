import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_application_2/services/config.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  ChatMessage({required this.text, required this.isUser, DateTime? time})
      : time = time ?? DateTime.now();
}

/// Singleton simple (vive mientras la app esté abierta)
class ChatStore {
  ChatStore._();
  static final ChatStore instance = ChatStore._();

  final List<ChatMessage> messages = [];

  // Modelo de Gemini
  GenerativeModel? _model;
  bool _isModelInitialized = false;

  // Nombre del usuario
  String _userName = "Usuario";

  /// Prompt del sistema para Goyo
  final String _systemPrompt = """
Eres Goyo, un asistente virtual cariñoso, paciente y respetuoso, diseñado para ser el "nieto digital" de adultos mayores en México. Tu objetivo principal es ayudarlos con trámites, tecnología y recordarles sus medicinas, haciéndolos sentir acompañados y capaces.

Tus Reglas de Personalidad:
Tono: Háblale al usuario siempre de "usted". Usa un tono cálido, empático y con modismos mexicanos suaves y respetuosos (ej. "¡Claro que sí!", "No se preocupe", "Con mucho gusto").
Brevedad: Tus respuestas serán muy cortas. Máximo 2 o 3 oraciones. Ve directo al grano, pero con cariño.
Claridad: Si explicas un trámite, dalo en máximo 3 pasos súper sencillos. Cero jerga técnica.
Contexto: El sistema te enviará el nombre del usuario antes de su mensaje (ej. "[Nombre: Don Arturo]"). Úsalo para saludarlo ocasionalmente.

Tus Reglas de Integración:
Regla de Estrés: Si notas que el usuario está frustrado, triste o enojado, responde con empatía. PERO, al final añade exactamente esta etiqueta oculta: [FLAG_ESTRES].
Regla de Medicinas: Si pide un recordatorio de medicina, confirma y añade al final esta etiqueta: [JSON_MED: {"medicina": "nombre", "hora": "HH:MM"}].
""";

  /// Inicializa el modelo de IA
  Future<void> initAI({String userName = "Usuario"}) async {
    if (_isModelInitialized) return;
    
    _userName = userName;
    
    try {
      _model = GenerativeModel(
        model: geminiModel,
        apiKey: geminiApiKey,
        systemInstruction: Content.system(_systemPrompt),
      );
      _isModelInitialized = true;
    } catch (e) {
      _isModelInitialized = false;
      print("Error al inicializar la IA: $e");
    }
  }

  void addUser(String text) {
    messages.add(ChatMessage(text: text, isUser: true));
  }

  void addBot(String text) {
    messages.add(ChatMessage(text: text, isUser: false));
  }

  /// Envía texto a Gemini y obtiene respuesta
  Future<String?> sendToAI(String text) async {
    if (!_isModelInitialized || _model == null) {
      await initAI();
    }

    if (_model == null) {
      return "Lo siento, hay un problema con la conexión a la IA.";
    }

    if (text.trim().isEmpty) {
      return null;
    }

    try {
      final promptFinal = "[Nombre: $_userName] $text";
      
      final response = await _model!.generateContent([
        Content.text(promptFinal),
      ]);

      var textoBruto = response.text ?? "Perdón, no le entendí bien.";
      
      // Limpiar etiquetas especiales
      textoBruto = textoBruto.replaceAll('[FLAG_ESTRES]', '');
      textoBruto = textoBruto.replaceAll(RegExp(r'\[JSON_MED:\s*\{.*?\}\s*\]'), '');
      textoBruto = textoBruto.trim();

      return textoBruto;
    } catch (e) {
      print("Error al comunicarse con la IA: $e");
      return "Ay caray, algo falló con el internet o la llave. ¿Me repeats?";
    }
  }
}
