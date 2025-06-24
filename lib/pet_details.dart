import "package:flutter/material.dart";

class PetDetails extends StatelessWidget{
  const PetDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detalhes do Pet",
        style: TextStyle(
            color: Colors.white
          )
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton(
              onPressed:(){
                Navigator.pushNamed(context, "/petVaccines");
              } ,
              child: Text("Vacinas")
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton(
              onPressed:(){
                Navigator.pushNamed(context, "/petEvents");
              } ,
              child: Text("Eventos")
            ),
          )
        ],
      ),
    );
  }
}