import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PetEvents extends StatelessWidget{
  const PetEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Eventos do Pet",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, "/addPetEvents");
        },
        child: Icon(
          Icons.add,
        ),
      )
    );
  }
}