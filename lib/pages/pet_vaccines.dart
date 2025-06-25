import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import "../my_app_routes.dart";

class PetVaccines extends StatelessWidget{
  const PetVaccines({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Vacinas do Pet",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, MyAppRoutes.addPetVaccine.routeName);
        },
        child: Icon(
          Icons.add,
        ),
      )
    );
  }
}