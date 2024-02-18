import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../database/models/modelsView/ProjectInfo.dart';
import '../database/repository/TaskRepository.dart';
import '../theme/CustomColors.dart';
import '../theme/Dimens.dart';

class CirclePercentPrject extends StatelessWidget {
  final ProjectInfo project;
  final Future<double>? getPercentage;
  
  
  CirclePercentPrject({
    required this.project,
    required this.getPercentage,
    
  });
  parseDoubleToInt(double value) {
    return value.toInt();
  }
  Future<double>? getPercentageFromProject(int id)  {
    return  TaskRepository().getPercetageTaskDoneByProject(id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
        future: getPercentageFromProject(project.id!),
        builder: (context, AsyncSnapshot<double> snapshot) {
          print(snapshot.data.toString());
          if (snapshot.hasData && snapshot.data.toString() != "NaN") {
            return Padding(
              padding: const EdgeInsets.all(Dimens.spacing_medium_12),
              child: CircularPercentIndicator(
                radius: 50.0,
                lineWidth: 8.0,
                percent: snapshot.data! / 100,
                center: Text("${parseDoubleToInt(snapshot.data!)} %",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: CustomColors.TEXT_COLOR_DARK)),
                progressColor: Colors.green,
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(Dimens.spacing_medium_12),
              child: CircularPercentIndicator(
                radius: 50.0,
                lineWidth: 8.0,
                percent: 0,
                center: const Text("0 %", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: CustomColors.TEXT_COLOR_DARK)),
                progressColor: Colors.green,
              ),
            );
          }
        });
  }
}