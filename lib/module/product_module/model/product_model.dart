class ProductModel {
  int? productId;
  String? productName;
  String? productImg;
  ProductModel({this.productName, this.productImg, this.productId});

  ProductModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productImg = json['product_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_name'] = productName;
    data['product_img'] = productImg;
    return data;
  }
}
