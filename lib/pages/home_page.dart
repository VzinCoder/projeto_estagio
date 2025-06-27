import 'package:flutter/material.dart';
import 'package:projeto_estagio/pages/add_pet.dart';
import '../utils/db.dart';
import '../repositories/pet_repository.dart';
import '../models/pet.dart';
import 'package:sqflite/sqflite.dart';
import '../my_app_routes.dart';
import 'pet_details.dart'; // importe a tela de detalhes

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<PetRepository> _initRepository() async {
    Db instance = Db();
    Database database = await instance.database;
    PetRepository repository = PetRepository(database);
    return repository;
  }

  Future<List<Pet>> _getAllPets() async {
    PetRepository repository = await _initRepository();
    return await repository.getAllPets();
  }

  Future<int> _deletePet(int id) async {
    PetRepository repository = await _initRepository();
    return await repository.deletePet(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meus Pets",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Pet>>(
        future: _getAllPets(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Pet> pets = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: pets.length,
              itemBuilder: (context, index) {
                Pet pet = pets[index];

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5,
                      color: Colors.deepPurpleAccent,
                    ),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.deepPurple[50],
                  ),
                  child: ListTile(
                    title: Text(pet.name),
                    subtitle: Text(pet.type),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PetDetails(pet: pet),
                        ),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddPet(pet: pet),
                              ),
                            );
                          },
                          child: Icon(Icons.edit),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () async {
                            await _deletePet(pet.id!);
                            setState(() {});
                          },
                          child: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Algo deu errado ao obter a lista de pets"),
            );
          } else {
            return Center(
              child: Text("Carregando..."),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, MyAppRoutes.addPet.routeName);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
