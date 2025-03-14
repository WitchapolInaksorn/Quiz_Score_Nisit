import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:score_nisit/addScoreForm.dart';
import 'package:score_nisit/updateScoreForm.dart';

class ShowScoresPage extends StatefulWidget {
  const ShowScoresPage({super.key});

  @override
  State<ShowScoresPage> createState() => _ShowScoresPageState();
}

class _ShowScoresPageState extends State<ShowScoresPage> {
  final CollectionReference scoresCollection = FirebaseFirestore.instance
      .collection('Scores');

  void deleteScore(String documentId) async {
    await scoresCollection.doc(documentId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Student Scores',
          style: GoogleFonts.oswald(
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 126, 126, 126),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: scoresCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No Student Scores',
                style: GoogleFonts.oswald(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 126, 126, 126),
                ),
              ),
            );
          }

          var documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var data = documents[index].data() as Map<String, dynamic>;
              String studentName = data['studentName'] ?? 'No Name';
              double score = data['score']?.toDouble() ?? 0.0;
              String documentId = documents[index].id;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  title: Text(
                    'Student Name : $studentName',
                    style: GoogleFonts.oswald(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Color.fromARGB(255, 80, 71, 134),
                    ),
                  ),
                  subtitle: Text(
                    'Score: $score',
                    style: GoogleFonts.oswald(
                      fontSize: 16,
                      color: Color.fromARGB(255, 75, 123, 185),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      UpdateScoreForm(documentId: documentId),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          deleteScore(documentId);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddScoreForm()),
          );
        },
        backgroundColor: Colors.teal,
        elevation: 10,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
