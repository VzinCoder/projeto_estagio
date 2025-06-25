import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import "../my_app_routes.dart";

class HomePage extends StatelessWidget{
  const HomePage({super.key});

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