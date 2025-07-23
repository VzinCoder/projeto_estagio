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
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart' show rootBundle;
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

  pw.Widget PetTableInfo(Pet pet) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey),
      columnWidths: const {0: pw.FlexColumnWidth(3), 1: pw.FlexColumnWidth(5)},
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.blueAccent),
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(8)),
            pw.SizedBox(),
          ],
        ),
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                'Campo',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                'Dado',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
          ],
        ),
        _buildRow('Nome', pet.name),
        _buildRow('Espécie', pet.type),
        _buildRow('Raça', pet.breed),
        _buildRow('Data de Nascimento', pet.dateOfBirth),
      ],
    );
  }

  pw.Widget VaccinesTableInfo(List<Vaccine> vaccines) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey),
      columnWidths: const {
        0: pw.FlexColumnWidth(3),
        1: pw.FlexColumnWidth(3),
        2: pw.FlexColumnWidth(3),
      },
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.blueAccent),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                "VACINAS",
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(),
            pw.SizedBox(),
          ],
        ),
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                "Nome",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                "Data de Aplicação",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                "Próxima Dose",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
          ],
        ),
        ...vaccines.map((v) {
          final date = DateParser.parseDate(v.dateApplication);
          final formattedDate = date != null
              ? DateParser.formatDate(date)
              : 'Data inválida';

          final nextDate = DateParser.parseDate(v.nextDateApplication);
          final formattedNextDate = nextDate != null
              ? DateParser.formatDate(nextDate)
              : 'Não disponível';

          return pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(v.name),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(formattedDate),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(formattedNextDate),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  pw.Widget EventsTableInfo(List<Event> events) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey),
      columnWidths: const {
        0: pw.FlexColumnWidth(3),
        1: pw.FlexColumnWidth(3),
        2: pw.FlexColumnWidth(4),
      },
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.blueAccent),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                'EVENTOS',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(),
            pw.SizedBox(),
          ],
        ),
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                'Tipo',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                'Data',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                'Observação',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
          ],
        ),
        ...events.map((e) {
          final eventDate = DateParser.parseDate(e.date);
          final formattedDate = eventDate != null
              ? DateParser.formatDate(eventDate)
              : 'Data inválida';

          final observacao =
              (e.observation?.trim().isNotEmpty == true &&
                  e.observation != 'null')
              ? e.observation!
              : 'Não informado.';

          return pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(e.type),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(formattedDate),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(observacao),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  pw.TableRow _buildRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(label)),
        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(value)),
      ],
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();

    final petImage = pw.MemoryImage(
      (await rootBundle.load(
        'assets/images/pets_icone_teste.jpg',
      )).buffer.asUint8List(),
    );

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
                      pw.Center(
                        child: pw.ClipOval(
                          child: pw.SizedBox(
                            width: 100,
                            height: 100,
                            child: pw.Image(petImage, fit: pw.BoxFit.cover),
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Text(
                        "INFORMAÇÕES DO PET",
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blueAccent,
                        ),
                      ),
                      PetTableInfo(pet),
                      pw.SizedBox(height: 20),

                      if (vaccines.isNotEmpty) ...[
                        VaccinesTableInfo(vaccines),
                        pw.SizedBox(height: 20),
                      ] else ...[
                        pw.Text(
                          "Vacinas: Nenhuma vacina cadastrada!",
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontStyle: pw.FontStyle.italic,
                          ),
                        ),
                      ],

                      if (events.isNotEmpty) ...[
                        EventsTableInfo(events),
                        pw.SizedBox(height: 20),
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
