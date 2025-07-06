import 'package:projeto_estagio/models/vaccine.dart';

abstract class IVaccineRepository {
  Future<int> insertVaccine(Vaccine vaccine);
  Future<List<Vaccine>> getAllVaccines();
  Future<Vaccine?> getVaccineById(String id);
  Future<int> updateVaccine(Vaccine vaccine);
  Future<int> deleteVaccine(String id);
  Future<List<Vaccine>> getVaccinesByPetId(String petId);
}