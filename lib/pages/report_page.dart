import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:projeto_estagio/models/pet.dart';
import 'package:projeto_estagio/models/event.dart';
import 'package:projeto_estagio/models/vaccine.dart';
import 'package:projeto_estagio/repositories/pet_repository.dart';
import 'package:projeto_estagio/repositories/event_repository.dart';
import 'package:projeto_estagio/repositories/vaccine_repository.dart';
import 'package:projeto_estagio/utils/injector.dart';
import 'package:projeto_estagio/utils/date_parser.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
  bool _isGeneratingPdf = false;

  @override
  void initState() {
    super.initState();
    _petRepository = getIt.get<PetRepository>();
    _eventRepository = getIt.get<EventRepository>();
    _vaccineRepository = getIt.get<VaccineRepository>();
    _initiatePdfGeneration();
  }

  Future<void> _initiatePdfGeneration() async {
    setState(() {
      _isGeneratingPdf = true;
    });

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
      _reportData = tempReportData;

      if (_reportData.isNotEmpty) {
        await Printing.layoutPdf(onLayout: _generatePdf);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Nenhum dado encontrado para gerar o relatório."),
          ),
        );
      }
    } catch (e) {
      debugPrint("Erro ao gerar relatório PDF: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erro ao gerar o relatório. Tente novamente."),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGeneratingPdf = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        build: (pw.Context context) {
          List<pw.Widget> content = [];
          if (_reportData.isEmpty) {
            content.add(pw.Center(child: pw.Text("Nenhum dado encontrado!")));
          } else {
            for (final pet in _reportData.keys) {
              final data = _reportData[pet]!;
              final List<Event> events = data['events'];
              final List<Vaccine> vaccines = data['vaccines'];

              content.add(
                pw.Container(
                  padding: const pw.EdgeInsets.all(16.0),
                  margin: const pw.EdgeInsets.only(bottom: 16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "Pet: ${pet.name} (${pet.type} - ${pet.breed})",
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blueAccent,
                        ),
                      ),
                      pw.Divider(
                        height: 20,
                        thickness: 1,
                        color: PdfColors.grey,
                      ),
                      if (vaccines.isNotEmpty) ...[
                        pw.Text(
                          "Vacinas:",
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        ...vaccines.map((v) {
                          final dateApplication = DateParser.parseDate(
                            v.dateApplication,
                          );
                          final formattedDateApplication =
                              dateApplication != null
                              ? DateParser.formatDate(dateApplication)
                              : "Data Inválida";

                          final nextDateApplication = DateParser.parseDate(
                            v.nextDateApplication,
                          );
                          final formattedNextDateApplication =
                              nextDateApplication != null
                              ? DateParser.formatDate(nextDateApplication)
                              : "Data Inválida";

                          return pw.Padding(
                            padding: const pw.EdgeInsets.only(
                              left: 8.0,
                              top: 4.0,
                            ),
                            child: pw.Text(
                              "- ${v.name} (Aplicada: $formattedDateApplication, Próxima: $formattedNextDateApplication)",
                              style: const pw.TextStyle(fontSize: 14),
                            ),
                          );
                        }),
                        pw.SizedBox(height: 10),
                      ] else ...[
                        pw.Text(
                          "Vacinas: Nenhuma vacina cadastrada!",
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontStyle: pw.FontStyle.italic,
                          ),
                        ),
                      ],
                      pw.SizedBox(height: 10),
                      if (events.isNotEmpty) ...[
                        pw.Text(
                          "Eventos:",
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        ...events.map((e) {
                          final eventDate = DateParser.parseDate(e.date);
                          final formattedEventDate = eventDate != null
                              ? DateParser.formatDate(eventDate)
                              : "Data Inválida";
                          return pw.Padding(
                            padding: const pw.EdgeInsets.only(
                              left: 8.0,
                              top: 4.0,
                            ),
                            child: pw.Text(
                              "- ${e.type} (Data: $formattedEventDate, Obs: ${e.observation ?? 'N/A'})",
                              style: const pw.TextStyle(fontSize: 14),
                            ),
                          );
                        }),
                        pw.SizedBox(height: 10),
                      ] else ...[
                        pw.Text(
                          "Eventos: Nenhum evento cadastrado!",
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontStyle: pw.FontStyle.italic,
                          ),
                        ),
                      ],
                      if (pet != _reportData.keys.last)
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                            vertical: 16.0,
                          ),
                          child: pw.Divider(
                            height: 1,
                            thickness: 2,
                            color: PdfColors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }
          }
          return content;
        },
      ),
    );
    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Gerando Relatório...",
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              _isGeneratingPdf ? "Preparando seu PDF..." : "Concluído!",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
