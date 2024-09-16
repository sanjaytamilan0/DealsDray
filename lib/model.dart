class Banner {
  final String banner;

  Banner({required this.banner});

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      banner: json['banner'],
    );
  }
}

class Category {
  final String label;
  final String icon;

  Category({required this.label, required this.icon});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      label: json['label'],
      icon: json['icon'],
    );
  }
}

class Product {
  final String icon;
  final String offer;
  final String label;
  final String subLabel;

  Product({
    required this.icon,
    required this.offer,
    required this.label,
    required this.subLabel,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      icon: json['icon'],
      offer: json['offer'],
      label: json['label'],
      subLabel: json['SubLabel'] ?? '', // Handle missing field
    );
  }
}

