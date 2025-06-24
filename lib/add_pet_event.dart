import "package:flutter/material.dart";

class AddPetEvent extends StatelessWidget{
  const AddPetEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cadastrar Evento",
        style: TextStyle(
            color: Colors.white
          )
        ),
        centerTitle: true,
      ),
    );
  }
}