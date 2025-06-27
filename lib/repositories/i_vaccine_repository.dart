import 'package:projeto_estagio/models/vaccine.dart';

abstract class IVaccineRepository {
  Future<int> insertVaccine(Vaccine vaccine);
  Future<List<Vaccine>> getAllVaccines();
  Future<Vaccine?> getVaccineById(int id);
  Future<int> updateVaccine(Vaccine vaccine);
  Future<int> deleteVaccine(int id);
  Future<List<Vaccine>> getVaccinesByPetId(int petId);
}