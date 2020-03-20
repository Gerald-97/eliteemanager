class Product {
  int id;
  String slug;
  String productName;
  String productPrice;
  String productAvatar;
  int productCategory;
  int productSubCategory;
  int productQuantity;

  Product({
    this.id,
    this.slug,
    this.productName,
    this.productPrice,
    this.productAvatar,
    this.productCategory,
    this.productSubCategory,
    this.productQuantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    slug: json["slug"],
    productName: json["product_name"],
    productPrice: json["product_price"],
    productAvatar: json["product_avatar"],
    productCategory: json["product_category"],
    productSubCategory: json["product_sub_category"],
    productQuantity: json["product_quantity"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slug": slug,
    "product_name": productName,
    "product_price": productPrice,
    "product_avatar": productAvatar,
    "product_category": productCategory,
    "product_sub_category": productSubCategory,
    "product_quantity": productQuantity,
  };
}