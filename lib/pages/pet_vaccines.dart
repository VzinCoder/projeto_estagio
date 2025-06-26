import 'package:flutter/material.dart';
import '../my_app_routes.dart';
import '../models/vaccine.dart';

class PetVaccines extends StatelessWidget {
  const PetVaccines({super.key});

  Future<List<Vaccine>> fetchVaccines() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Vaccine(
        id: 1,
        name: '🧪 Antirrábica muito muito muito muito muito muito longa',
        dateApplication: '12/03/2024',
        nextDateApplication: '12/03/2025',
        petId: 1,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Vacinas do Pet",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, MyAppRoutes.addPetVaccine.routeName);
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: FutureBuilder<List<Vaccine>>(
          future: fetchVaccines(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Nenhuma vacina encontrada.'));
            }
            return VaccineList(vaccines: snapshot.data!);
          },
        ),
      ),
    );
  }
}

class VaccineList extends StatelessWidget {
  final List<Vaccine> vaccines;
  const VaccineList({super.key, required this.vaccines});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: vaccines.length,
      itemBuilder: (context, index) {
        final vaccine = vaccines[index];
        return VaccineCardItem(
          name: vaccine.name,
          dateApplication: '📅 ${vaccine.dateApplication}',
          nextDateApplication: '📅 Próxima: ${vaccine.nextDateApplication}',
          onEdit: () {},
          onDelete: () {},
        );
      },
    );
  }
}

class VaccineCardItem extends StatelessWidget {
  final String name;
  final String dateApplication;
  final String nextDateApplication;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const VaccineCardItem({
    super.key,
    required this.name,
    required this.dateApplication,
    required this.nextDateApplication,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(dateApplication, overflow: TextOverflow.ellipsis),
                  Text(nextDateApplication, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: onEdit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    minimumSize: const Size(40, 40),
                  ),
                  child: const Icon(Icons.edit, size: 20),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onDelete,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    minimumSize: const Size(40, 40),
                  ),
                  child: const Icon(Icons.delete, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
