
import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/homePage.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    const warmBg = Color(0xFFFFF3E9);
    const cardColor = Colors.white;
    const warmAccent = Color(0xFFE07A5F);
    const textDark = Color(0xFF2B2B2B);

    return Scaffold(
      backgroundColor: warmBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                color: cardColor,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 26,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /// Encabezado
                      Row(
                        children: const [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: Color(0xFFFFE4D6),
                            child: Icon(
                              Icons.favorite,
                              color: warmAccent,
                              size: 28,
                            ),
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              "¡Hola! Bienvenido",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: textDark,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        "Para comenzar, escribe tu nombre.\nAsí podremos saludarte 😊",
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.4,
                          color: Color(0xFF4A4A4A),
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// Campo Nombre
                      TextField(
                        style: const TextStyle(fontSize: 20, color: textDark),
                        decoration: InputDecoration(
                          labelText: "Tu nombre",
                          hintText: "Ej. Lupita",
                          labelStyle: const TextStyle(fontSize: 18),
                          hintStyle: const TextStyle(fontSize: 18),
                          prefixIcon: const Icon(Icons.person),
                          filled: true,
                          fillColor: Color(0xFFFFFAF6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 16,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      /// Botón
                      SizedBox(
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text(
                            "Continuar",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: warmAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      const Text(
                        "Puedes pedir ayuda si lo necesitas.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF6B6B6B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}