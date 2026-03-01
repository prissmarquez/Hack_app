import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  String? emergencyName;
  String? emergencyPhone;
  bool loading = true;

  // Números de auxilio (Puebla)
  final List<_HelpNumber> pueblaHelpNumbers = const [
    _HelpNumber(title: 'Emergencias (México)', number: '911'),
    _HelpNumber(title: 'Denuncia anónima (Puebla)', number: '089'),
    _HelpNumber(title: 'Protección Civil (Puebla)', number: '222 246 2750'),
    _HelpNumber(title: 'Cruz Roja (Puebla)', number: '222 213 7700'),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      emergencyName = prefs.getString('emergency_name');
      emergencyPhone = prefs.getString('emergency_phone');
      loading = false;
    });
  }

  Future<void> _clearEmergencyContact() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('emergency_name');
    await prefs.remove('emergency_phone');
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SOS')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Contacto de emergencia',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                Card(
                  child: ListTile(
                    title: Text(emergencyName?.trim().isNotEmpty == true
                        ? emergencyName!
                        : 'No guardado'),
                    subtitle: Text(emergencyPhone?.trim().isNotEmpty == true
                        ? emergencyPhone!
                        : 'Guarda un contacto para mostrarlo aquí'),
                    trailing: emergencyName != null || emergencyPhone != null
                        ? IconButton(
                            tooltip: 'Borrar',
                            icon: const Icon(Icons.delete_outline),
                            onPressed: _clearEmergencyContact,
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: 20),
                const Text(
                  'Servicios de auxilio en Puebla',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                ...pueblaHelpNumbers.map(
                  (h) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.local_phone_outlined),
                      title: Text(h.title),
                      subtitle: Text(h.number),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _HelpNumber {
  final String title;
  final String number;
  const _HelpNumber({required this.title, required this.number});
}