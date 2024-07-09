import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite_crud_operation_task/module/product_module/controller/product_controller.dart';
import 'package:sqlite_crud_operation_task/module/product_module/model/product_model.dart';
import 'package:sqlite_crud_operation_task/module/product_module/service/product_service.dart';
import 'package:sqlite_crud_operation_task/module/product_module/view/update_product_screen.dart';
import 'package:sqlite_crud_operation_task/utils/app_string.dart';

class ProductDetailScreen extends StatelessWidget {
  ProductDetailScreen({super.key, this.productModel});

  final ProductModel? productModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productModel?.productName ?? ""),
        actions: [
          IconButton(
              onPressed: () async {
               await Get.to(() => UpdateProductScreen(
                      productModel: productModel ?? ProductModel(),
                    ));
               Get.find<ProductController>().clearCacheData();
              },
              icon: Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                _dialogBuilder();
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              )),
        ],
      ),
      body: (productModel?.productImg?.isEmpty ?? true)
          ? const Center(
              child: Text(AppString.noImageFound),
            )
          : Image.file(File(productModel?.productImg ?? "")),
    );
  }

  Future<void> _dialogBuilder() {
    return showDialog<void>(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text(
            AppString.deleteProductWarning,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(AppString.cancelTitle),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(AppString.deleteTitle),
              onPressed: () async {
                await ProductService.instance.delete(productModel?.productId ?? 0);
                Get.back();
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
