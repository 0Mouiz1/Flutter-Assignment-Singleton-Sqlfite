// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:urann_crud/sqflite/database_student.dart';
import 'package:urann_crud/sqflite/model_student.dart';

// ignore: camel_case_types
class Crud_screen extends StatefulWidget {
  final ModelStudent? modelStudent;
  const Crud_screen({this.modelStudent});

  @override
  State<Crud_screen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Crud_screen> {
  DatabaseStudent databaseStudent = DatabaseStudent();

  TextEditingController name_controller = TextEditingController();
  TextEditingController roll_no_controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.modelStudent != null) {
      name_controller.text = widget.modelStudent!.name;
      roll_no_controller.text = widget.modelStudent!.roll_no;
    }
    setState(() {});
  }

  void loadData() async {
    var path = await getDatabasesPath();
    // ignore: avoid_print
    print(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerScrimColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        shadowColor: Colors.black,
        title: Text(""),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              child: TextFormField(
                //scrollPadding: EdgeInsets.all(20.0),
                controller: name_controller,
                decoration: InputDecoration(
                  label: Text(
                    'Enter Name ',
                    style: TextStyle(color: Colors.black),
                  ), // hintText: 'Enter Name',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 5.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              child: TextFormField(
                controller: roll_no_controller,
                decoration: InputDecoration(
                  label: Text(
                    "Enter Cellphone Number",
                    style: TextStyle(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 5.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  String name = name_controller.text.toString();
                  String roll_no = roll_no_controller.text.toString();

                  if (widget.modelStudent != null) {
                    ModelStudent modelStudent = ModelStudent(
                        id: widget.modelStudent!.id,
                        name: name,
                        roll_no: roll_no);
                    databaseStudent.UpdateRecord(modelStudent);
                    Navigator.pop(context);
                  } else {
                    ModelStudent modelStudent =
                        ModelStudent(name: name, roll_no: roll_no);

                    databaseStudent.AddRecord(modelStudent);
                    Navigator.pop(context);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.black),
                  //shadowColor: WidgetStateProperty.all(Colors.red),
                  // elevation: WidgetStateProperty.all(10),
                ),
                child: const Text(
                  "Enter",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
