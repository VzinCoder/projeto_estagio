import "package:flutter/material.dart";

class AddVaccine extends StatelessWidget{
  const AddVaccine({super.key});

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