import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class AddScoreForm extends StatefulWidget {
  const AddScoreForm({super.key});

  @override
  State<AddScoreForm> createState() => _AddScoreFormState();
}

class _AddScoreFormState extends State<AddScoreForm> {
  final studentNameController = TextEditingController();
  final subjectController = TextEditingController();
  final scoreController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final CollectionReference scoresCollection = FirebaseFirestore.instance
      .collection('Scores');

  void addScore() async {
    if (_formKey.currentState?.validate() ?? false) {
      await scoresCollection.add({
        'studentName': studentNameController.text,
        'subject': subjectController.text,
        'score': double.parse(scoreController.text),
      });

      studentNameController.clear();
      subjectController.clear();
      scoreController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text(
          'Add Score',
          style: GoogleFonts.oswald(
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 126, 126, 126),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: studentNameController,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: Color(0xFF3A2E74),
                    fontWeight: FontWeight.bold,
                  ),
                  fillColor: Color(0xFFBDB2FF),
                  filled: true,
                  labelText: 'Student Name',
                  icon: Icon(
                    Icons.person,
                    color: Color.fromARGB(255, 157, 142, 243),
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the student name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: subjectController,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: Color(0xFF3A2E74),
                    fontWeight: FontWeight.bold,
                  ),
                  fillColor: Color(0xFFBDB2FF),
                  filled: true,
                  labelText: 'Subject',
                  icon: Icon(
                    Icons.book,
                    color: Color.fromARGB(255, 157, 142, 243),
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the subject';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: scoreController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: Color(0xFF1E3A5F),
                    fontWeight: FontWeight.bold,
                  ),
                  fillColor: Color(0xFFA0C4FF),
                  filled: true,
                  labelText: 'Score',
                  icon: Icon(
                    Icons.score,
                    color: Color.fromARGB(255, 122, 171, 250),
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the score';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: addScore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 85, 82, 100),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 13),
                  ),
                  child: Text(
                    'Add Score',
                    style: TextStyle(color: Colors.white),
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
