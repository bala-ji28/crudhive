import 'package:crudhive/dbmodel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final formkey = GlobalKey<FormState>();
  final namecontroller = TextEditingController();
  final phonecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text('ADD USER'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Form(
              key: formkey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter name',
                      prefixIcon: Icon(Icons.person),
                    ),
                    controller: namecontroller,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Enter the field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter phone number',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    controller: phonecontroller,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Enter the field';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formkey.currentState!.validate()) {
                  Box box = Hive.box<Customer>('cruddb');
                  box.add(Customer(
                      name: namecontroller.text,
                      phone: int.parse(phonecontroller.text)));
                  namecontroller.clear();
                  phonecontroller.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data added successfully...'),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
