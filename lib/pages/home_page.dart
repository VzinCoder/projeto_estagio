import 'package:flutter/material.dart';
import "../utils/db.dart";
import "../repositories/pet_repository.dart";
import "../models/pet.dart";
import "package:sqflite/sqflite.dart";
import "../my_app_routes.dart";

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>{

  Future<PetRepository> _initRepository() async {
    Db instance = Db();
    Database database = await instance.database;

    PetRepository repository = PetRepository(database);
    return repository;
  }

  Future<List<Pet>> _getAllPets() async {
    PetRepository repository = await _initRepository();
    List<Pet>  petList = await repository.getAllPets();
    return petList;
  }

  Future<int> _deletePet(int id)async{
    PetRepository repository = await _initRepository();
    int idRemoved = await repository.deletePet(id);
    return idRemoved;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meus Pets",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Pet>>(
        future: _getAllPets(), 
        builder: (context, snapshot){
          
          if(snapshot.hasData){
            List<Pet> pets = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: pets.length,

              itemBuilder: (constext, index){
                return Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 15
                  ),
                  decoration: BoxDecoration(
                    border: BoxBorder.all(
                      width: 0.4,
                      color: Colors.deepPurpleAccent
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5)
                    ),
                    color: Colors.deepPurple[50]
                  ),
                  child: ListTile(
                    
                    title: Text(pets[index].name),
                    subtitle: Text(pets[index].type),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 15,
                      children: [
                        ElevatedButton(
                          onPressed: (){
                            Navigator.pushNamed(
                              context, 
                              MyAppRoutes.addPet.routeName,
                              arguments: pets[index].toMap()
                            );
                          }, 
                          child: Icon(Icons.edit),
                        ),
                        ElevatedButton(
                          onPressed: ()async{
                            int id = await _deletePet(pets[index].id!);
                            if(id != null){
                              setState(() {
                                
                              });
                            }
                          }, 
                          child: Icon(Icons.delete)
                        )
                      ],
                    ),
                  ),
                );
              }
            );
          }else if(snapshot.hasError){
            return Center(
              child:Text("Algo deu errado ao obter a lista de pets"),
            );
          }else{
            return Center(
              child:Text("Carregando..."),
            );
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, MyAppRoutes.addPet.routeName);
        },
        child: Icon(
          Icons.add,
        ),
      )
    );
  }
}