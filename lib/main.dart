import 'package:flutter/material.dart';
import "package:projeto_estagio/repositories/pet_repository.dart";
import "package:projeto_estagio/utils/injector.dart";
import "pages/home_page.dart";
import "pages/add_pet.dart";
import "pages/pet_details.dart";
import "pages/pet_vaccines.dart";
import "pages/add_pet_vaccine.dart";
import "pages/pet_events.dart";
import "pages/add_pet_event.dart";
import "my_app_routes.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,});

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
      initialRoute: MyAppRoutes.homePage.routeName,
      routes: {
        MyAppRoutes.homePage.routeName: (BuildContext context)=> HomePage(),
        MyAppRoutes.addPet.routeName: (BuildContext context)=> AddPet(),
        //MyAppRoutes.petDetails.routeName:(BuildContext context)=> PetDetails(),
        MyAppRoutes.petVaccines.routeName:(BuildContext context)=> PetVaccines(),
        MyAppRoutes.addPetVaccine.routeName:(BuildContext context)=> AddPetVaccine(),
        MyAppRoutes.addPetEvent.routeName:(BuildContext context)=> AddPetEvent(),
      },
    );
  }
}
