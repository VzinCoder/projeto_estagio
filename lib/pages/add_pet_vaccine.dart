import "package:flutter/material.dart";

class AddPetVaccine extends StatelessWidget{
  const AddPetVaccine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cadastrar Vacina",
        style: TextStyle(
            color: Colors.white
          )
        ),
        centerTitle: true,
      ),
    );
  }
}