import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite_crud_operation_task/module/product_module/controller/product_controller.dart';
import 'package:sqlite_crud_operation_task/module/product_module/model/product_model.dart';
import 'package:sqlite_crud_operation_task/module/product_module/service/product_service.dart';
import 'package:sqlite_crud_operation_task/utils/app_string.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});

  final ProductController productController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.addProductScreen),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          commonProductWidget(productController.productNameController, AppString.productNameTitle).paddingOnly(bottom: 20),
          // Product Picture
          const Text(AppString.productPictureTitle).paddingOnly(bottom: 10),
          Obx(
            () => productController.selectedFile.value.path.isEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                              onTap: () {
                                productController.pickImage(false);
                              },
                              child: const Icon(Icons.photo))
                          .paddingOnly(right: 20),
                      GestureDetector(
                          onTap: () {
                            productController.pickImage(false);
                          },
                          child: const Icon(Icons.camera_alt_rounded)),
                    ],
                  )
                : Image.file(
                    File(productController.selectedFile.value.path),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
          ).paddingOnly(bottom: 20),
          ElevatedButton(
              onPressed: () {
                ProductModel productModel =
                    ProductModel(productName: productController.productNameController.text, productImg: productController.selectedFile.value.path);
                ProductService.instance.addProduct(productModel);
              },
              child: const Text(AppString.addProduct))
        ],
      ).paddingSymmetric(horizontal: 10),
    );
  }

  Widget commonProductWidget(TextEditingController controller, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
