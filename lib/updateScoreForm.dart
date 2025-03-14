import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class UpdateScoreForm extends StatefulWidget {
  final String documentId;
  const UpdateScoreForm({super.key, required this.documentId});

  @override
  State<UpdateScoreForm> createState() => _UpdateScoreFormState();
}

class _UpdateScoreFormState extends State<UpdateScoreForm> {
  final subjectController = TextEditingController();
  final scoreController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final CollectionReference scoresCollection = FirebaseFirestore.instance
      .collection('Scores');

  void updateScore() async {
    if (_formKey.currentState?.validate() ?? false) {
      await scoresCollection.doc(widget.documentId).update({
        'subject': subjectController.text,
        'score': double.parse(scoreController.text),
      });

      subjectController.clear();
      scoreController.clear();
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadExistingScore();
  }

  void _loadExistingScore() async {
    DocumentSnapshot docSnapshot =
        await scoresCollection.doc(widget.documentId).get();
    if (docSnapshot.exists) {
      var data = docSnapshot.data() as Map<String, dynamic>;
      subjectController.text = data['subject'];
      scoreController.text = data['score'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text(
          'Update Score',
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
              FutureBuilder<DocumentSnapshot>(
                future: scoresCollection.doc(widget.documentId).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text('No Student Scores');
                  }

                  var data = snapshot.data!.data() as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Student Name : ${data['studentName']}',
                      style: GoogleFonts.oswald(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  );
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
                  onPressed: updateScore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 95, 196, 112),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 13),
                  ),
                  child: Text(
                    'Update Score',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
