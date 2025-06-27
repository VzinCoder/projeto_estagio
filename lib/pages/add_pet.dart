import "package:flutter/material.dart";
import "../custom_widgets/custom_text_form_field.dart";
import "../utils/db.dart";
import "../repositories/pet_repository.dart";
import "../models/pet.dart";
import "package:sqflite/sqflite.dart";
import "../my_app_routes.dart";

class AddPet extends StatefulWidget{
  const AddPet({super.key});

  @override
  State<AddPet> createState() {
    return _AddPetState();
  }
}

class _AddPetState extends State<AddPet>{
  final name = TextEditingController();
  final type = TextEditingController();
  final breed = TextEditingController();
  final dateOfBirth = TextEditingController();

  Future<PetRepository> _initRepository()async{
    Db instance = Db();
    Database database = await instance.database;
    PetRepository petRepository = PetRepository(database);
    return petRepository;
  }

  Future<int> _addPet() async {

    Pet pet = Pet(
      name: name.text,
      type: type.text,
      breed: breed.text,
      dateOfBirth: dateOfBirth.text
    );

    PetRepository petRepository = await _initRepository();

    int id = await petRepository.insertPet(pet);

    return id;
  }

  Future<int> _updatePet(int petId) async {

    Pet pet = Pet(
      id: petId,
      name: name.text,
      type: type.text,
      breed: breed.text,
      dateOfBirth: dateOfBirth.text
    );

    PetRepository petRepository = await _initRepository();

    int id = await petRepository.updatePet(pet);

    return id;
  }

  Map<String, dynamic>? data;
  bool _isInit = false;

  Map<String, dynamic>? _receiveData(Object? arguments){
    if(_isInit) return data;

    data = (arguments != null) ? arguments as Map<String, dynamic>: null;

    if(data == null) return data;

    name.text = data!["name"];
    type.text = data!["type"];
    breed.text = data!["breed"];
    dateOfBirth.text = data!["date_of_birth"];

    _isInit = true;
    return data;
  }

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)?.settings.arguments;
    var receivedData = _receiveData(arguments);

    String pageTitle = (receivedData != null) ? "Editar ${receivedData["name"]}":"Cadastrar Novo Pet";
    bool actionCreate = (receivedData != null)? false:true;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitle,
          style: TextStyle(
              color: Colors.white
            )
        ),
        centerTitle: true,
      ),
      body:Container(
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
                  borderRadius: BorderRadius.circular(10)
                ),
                child: TextButton(
                  onPressed: ()async{
                    int id;
                    
                    if(actionCreate){
                      id  = await _addPet();
                    }else{
                      id = await _updatePet(data!["id"]);
                    }

                    if(id != null) Navigator.pushNamed(context, MyAppRoutes.homePage.routeName);
                  },
                  child: Text("Salvar")
                )
            ),
          ],
        ),
      ),
    );
  }
}