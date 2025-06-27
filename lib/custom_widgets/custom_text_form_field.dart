import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTextFormField extends StatelessWidget{
  final String? labelText;
  final String? hintText;
  final TextInputType? keyBoardType;
  final TextEditingController controller;

  const CustomTextFormField(
    {
      super.key,
      this.labelText,
      this.hintText,
      this.keyBoardType,
      required this.controller,
    }
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 30,
      ),
      child: TextFormField(
        decoration: InputDecoration(
          label: Text(
            labelText != null ? labelText! : "Texto"
          ),
          hint: Text(
            hintText != null ? hintText! : "Ex: Texto"
          ),
          filled: true,
          fillColor: Colors.black12,
          suffix: (keyBoardType == TextInputType.datetime) 
          ? 
          IconButton(
            onPressed: ()async{
              DateTime? date = await showDatePicker(
                context: context, 
                initialDate: DateTime.now(),
                firstDate: DateTime(2000), 
                lastDate: DateTime(2100)
              );
              if(date != null){
                controller.text = "${date.day.toString().padLeft(2,"0")}/${date.month.toString().padLeft(2,"0")}/${date.year}";
                print(controller.text);
              }
            },
            icon: Icon(Icons.calendar_today)
          )
          :
          null
        ),
        keyboardType: keyBoardType != null ? keyBoardType:TextInputType.text,
        controller: controller,
      ),
    );
  }
}