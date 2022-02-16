import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String id;
  final String email;
  final String photoUrl;
  final String displayName;

  Users({
    required this.id,
    required this.email,
    required this.photoUrl,
    required this.displayName,
  });

  factory Users.fromDocument(DocumentSnapshot doc) {
    return Users(
      id: doc['id'],
      email: doc['email'],
      photoUrl: doc['photoUrl'],
      displayName: doc['displayName'],
    );
  }
}
