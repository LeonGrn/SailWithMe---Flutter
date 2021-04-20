import 'package:SailWithMe/models/createdBy_module.dart';
import 'package:flutter/material.dart';

class JobPost {
  String position;
  String location;
  String employmentType;
  String vessel;
  String salary;
  String description;
  String timeAgo;
  CreatedBy createdBy;

  JobPost({
    @required this.position,
    @required this.location,
    @required this.employmentType,
    @required this.vessel,
    @required this.salary,
    @required this.description,
    @required this.timeAgo,
    @required this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'Position': position,
      'Location': location,
      'EmploymentType': employmentType,
      'Vessel': vessel,
      'Salary': salary,
      'Description': description,
      'TimeAgo': timeAgo,
      'CreatedBy': createdBy.toJson(),
    };
  }
}
