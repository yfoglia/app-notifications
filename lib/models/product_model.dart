class Product {
	String name;
	String code;
	DateTime expirationDate;

	Product({
		required this.name, 
		required this.code, 
		required this.expirationDate
	});

	Map<String, dynamic> toJson() {
		return {
			'name': name,
			'code': code,
			'expirationDate': expirationDate.toIso8601String(),
		};
	}
}
