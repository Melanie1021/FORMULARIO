import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87, fontSize: 18),
          bodyMedium: TextStyle(color: Colors.black54, fontSize: 16),
        ),
      ),
      home: const RegistrationForm(),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  String gender = '';
  List<String> maritalStatus = ['Soltero', 'Casado', 'Divorciado', 'Viudo'];
  List<bool> maritalStatusSelected = [false, false, false, false];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final String maritalStatusString = maritalStatus
          .asMap()
          .entries
          .where((entry) => maritalStatusSelected[entry.key])
          .map((entry) => entry.value)
          .join(', ');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Formulario enviado: $maritalStatusString')),
      );
    }
  }

  void _exitApp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Salir'),
        content: const Text('¿Estás seguro de que deseas salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(16.0),
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Formulario',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nombres y Apellidos
                      _buildTextField(
                        controller: firstNameController,
                        label: 'Nombres',
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: lastNameController,
                        label: 'Apellidos',
                        icon: Icons.person_outline,
                      ),

                      const SizedBox(height: 24),

                      // Cédula
                      _buildTextField(
                        controller: idController,
                        label: 'Cédula',
                        icon: Icons.credit_card,
                      ),
                      const SizedBox(height: 16),

                      // Fecha de Nacimiento
                      GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            birthDateController.text =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                          }
                        },
                        child: AbsorbPointer(
                          child: _buildTextField(
                            controller: birthDateController,
                            label: 'Fecha de Nacimiento (yyyy-mm-dd)',
                            icon: Icons.calendar_today,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Género
                      Text('Género:', style: _sectionTitleStyle()),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Masculino'),
                              value: 'Masculino',
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Femenino'),
                              value: 'Femenino',
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      // Estado Civil
                      const SizedBox(height: 16),
                      Text('Estado Civil:', style: _sectionTitleStyle()),
                      Column(
                        children: List.generate(maritalStatus.length, (index) {
                          return CheckboxListTile(
                            title: Text(maritalStatus[index]),
                            value: maritalStatusSelected[index],
                            onChanged: (value) {
                              setState(() {
                                maritalStatusSelected[index] = value!;
                              });
                            },
                          );
                        }),
                      ),
                      const SizedBox(height: 24),

                      // Botones
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildButton(
                            label: 'Guardar',
                            color: Colors.purple,
                            onPressed: _submitForm,
                          ),
                          _buildButton(
                            label: 'Siguiente',
                            color: Colors.green,
                            onPressed: _submitForm,
                          ),
                          _buildButton(
                            label: 'Salir',
                            color: Colors.redAccent,
                            onPressed: _exitApp,
                          ),
                        ],
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

  TextFormField _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.purple),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        labelStyle: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese $label';
        }
        return null;
      },
    );
  }

  TextStyle _sectionTitleStyle() => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.purple,
      );

  ElevatedButton _buildButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
