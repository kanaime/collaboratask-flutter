
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../database/models/modelsView/ProjectInfo.dart';
import '../theme/CustomColors.dart';
import '../theme/Dimens.dart';
import 'FormInput.dart';

class FormPopup  extends StatelessWidget{
  final TextEditingController textEditingController;
  final String label;

  final formKey;
  final Function onPressedFunction;
  final Function onCanceledFunction;

  FormPopup({
    required this.onPressedFunction,
    required this.onCanceledFunction,
    this.formKey,
    required this.label,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child:  Column(
        children: [

          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                TextButton(onPressed: ()=>onCanceledFunction(), child: const Text("Annuler",style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),)),
                TextButton(onPressed: ()=>onPressedFunction(), child: const Text("Terminer",style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),)),
              ]
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimens.spacing_normal_8),
            child: Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CustomColors.TEXT_COLOR_DARK),),
          ),
          FormInput.defaultInput(label: label, controller: textEditingController),
        ],),
    );
  }
}
