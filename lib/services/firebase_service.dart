import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

FirebaseFirestore database = FirebaseFirestore.instance;
CollectionReference collectionReferenceData = database.collection('product');

Future<List> getProduct() async {
	List data = [];

	QuerySnapshot queryData = await collectionReferenceData.get();

	queryData.docs.forEach((element) {
		data.add(element.data());
	});

	return data;
}

Future<void> addProduct(Product newElement) async {
	Map<String, dynamic> elementData = newElement.toJson();
	await collectionReferenceData.add(elementData);
}
