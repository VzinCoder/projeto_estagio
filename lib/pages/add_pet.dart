import "package:flutter/material.dart";
import "../custom_widgets/custom_text_form_field.dart";
import "../repositories/pet_repository.dart";
import "../models/pet.dart";
import "../my_app_routes.dart";
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

  Future<int> _updatePet(int petId) async {
    Pet pet = Pet(
      id: petId,
      name: name.text,
      type: type.text,
      breed: breed.text,
      dateOfBirth: dateOfBirth.text,
    );

    int id = await petRepository.updatePet(pet);

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
              hintText: "Ex: Rex",
              controller: name,
            ),
            CustomTextFormField(
              labelText: "Espécie",
              hintText: "Ex: Cachorro",
              controller: type,
            ),
            CustomTextFormField(
              labelText: "Raça",
              hintText: "Ex: Pastor Alemão",
              controller: breed,
            ),
            CustomTextFormField(
              labelText: "Data de nascimento",
              hintText: "Ex: 21/12/2025",
              controller: dateOfBirth,
              keyBoardType: TextInputType.datetime,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () async {
                  if (!isEditing) {
                    await _addPet();
                  } else {
                    await _updatePet(widget.pet!.id!);
                  }

                  Navigator.pushNamed(context, MyAppRoutes.homePage.routeName);
                },
                child: Text("Salvar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
