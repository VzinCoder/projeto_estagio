enum MyAppRoutes{
  homePage(routeName: "home_page"),
  addPet(routeName: "add_pet"),
  petDetails(routeName: "pet_details"),
  petVaccines(routeName: "pet_vaccines"),
  addPetVaccine(routeName: "add_pet_vaccine"),
  petEvents(routeName: "pet_events"),
  addPetEvent(routeName: "add_pet_event");
    
  const MyAppRoutes({required this.routeName});
    
  final String routeName;
}