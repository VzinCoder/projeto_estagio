import 'package:flutter/material.dart';
import "pages/home_page.dart";
import "pages/add_pet.dart";
import "pages/pet_details.dart";
import "pages/pet_vaccines.dart";
import "pages/add_pet_vaccine.dart";
import "pages/pet_events.dart";
import "pages/add_pet_event.dart";
import "my_app_routes.dart";

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
        MyAppRoutes.homePage.name: (BuildContext context)=> HomePage(),
        MyAppRoutes.addPet.name: (BuildContext context)=> AddPet(),
        MyAppRoutes.petDetails.name:(BuildContext context)=> PetDetails(),
        MyAppRoutes.petVaccines.name:(BuildContext context)=> PetVaccines(),
        MyAppRoutes.addPetVaccine.name:(BuildContext context)=> AddPetVaccine(),
        MyAppRoutes.petEvents.name:(BuildContext context)=> PetEvents(),
        MyAppRoutes.addPetEvent.name:(BuildContext context)=> AddPetEvent(),
      },
    );
  }
}
