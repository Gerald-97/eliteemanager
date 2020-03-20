class SubCategory {
  int id;
  int categoryId;
  String subCategoryName;

  SubCategory({
    this.id,
    this.categoryId,
    this.subCategoryName,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
    id: json["id"],
    categoryId: json["category_id"],
    subCategoryName: json["sub_category_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "sub_category_name": subCategoryName,
  };
}