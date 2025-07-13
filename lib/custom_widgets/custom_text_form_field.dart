import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget{
  final String? labelText;
  final TextInputType? keyBoardType;
  final TextEditingController controller;
  final bool isInputTypeData;
  
  const CustomTextFormField(
    {
      super.key,
      this.labelText,
      this.keyBoardType,
      required this.controller,
    }
  ): isInputTypeData = keyBoardType == TextInputType.datetime;

  void _showDatePicker(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), 
      lastDate: DateTime(2100)
    );
    if(date != null){
      String year = date.year.toString();
      String month = date.month.toString().padLeft(2, "0");
      String day = date.day.toString().padLeft(2, "0");
      
      controller.text = "$year-$month-$day";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          label: Text(
            labelText ?? "Texto"
          ),
          suffixIcon: isInputTypeData
          ? 
            Icon(Icons.calendar_today)
          :
            null
        ),
        keyboardType: keyBoardType ?? TextInputType.text,
        controller: controller,
        onTap: isInputTypeData ? () => _showDatePicker(context)  : null,
        readOnly: isInputTypeData,
      ),
    );
  }
}