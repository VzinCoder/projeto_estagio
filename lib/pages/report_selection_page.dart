import 'package:flutter/material.dart';
import 'package:projeto_estagio/models/pet.dart';
import 'package:projeto_estagio/repositories/pet_repository.dart';
import 'package:projeto_estagio/utils/injector.dart';
import 'package:projeto_estagio/pages/report_page.dart';

class ReportSelectionPage extends StatefulWidget {
  const ReportSelectionPage({super.key});

  @override
  State<ReportSelectionPage> createState() => _ReportSelectionPageState();
}

class _ReportSelectionPageState extends State<ReportSelectionPage> {
  late final PetRepository _petRepository;
  List<Pet> _allPets = [];
  Set<String> _selectedPetIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _petRepository = getIt.get<PetRepository>();
    _loadPets();
  }

  Future<void> _loadPets() async {
    try {
      final pets = await _petRepository.getAllPets();
      setState(() {
        _allPets = pets;
        _isLoading = false;
      });
    } catch (e) {
      // Tratar erro de carregamento dos pets
      debugPrint('Erro ao carregar pets: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _togglePetSelection(String petId) {
    setState(() {
      if (_selectedPetIds.contains(petId)) {
        _selectedPetIds.remove(petId);
      } else {
        _selectedPetIds.add(petId);
      }
    });
  }

  void _generateReport() {
    if (_selectedPetIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione pelo menos um pet para o relatório.'),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ReportPage(selectedPetIds: _selectedPetIds.toList()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Selecionar Pets para Relatório',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _allPets.isEmpty
          ? const Center(child: Text('Nenhum pet cadastrado.'))
          : ListView.builder(
              itemCount: _allPets.length,
              itemBuilder: (context, index) {
                final pet = _allPets[index];
                final isSelected = _selectedPetIds.contains(pet.id);
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(pet.name),
                    subtitle: Text('Tipo: ${pet.type}, Raça: ${pet.breed}'),
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (bool? value) {
                        if (value != null) {
                          _togglePetSelection(pet.id);
                        }
                      },
                    ),
                    onTap: () {
                      _togglePetSelection(pet.id);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _generateReport,
        label: const Text('Gerar Relatório'),
        icon: const Icon(Icons.description),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
