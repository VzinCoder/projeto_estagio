import "package:flutter/material.dart";
import "../custom_widgets/custom_text_form_field.dart";
import "../repositories/pet_repository.dart";
import "../models/pet.dart";
import "../utils/injector.dart";

class AddPet extends StatefulWidget {
  final Pet? pet;

  const AddPet({super.key, this.pet});

  @override
  State<AddPet> createState() {
    return _AddPetState();
  }
}

class _AddPetState extends State<AddPet> {
  late final TextEditingController name;
  late final TextEditingController type;
  late final TextEditingController breed;
  late final TextEditingController dateOfBirth;

  late final String pageTitle;
  late final bool isEditing;

  final petRepository = getIt<PetRepository>();

  Future<int> _addPet() async {
    Pet pet = Pet(
      name: name.text,
      type: type.text,
      breed: breed.text,
      dateOfBirth: dateOfBirth.text,
    );

    int id = await petRepository.insertPet(pet);

    return id;
  }

  Future<int> _updatePet(String petId) async {
    var petMap = {
      'id':petId,
      'name': name.text,
      'type': type.text,
      'breed': breed.text,
      'date_of_birth': dateOfBirth.text,
      'updated_at': widget.pet!.updatedAt
    };

    Pet updatedPet = Pet.fromMap(petMap);

    int id = await petRepository.updatePet(updatedPet);

    return id;
  }

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.pet?.name ?? "");
    type = TextEditingController(text: widget.pet?.type ?? "");
    breed = TextEditingController(text: widget.pet?.breed ?? "");
    dateOfBirth = TextEditingController(text: widget.pet?.dateOfBirth ?? "");

    pageTitle = widget.pet != null
        ? "Editar ${widget.pet!.name}"
        : "Cadastrar novo pet";
    isEditing = widget.pet != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle, style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            CustomTextFormField(
              labelText: "Nome",
              controller: name,
            ),
            CustomTextFormField(
              labelText: "Espécie",
              controller: type,
            ),
            CustomTextFormField(
              labelText: "Raça",
              controller: breed,
            ),
            CustomTextFormField(
              labelText: "Data de nascimento",
              controller: dateOfBirth,
              keyBoardType: TextInputType.datetime,
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                if (!isEditing) {
                  await _addPet();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Pet adicionado com sucesso!"),
                    ),
                  );
                } else {
                  await _updatePet(widget.pet!.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Pet atualizado com sucesso!"),
                    ),
                  );
                }

                if (!context.mounted) return;

                Navigator.pop(context, true);
              },
              child: Text('Salvar')
            ),
          ],
        ),
      ),
    );
  }
}
