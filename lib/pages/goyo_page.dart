import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';

class GoyoChatScreen extends StatefulWidget {
  //
  final String? initialMessage;

  const GoyoChatScreen({super.key, this.initialMessage});

  @override
  State<GoyoChatScreen> createState() => _GoyoChatScreenState();
}

class _GoyoChatScreenState extends State<GoyoChatScreen> {
  final TextEditingController _controladorTexto = TextEditingController();

  // 
  final String apiKey = 'AIzaSyBhJ5nY3dUd2NDPqPSlnpqjQaltK87ldks';

  late final GenerativeModel _model;

  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool _isListening = false;
  bool _isThinking = false;

  String _textoEscuchado = "Presione el micrófono para hablar con Goyo...";
  String _respuestaGoyo = "";

  final String _nombreUsuario = "Don Arturo";
  bool _alertaEstres = false;

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

  @override
  void initState() {
    super.initState();
    _inicializarGoyo();
    _configurarVoz();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final msg = widget.initialMessage?.trim() ?? '';
      if (msg.isNotEmpty) {
        _textoEscuchado = msg; // para que se vea lo que escribió
        _enviarAGemini(msg);
      }
    });
  }

  void _inicializarGoyo() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(_systemPrompt),
    );
  }

  Future<void> _configurarVoz() async {
    await _flutterTts.setLanguage("es-MX");
    await _flutterTts.setPitch(1);
    await _flutterTts.setSpeechRate(0.95);
    if (kIsWeb) return;
  }

  Future<void> _escucharVoz() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      return;
    }

    final available = await _speech.initialize(
      onStatus: (status) => debugPrint('STT status: $status'),
      onError: (error) => debugPrint('STT error: $error'),
    );

    if (!available) {
      setState(() => _textoEscuchado = "No se pudo usar el micrófono.");
      return;
    }

    setState(() {
      _isListening = true;
      _textoEscuchado = "";
      _alertaEstres = false;
    });

    _speech.listen(
      localeId: "es_MX",
      onResult: (val) async {
        setState(() => _textoEscuchado = val.recognizedWords);

        if (val.finalResult) {
          await _speech.stop();
          setState(() => _isListening = false);
          await _enviarAGemini(_textoEscuchado);
        }
      },
    );
  }

  Future<void> _enviarAGemini(String mensaje) async {
    final text = mensaje.trim();
    if (text.isEmpty) return;

    setState(() {
      _isThinking = true;
      _respuestaGoyo = "";
    });

    try {
      final promptFinal = "[Nombre: $_nombreUsuario] $text";

      final response = await _model.generateContent([
        Content.text(promptFinal),
      ]);

      var textoBruto = response.text ?? "Perdón, no le entendí bien.";

      if (textoBruto.contains('[FLAG_ESTRES]')) {
        _alertaEstres = true;
        textoBruto = textoBruto.replaceAll('[FLAG_ESTRES]', '');
      }

      final exp = RegExp(r'\[JSON_MED:\s*({.*?})\s*\]');
      final match = exp.firstMatch(textoBruto);
      if (match != null) {
        final jsonDetectado = match.group(1)!;
        debugPrint("💊 JSON_MED detectado: $jsonDetectado");
        textoBruto = textoBruto.replaceAll(match.group(0)!, '');
      }

      textoBruto = textoBruto.trim();

      setState(() {
        _isThinking = false;
        _respuestaGoyo = textoBruto;
      });

      await _flutterTts.speak(_respuestaGoyo);
    } catch (e) {
      debugPrint("🚨 ERROR GEMINI: $e");
      setState(() {
        _isThinking = false;
        _respuestaGoyo =
            "Ay caray, algo falló con el internet o la llave. ¿Me repite?";
      });
      await _flutterTts.speak(_respuestaGoyo);
    }
  }

  @override
  void dispose() {
    _controladorTexto.dispose();
    _speech.stop();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tu nieto Goyo"),
        backgroundColor: _alertaEstres ? Colors.red[300] : Colors.teal[300],
      ),
      backgroundColor: _alertaEstres ? Colors.red[50] : Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            if (_alertaEstres)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: Colors.red, size: 30),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Modo paciencia activado. El usuario se nota frustrado.",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

            Expanded(
              child: Center(
                child: _isThinking
                    ? const CircularProgressIndicator()
                    : Text(
                        _respuestaGoyo.isNotEmpty
                            ? _respuestaGoyo
                            : "Toque el botón grande de abajo para platicar.",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                _textoEscuchado,
                style: const TextStyle(fontSize: 18, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: _escucharVoz,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isListening ? Colors.redAccent : Colors.teal,
                ),
                child: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controladorTexto,
                    decoration: InputDecoration(
                      hintText: "Escríbele a Goyo...",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                    onSubmitted: (v) {
                      _enviarAGemini(v);
                      _controladorTexto.clear();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.teal,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      final v = _controladorTexto.text;
                      _enviarAGemini(v);
                      _controladorTexto.clear();
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}