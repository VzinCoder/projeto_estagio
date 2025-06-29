import 'package:flutter/material.dart';
import 'package:projeto_estagio/pages/pet_events.dart';
import '../models/pet.dart';
import '../my_app_routes.dart';

class PetDetails extends StatelessWidget {
  final Pet pet;

  const PetDetails({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do Pet", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.deepPurple.shade100,
                      child: Icon(
                        Icons.pets,
                        size: 40,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildDetailRow("Nome", pet.name),
                    _buildDetailRow("Tipo", pet.type),
                    _buildDetailRow("Raça", pet.breed),
                    _buildDetailRow("Nascimento", pet.dateOfBirth),
                  ],
                ),
              ),
            ),
            Spacer(),
            Column(
              children: [
                _buildStyledButton(
                  context,
                  icon: Icons.vaccines,
                  label: "Ver Vacinas",
                  color: Colors.deepPurple,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      MyAppRoutes.petVaccines.routeName,
                      arguments: pet.id,
                    );
                  },
                ),
                SizedBox(height: 12),
                _buildStyledButton(
                  context,
                  icon: Icons.event,
                  label: "Ver Eventos",
                  color: Colors.deepPurple.shade200,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetEvents(petId: pet.id!),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.deepPurple),
          SizedBox(width: 10),
          Text(
            "$label:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyledButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
