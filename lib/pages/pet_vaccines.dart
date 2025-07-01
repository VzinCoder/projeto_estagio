import 'package:flutter/material.dart';
import 'package:projeto_estagio/models/pet.dart';
import 'package:projeto_estagio/models/vaccine.dart';
import 'package:projeto_estagio/pages/add_pet_vaccine.dart';
import 'package:projeto_estagio/repositories/vaccine_repository.dart';
import 'package:projeto_estagio/utils/injector.dart';

class PetVaccines extends StatefulWidget {
  final Pet pet;
  const PetVaccines({super.key, required this.pet});

  @override
  State<PetVaccines> createState() => _PetVaccinesState();
}

class _PetVaccinesState extends State<PetVaccines> {
  final _vaccines = <Vaccine>[];
  final _repository = getIt<VaccineRepository>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVaccines();
  }

  Future<void> _loadVaccines() async {
    final items = await _repository.getVaccinesByPetId(widget.pet.id!);
    setState(() {
      _vaccines.addAll(items);
      _isLoading = false;
    });
  }

  void _addVaccine(Vaccine vaccine) {
    setState(() => _vaccines.add(vaccine));
  }

  void _updateVaccine(Vaccine vaccine) {
    final i = _vaccines.indexWhere((v) => v.id == vaccine.id);
    if (i != -1) setState(() => _vaccines[i] = vaccine);
  }

  void _deleteVaccine(int id) async {
    final i = _vaccines.indexWhere((v) => v.id == id);
    if (i == -1) return;
    await _repository.deleteVaccine(id);
    setState(() => _vaccines.removeAt(i));
  }

  Future<void> _navigateToAdd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddPetVaccine(pet: widget.pet)),
    );
    if (result is Vaccine) _addVaccine(result);
  }

  Future<void> _navigateToEdit(Vaccine vaccine) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddPetVaccine(vaccine: vaccine)),
    );
    if (result is Vaccine) _updateVaccine(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Vacinas do Pet', style: TextStyle(color: Colors.white)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _vaccines.isEmpty
                ? const Center(child: Text('Nenhuma vacina encontrada.'))
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: _vaccines.length,
                    itemBuilder: (ctx, i) => VaccineCard(
                      vaccine: _vaccines[i],
                      onEdit: () => _navigateToEdit(_vaccines[i]),
                      onDelete: () => _deleteVaccine(_vaccines[i].id!),
                    ),
                  ),
      ),
    );
  }
}

class VaccineCard extends StatelessWidget {
  final Vaccine vaccine;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const VaccineCard({
    super.key,
    required this.vaccine,
    required this.onEdit,
    required this.onDelete,
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
                    vaccine.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('📅 ${vaccine.dateApplication}', overflow: TextOverflow.ellipsis),
                  Text('📅 Próxima: ${vaccine.nextDateApplication}', overflow: TextOverflow.ellipsis),
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
