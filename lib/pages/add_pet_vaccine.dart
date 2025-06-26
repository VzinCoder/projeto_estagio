import 'package:flutter/material.dart';

class AddPetVaccine extends StatefulWidget {
  const AddPetVaccine({super.key});

  @override
  State<AddPetVaccine> createState() => _AddPetVaccineState();
}

class _AddPetVaccineState extends State<AddPetVaccine> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateAplicationController = TextEditingController();
  final TextEditingController dateNextController = TextEditingController();

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      controller.text = "${date.day}/${date.month}/${date.year}";
    }
  }

  void save() {
    String name = nameController.text;
    String aplication = dateAplicationController.text;
    String nextAplication = dateNextController.text;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Vacina salva com sucesso!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar Vacina", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: dateAplicationController,
              readOnly: true,
              onTap: () => _selectDate(dateAplicationController),
              decoration: const InputDecoration(
                labelText: 'Data de Aplicação',
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: dateNextController,
              readOnly: true,
              onTap: () => _selectDate(dateNextController),
              decoration: const InputDecoration(
                labelText: 'Próxima Dose',
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: save,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
