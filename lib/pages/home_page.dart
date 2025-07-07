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
    void _navigateToPetDetails({required Pet pet}) async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PetDetails(pet: pet),
        ),
      );
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
        body: Padding(
          padding: EdgeInsetsGeometry.all(20),
          child: FutureBuilder(
            future: _petsFuture,
            builder: (context, snapshot){

              if(snapshot.connectionState == ConnectionState.waiting){

                return CircularProgressIndicator();

              }
              
              if(snapshot.hasError){

                return Center(
                  child: Text("Erro ao carregar pets: ${snapshot.error}"),
                );

              }

              if(snapshot.hasData){
                if(snapshot.data!.isEmpty) return CenterMsg(msg: "Nenhum Pet cadastrado");
                
                List<Pet> pets = snapshot.data!;

                return ListView.builder(
                  itemCount: pets.length,
                  itemBuilder: (context, index){
                    return PetCard(
                      pet: pets[index],
                      edit: _navigateToAddPet,
                      delete: _deletePet,
                      details: _navigateToPetDetails,
                    );
                  }
                );
              }

              return CenterMsg(msg: "Não foi possivel recuperar pets do banco de dados");
            }
          ),
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

  class PetCard extends StatelessWidget{
    const PetCard(
      {
        super.key, 
        required this.pet,
        required this.edit,
        required this.delete,
        required this.details
      }
    );

    final Pet pet;
    final void Function({required Pet pet}) edit;
    final void Function(int id) delete;
    final void Function({required Pet pet}) details;

    @override
    Widget build(BuildContext context) {
      return Card(
        elevation: 5,
        child: ListTile(
          contentPadding: EdgeInsets.fromLTRB(8, 6, 8, 6),
          onTap: (){
            details(pet: pet);
          },
          title: Text(
            pet.name,
            style: TextStyle(
              fontWeight: FontWeight.w900
            ),
          ),
          subtitle: Text(
            pet.type
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(8),
                  minimumSize: Size(40, 40) 
                ),
                onPressed: (){
                  edit(pet: pet);
                },
                child: Icon(Icons.edit)
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(8),
                  minimumSize: Size(40, 40) 
                ),
                onPressed: (){
                  delete(pet.id!);
                },
                child: Icon(Icons.delete)
              ),
            ],
          ),
        ),
      );
    }
  }

  class CenterMsg extends StatelessWidget{
    final String msg;

    const CenterMsg({super.key, required this.msg});

    @override
    Widget build(BuildContext context) {
      return Center(
        child: Text(msg),
      );
    }
  }
