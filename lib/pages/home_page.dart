import 'package:flutter/material.dart';
import 'package:projeto_estagio/pages/add_pet.dart';
import 'package:projeto_estagio/utils/injector.dart';
import '../repositories/pet_repository.dart';
import '../models/pet.dart';
import 'pet_details.dart'; // importe a tela de detalhes

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PetRepository repository = getIt<PetRepository>();
  late Future<List<Pet>> _petsFuture;

  @override
  void initState() {
    super.initState();
    _petsFuture = _getAllPets();
  }

  void _navigateToAddPet({Pet? pet}) async {
    final bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPet(pet: pet),
      ),
    );

    if (result == true) {
      setState(() {
        _petsFuture = _getAllPets();
      });
    }
  }

  Future<List<Pet>> _getAllPets() async {
    return await repository.getAllPets();
  }

  Future<void> _deletePet(int id) async {
    await repository.deletePet(id);
    setState(() {
      _petsFuture = _getAllPets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Pets", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Pet>>(
        future: _petsFuture,
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
            return Center(child: Text("Carregando..."));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddPet();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
