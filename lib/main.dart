import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(const GoyoApp());
}

class GoyoApp extends StatelessWidget {
  const GoyoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Goyo Asistente',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const GoyoChatScreen(),
    );
  }
}

class GoyoChatScreen extends StatefulWidget {
  const GoyoChatScreen({super.key});

  @override
  State<GoyoChatScreen> createState() => _GoyoChatScreenState();
}

class _GoyoChatScreenState extends State<GoyoChatScreen> {
  // 1. Configuración de Gemini, Voz y TTS 
  final TextEditingController _controladorTexto = TextEditingController();
  final String apiKey = 'AIzaSyBOawbjmI6xsZdis0-z2TNc4WU3h8q5_uI'; // ¡Pon tu API Key aquí!
  late GenerativeModel _model;
  
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  // Variables de estado
  bool _isListening = false;
  bool _isThinking = false;
  String _textoEscuchado = "Presione el micrófono para hablar con Goyo...";
  String _respuestaGoyo = "";
  
  // Variables del Usuario
  final String _nombreUsuario = "Don Arturo"; // Esto lo puedes traer de tu base de datos
  bool _alertaEstres = false; // Cambiará a true si Goyo detecta estrés

  // PROMPT MAESTRO (El que tú diseñaste)
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
  }

  void _inicializarGoyo() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      // Inyectamos tu System Prompt aquí
      //systemInstruction: Content.system(_systemPrompt),
    );
  }

  void _configurarVoz() async {
    await _flutterTts.setLanguage("es-MX");
    await _flutterTts.setPitch(1); // Tono normal
    await _flutterTts.setSpeechRate(1); // Un poco más lento para adultos mayores
if (Theme.of(context).platform == TargetPlatform.fuchsia || kIsWeb) {
    await _flutterTts.setVoice({"name": "Google español de Estados Unidos", "locale": "es-US"});
  }
}
  // 2. Lógica del Micrófono (Escuchar)
  void _escucharVoz() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print('Estado del micro: $status'),
        onError: (error) => print('Error del micro: $error'),
      );

      if (available) {
        setState(() {
          _isListening = true;
          _textoEscuchado = "";
          _alertaEstres = false; // Reiniciamos el estado visual
        });
        
        _speech.listen(
          localeId: "es_MX", // Forzar a escuchar español
          onResult: (val) {
            setState(() {
              _textoEscuchado = val.recognizedWords;
            });
            // Cuando deja de hablar, enviamos a Gemini
            if (val.finalResult) {
              _isListening = false;
              _enviarAGemini(_textoEscuchado);
            }
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  // 3. Conexión con Gemini y Procesamiento de Etiquetas
  Future<void> _enviarAGemini(String mensaje) async {
    if (mensaje.isEmpty) return;

    setState(() {
      _isThinking = true;
      _respuestaGoyo = "";
    });

    try {
      // Le damos formato al mensaje como Goyo espera: "[Nombre: Don Arturo] Hola Goyo..."
      final promptFinal = "[Nombre: $_nombreUsuario] $mensaje";
      final response = await _model.generateContent([Content.text(promptFinal)]);
      
      String textoBruto = response.text ?? "Perdón abuelo, no le entendí bien.";
      
      // -- AQUI PROCESAMOS TUS ETIQUETAS SECRETAS --
      
      // 1. Detectar Estrés
      if (textoBruto.contains('[FLAG_ESTRES]')) {
        setState(() => _alertaEstres = true);
        textoBruto = textoBruto.replaceAll('[FLAG_ESTRES]', ''); // Lo quitamos para no leerlo
      }

      // 2. Detectar Medicina
      RegExp exp = RegExp(r'\[JSON_MED:\s*({.*?})\s*\]');
      var match = exp.firstMatch(textoBruto);
      if (match != null) {
        String jsonDetectado = match.group(1)!;
        // Aquí puedes guardar en tu base de datos o alarmas locales
        print("💊 ¡ALERTA DE MEDICINA DETECTADA!: $jsonDetectado");
        
        // Limpiamos el texto para la voz
        textoBruto = textoBruto.replaceAll(match.group(0)!, ''); 
      }

      // Limpiamos espacios extra
      textoBruto = textoBruto.trim();

      setState(() {
        _isThinking = false;
        _respuestaGoyo = textoBruto;
      });

      // ¡Hacemos que Goyo hable!
      await _flutterTts.speak(_respuestaGoyo);

    } catch (e) {
      print("🚨 ERROR DE GEMINI: $e");
      setState(() {
        _isThinking = false;
        _respuestaGoyo = "Ay caray, se me fue el internet. ¿Me repite?";
      });
      await _flutterTts.speak(_respuestaGoyo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tu nieto Goyo"),
        backgroundColor: _alertaEstres ? Colors.red[300] : Colors.teal[300],
      ),
      // Si hay estrés, cambiamos el fondo sutilmente
      backgroundColor: _alertaEstres ? Colors.red[50] : Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            if (_alertaEstres)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(color: Colors.red[100], borderRadius: BorderRadius.circular(10)),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.red, size: 30),
                    SizedBox(width: 10),
                    Expanded(child: Text("Modo paciencia activado. El usuario se nota frustrado.", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              
            // Chat Bubble Goyo
            Expanded(
              child: Center(
                child: _isThinking
                    ? const CircularProgressIndicator()
                    : Text(
                        _respuestaGoyo.isNotEmpty ? _respuestaGoyo : "Toque el botón grande de abajo para platicar.",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
            
            // Texto de lo que el abuelo está diciendo
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade300)
              ),
              child: Text(
                _textoEscuchado,
                style: const TextStyle(fontSize: 18, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 30),

            // Botón Gigante del Micrófono
            GestureDetector(
              onTap: _escucharVoz,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isListening ? Colors.redAccent : Colors.teal,
                  boxShadow: [
                    BoxShadow(
                      color: (_isListening ? Colors.red : Colors.teal).withOpacity(0.5),
                      blurRadius: _isListening ? 30 : 10,
                      spreadRadius: _isListening ? 10 : 2,
                    )
                  ]
                ),
                child: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _isListening ? "Escuchando..." : "Toque para hablar",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
  const SizedBox(height: 20), // Un pequeño espacio para separar del texto de arriba

        // --- INICIO DE LA CAJA DE TEXTO ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            children: [
              // 1. La caja blanca donde el usuario escribe
              Expanded(
                child: TextField(
                  controller: _controladorTexto,
                  decoration: InputDecoration(
                    hintText: "Escríbele a Goyo...",
                    filled: true,
                    fillColor: Colors.grey[200], // Fondo gris clarito
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ),
              const SizedBox(width: 10), // Espacio entre la caja y el botón
              
              // 2. El botón de Enviar
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.teal, // Mismo color de tu app
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    // Verificamos que la caja no esté vacía antes de enviar
                    if (_controladorTexto.text.isNotEmpty) {
                      
                      // 👉 ¡OJO AQUÍ! 
                      // Aquí debes poner la función que usas para mandarle el mensaje a Gemini.
                      // Seguramente se llama algo parecido a esto:
                      _enviarAGemini(_controladorTexto.text);
                      
                      // Limpiamos la cajita después de presionar enviar
                      _controladorTexto.clear(); 
                      
                      // Ocultamos el teclado de la pantalla
                      FocusScope.of(context).unfocus(); 
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        // --- FIN DE LA CAJA DE TEXTO ---
          ],
        ),
      ),
    );
  }
}