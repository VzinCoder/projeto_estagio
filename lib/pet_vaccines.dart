import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
          Navigator.pushNamed(context, "/addVaccine");
        },
        child: Icon(
          Icons.add,
        ),
      )
    );
  }
}