import 'package:flutter/material.dart';

class Student extends StatefulWidget {
  const Student({super.key});

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  String? selectedValue = 'Option 1'; // Default value
  List<String> dropdownItems = ['Option 1', 'Option 2', 'Option 3'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vote here'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Student Roll Number',
                  border: OutlineInputBorder(),
                )),
            const SizedBox(
              height: 40,
            ),
            DropdownButton<String>(
              
              value: selectedValue,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue!;
                });
              },
              items:
                  dropdownItems.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children:[
                      TextButton(
                        onPressed: (){}, 
                        child: const Text('test')
                        )],),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
