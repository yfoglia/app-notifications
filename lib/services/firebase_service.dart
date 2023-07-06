import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore database = FirebaseFirestore.instance;

Future<List> getProduct() async {
  List data = [];

  CollectionReference collectionReferenceData = database.collection('producto');

  QuerySnapshot queryData = await collectionReferenceData.get();
  
  queryData.docs.forEach((element) {
    data.add(element.data());
  });

  return data;
}