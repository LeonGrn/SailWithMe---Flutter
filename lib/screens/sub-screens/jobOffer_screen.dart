import 'package:SailWithMe/config/ApiCalls.dart';
import 'package:SailWithMe/models/createdBy_module.dart';
import 'package:SailWithMe/models/jobPost_module.dart';
import 'package:SailWithMe/models/user_module.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JobOfferScreen extends StatefulWidget {
  final UserData user;

  const JobOfferScreen({
    @required this.user,
    Key key,
  }) : super(key: key);

  @override
  _JobOfferScreenState createState() => _JobOfferScreenState();
}

class _JobOfferScreenState extends State<JobOfferScreen> {
  TextEditingController positionController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  TextEditingController employmentTypeController = new TextEditingController();
  TextEditingController vesselController = new TextEditingController();
  TextEditingController salaryController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  bool validateField() {
    if (positionController.text == null ||
        positionController.text == "" ||
        locationController.text == null ||
        locationController.text == "" ||
        employmentTypeController.text == null ||
        employmentTypeController.text == "" ||
        vesselController.text == null ||
        vesselController.text == "" ||
        salaryController.text == null ||
        salaryController.text == "" ||
        descriptionController.text == null ||
        descriptionController.text == "") {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Create a job post"),
            RaisedButton(
              color: Colors.cyan[400],
              onPressed: () async {
                if (validateField() == true) {
                  String formattedTime = DateFormat.Hms().format(now);

                  JobPost myJob = JobPost(
                      position: positionController.text,
                      location: locationController.text,
                      employmentType: employmentTypeController.text,
                      vessel: vesselController.text,
                      salary: salaryController.text,
                      description: descriptionController.text,
                      timeAgo: formattedTime,
                      createdBy: CreatedBy(
                          name: widget.user.getFullName,
                          imageUrl: widget.user.getImageRef,
                          id: ApiCalls.recieveUserInstance()));

                  await ApiCalls.createJobOfferPost(myJob);
                }
              },
              child: Text(
                "Post",
                style: TextStyle(color: Colors.black, fontSize: 15.0),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          // padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: positionController,
                  maxLines: 1,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Position',
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: locationController,
                  maxLines: 1,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    // errorText: validateField(locationController.text),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: employmentTypeController,
                  maxLines: 1,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: "Employemnt type",
                    // errorText: validateField(employmentTypeController.text),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: vesselController,
                  maxLines: 1,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: "Vessel",
                    // errorText: validateField(vesselController.text),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: salaryController,
                  maxLines: 1,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: "Salary",
                    // errorText: validateField(salaryController.text),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: descriptionController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: "Description",
                    // errorText: validateField(descriptionController.text),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
