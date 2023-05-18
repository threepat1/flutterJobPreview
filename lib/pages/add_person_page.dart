import 'package:flutter/material.dart';
import 'package:data_project/models/person.dart';

class AddPersonPage extends StatefulWidget {
  final Function(Person) onPersonAdded;

  const AddPersonPage({required this.onPersonAdded});

  @override
  _AddPersonPageState createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  int _currentStep = 0;

  final List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  final List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Person'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _handleStepContinue,
        steps: [
          Step(
            title: Text('เพิ่มข้อมูล'),
            content: Form(
              key: formKeys[0],
              child: Column(
                children: [
                  TextFormField(
                    controller: controllers[0],
                    decoration: InputDecoration(labelText: 'ชื่อ'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'โปรดใส่ชื่อ';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: controllers[1],
                    decoration: InputDecoration(labelText: 'นามสกุล'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'โปรดใส่นามสกุล';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: controllers[2],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'อายุ'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'โปรดใส่อายุ';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          Step(
            title: Text('ข้อมูลที่อยู่'),
            content: Form(
              key: formKeys[1],
              child: Column(
                children: [
                  TextFormField(
                    controller: controllers[3],
                    decoration: InputDecoration(labelText: 'ที่อยู่'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'ใส่ที่อยู่';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: controllers[4],
                    decoration: InputDecoration(labelText: 'จังหวัด'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'โปรดใส่จังหวัด';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: controllers[5],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'รหัสไปรษณีย์'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'โปรดใส่รหัสไปรษณีย์';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleStepContinue() {
    final currentFormKey = formKeys[_currentStep];
    if (currentFormKey.currentState!.validate()) {
      if (_currentStep < formKeys.length - 1) {
        setState(() {
          _currentStep++;
        });
      } else {
        _savePersonData();
      }
    }
  }

  void _savePersonData() {
    final firstName = controllers[0].text;
    final lastName = controllers[1].text;
    final age = int.parse(controllers[2].text);
    final address = controllers[3].text;
    final province = controllers[4].text;
    final zipCode = controllers[5].text;

    final person = Person(
      id: DateTime.now().toString(),
      fullName: '$firstName $lastName',
      age: age,
      street: address,
      province: province,
      zipCode: zipCode,
    );

    widget.onPersonAdded(person);
    Navigator.pop(context);
  }
}
