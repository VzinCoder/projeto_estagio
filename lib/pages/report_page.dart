import 'package:flutter/material.dart';
import 'package:projeto_estagio/models/pet.dart';
import 'package:projeto_estagio/models/event.dart';
import 'package:projeto_estagio/models/vaccine.dart';
import 'package:projeto_estagio/repositories/pet_repository.dart';
import 'package:projeto_estagio/repositories/event_repository.dart';
import 'package:projeto_estagio/repositories/vaccine_repository.dart';
import 'package:projeto_estagio/utils/injector.dart';

class ReportPage extends StatefulWidget {
  final List<String> selectedPetIds;

  const ReportPage({super.key, required this.selectedPetIds});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late final PetRepository _petRepository;
  late final EventRepository _eventRepository;
  late final VaccineRepository _vaccineRepository;

  Map<Pet, Map<String, dynamic>> _reportData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _petRepository = getIt.get<PetRepository>();
    _eventRepository = getIt.get<EventRepository>();
    _vaccineRepository = getIt.get<VaccineRepository>();
    _generateReportData();
  }

  Future<void> _generateReportData() async {
    Map<Pet, Map<String, dynamic>> tempReportData = {};
    try {
      for (String petId in widget.selectedPetIds) {
        final pet = await _petRepository.getPetById(petId);
        if (pet != null) {
          final events = await _eventRepository.getEventsByPetId(petId);
          final vaccines = await _vaccineRepository.getVaccinesByPetId(petId);
          tempReportData[pet] = {'events': events, 'vaccines': vaccines};
        }
      }
      setState(() {
        _reportData = tempReportData;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Erro ao gerar relatório: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao gerar o relatório. Tente novamente.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Relatório de Pets',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reportData.isEmpty
          ? const Center(
              child: Text('Nenhum dado encontrado para os pets selecionados.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _reportData.length,
              itemBuilder: (context, index) {
                final pet = _reportData.keys.elementAt(index);
                final data = _reportData[pet]!;
                final List<Event> events = data['events'];
                final List<Vaccine> vaccines = data['vaccines'];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pet: ${pet.name} (${pet.type} - ${pet.breed})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const Divider(height: 20, thickness: 1),
                        if (vaccines.isNotEmpty) ...[
                          const Text(
                            'Vacinas:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ...vaccines.map(
                            (v) => Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                top: 4.0,
                              ),
                              child: Text(
                                '- ${v.name} (Aplicada: ${v.dateApplication}, Próxima: ${v.nextDateApplication})',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ] else ...[
                          const Text(
                            'Vacinas: Nenhuma vacina cadastrada.',
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (events.isNotEmpty) ...[
                          const Text(
                            'Eventos:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ...events.map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                top: 4.0,
                              ),
                              child: Text(
                                '- ${e.type} em ${e.date}: ${e.observation}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ] else ...[
                          const Text(
                            'Eventos: Nenhum evento cadastrado.',
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                        if (index < _reportData.length - 1) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Divider(
                              height: 1,
                              thickness: 2,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
