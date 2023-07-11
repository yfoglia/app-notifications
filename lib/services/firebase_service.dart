import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

FirebaseFirestore database = FirebaseFirestore.instance;
CollectionReference collectionReferenceData = database.collection('product');

Future<List> getProduct() async {
  List products = [];

  QuerySnapshot queryData = await collectionReferenceData.get();

  for (var doc in queryData.docs) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final element = {
      "name": data['name'],
      "code": data['code'],
      "expirationDate": data['expirationDate'],
      "firebaseId": doc.id,
    };

    products.add(element);
  }

  return products;
}

Stream<List<Map<String, dynamic>>> streamProduct() {
  return collectionReferenceData.snapshots().map((snapshot) {
    List<Map<String, dynamic>> products = [];
    snapshot.docs.forEach((doc) {
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      final element = {
        "name": data['name'],
        "code": data['code'],
        "expirationDate": data['expirationDate'],
        "firebaseId": doc.id,
      };
      products.add(element);
    });
    return products;
  });
}

Future<void> addProduct(Product newElement) async {
  Map<String, dynamic> elementData = newElement.toJson();
  await collectionReferenceData.add(elementData);
}

Future<void> updateProduct(String idFirebase, Product newElement) async {
  Map<String, dynamic> elementData = newElement.toJson();
  await collectionReferenceData.doc(idFirebase).set(elementData);
}

Future<void> deleteProduct(String idFirebase) async {
  await collectionReferenceData.doc(idFirebase).delete();
}
