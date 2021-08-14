import 'package:better_sitt/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;
  DatabaseService( {required this.uid} );

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name, int height, int weight) async {
    return await userCollection.doc(uid).set({
      'name' : name,
      'height' : height,
      'weight' : weight,
    });
  }

  //user list from snapshot
  List<User1> _userListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return User1(
        name: doc['name'] ?? 'No Name',
        height: doc['height'] ?? 0,
        weight: doc['weight'] ?? 0
      );
    }).toList();
  }

  // get user stream
  Stream<List<User1>> get user{
    return userCollection.snapshots()
        .map(_userListFromSnapshot);
  }


}