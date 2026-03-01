
import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/Emergency_contact.dart';
import 'package:flutter_application_2/themes/paleta_colores.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                color: AppColors.surface,
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
                              color: AppColors.primary,
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
                                color: AppColors.textPrimary,
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
                          color: AppColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// Campo Nombre
                      TextField(
                        style: const TextStyle(fontSize: 20, color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          labelText: "Tu nombre",
                          hintText: "Ej. Lupita",
                          labelStyle: const TextStyle(fontSize: 18, color: AppColors.textPrimary),
                          hintStyle: const TextStyle(fontSize: 18, color: AppColors.textHint),
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
                                builder: (context) => const EmergencyContactScreen(),
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
                            backgroundColor: AppColors.primaryDark,
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