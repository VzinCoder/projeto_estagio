import "package:flutter/material.dart";

class AddPet extends StatelessWidget{
  const AddPet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cadastrar Novo Pet",
        style: TextStyle(
            color: Colors.white
          )
        ),
        centerTitle: true,
      ),
    );
  }
}