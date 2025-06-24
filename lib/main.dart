import 'package:flutter/material.dart';
import "home_page.dart";
import "add_pet.dart";
import "pet_details.dart";
import "pet_vaccines.dart";
import "add_vaccine.dart";
import "pet_events.dart";
import "add_pet_event.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.deepPurple[200],
          iconTheme: IconThemeData(
            color: Colors.white
          )
        ),
      ),
      initialRoute: "/petDetails",
      routes: {
        "/": (BuildContext context)=> HomePage(),
        "/addPet": (BuildContext context)=> AddPet(),
        "/petDetails":(BuildContext context)=> PetDetails(),
        "/petVaccines":(BuildContext context)=> PetVaccines(),
        "/addVaccine":(BuildContext context)=> AddVaccine(),
        "/petEvents":(BuildContext context)=> PetEvents(),
        "/addPetEvents":(BuildContext context)=> AddPetEvent(),
      },
    );
  }
}
