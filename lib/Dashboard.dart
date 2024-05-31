import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:urann_crud/Screen_Crud.dart';
import 'package:urann_crud/sqflite/database_student.dart';
import 'package:urann_crud/sqflite/model_student.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Dashboard> {
  DatabaseStudent databaseStudent = DatabaseStudent();

  // ignore: non_constant_identifier_names
  List<ModelStudent> list_student = [];
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() {
    databaseStudent.GetAllRecord().then((value) {
      setState(() {
        list_student = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => Crud_screen(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Contacts",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: GestureDetector(
            child: Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
            onTap: () async {
              //databaseStudent.DeleteAllRecord();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.black,
                content: Text(
                  'Failed to delete all at one click❕',
                  style: TextStyle(color: Colors.white),
                ),
              ));
            }),
      ),
      body: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              offset: const Offset(
                5.0,
                5.0,
              ),
              blurRadius: 10.0,
              spreadRadius: 2.0,
            ), //BoxShadow
            BoxShadow(
              color: Colors.white,
              offset: const Offset(0.0, 0.0),
              blurRadius: 0.0,
              spreadRadius: 0.0,
            ),
          ],
        ),
        child: list_student.length > 0
            ? ListView.builder(
                itemCount: list_student.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 3, color: Colors.black),
                        left: BorderSide(width: 3, color: Colors.black),
                        right: BorderSide(width: 3, color: Colors.black),
                        bottom: BorderSide(width: 3, color: Colors.black),
                      ),
                      color: Colors.white,
                    ),
                    child: ListTile(
                      onTap: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => Crud_screen(
                                    modelStudent: list_student[index])));
                        loadData();
                      },
                      leading: Text(
                        list_student[index].id.toString(),
                      ),
                      title: Text(list_student[index].name),
                      subtitle: Text(list_student[index].roll_no),
                      trailing: InkWell(
                        onTap: () {
                          databaseStudent.DeleteRecord(
                                  list_student[index].id.toString())
                              .then((value) {
                            if (value) {
                              loadData();
                            } else {
                              print('Failed');
                            }
                          });
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Icon(
                  Icons.add_ic_call_rounded,
                  size: 100,
                  color: Colors.black,
                ),
              ),
      ),
    );
  }
}
