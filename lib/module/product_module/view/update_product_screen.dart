import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqlite_crud_operation_task/module/product_module/controller/product_controller.dart';
import 'package:sqlite_crud_operation_task/module/product_module/model/product_model.dart';
import 'package:sqlite_crud_operation_task/module/product_module/service/product_service.dart';
import 'package:sqlite_crud_operation_task/utils/app_string.dart';

class UpdateProductScreen extends StatefulWidget {
  UpdateProductScreen({Key? key, required this.productModel}) : super(key: key);
  final ProductModel productModel;

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final ProductController productController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    productController.productNameController.text = widget.productModel.productName ?? "";
    productController.selectedFile.value = XFile(widget.productModel.productImg ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Product Screen"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          commonProductWidget(productController.productNameController, AppString.productNameTitle).paddingOnly(bottom: 20),
          // Product Picture
          const Text(AppString.productPictureTitle).paddingOnly(bottom: 10),
          GestureDetector(
            onTap: () {
              selectedPickImgLocation(context);
            },
            child: Obx(
              () => (widget.productModel.productImg?.isEmpty ?? false)
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
                      File(productController.selectedFile.value.path.isEmpty
                          ? widget.productModel.productImg ?? ""
                          : productController.selectedFile.value.path),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
            ).paddingOnly(bottom: 20),
          ),
          ElevatedButton(
              onPressed: () {
                updateProductDetail();
              },
              child: const Text(AppString.updateProduct))
        ],
      ).paddingSymmetric(horizontal: 10),
    );
  }

  Future<void> updateProductDetail() async {
    ProductModel productModel = ProductModel(
        productName: productController.productNameController.text,
        productImg: productController.selectedFile.value.path.isNotEmpty
            ? productController.selectedFile.value.path
            : widget.productModel.productImg ?? "",
        productId: widget.productModel.productId);
    await ProductService.instance.updateProduct(productModel);
    Get.back();
    Get.back();
  }

  Future<void> selectedPickImgLocation(BuildContext context) {
    return showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      // barrierColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  productController.pickImage(true);
                  Get.back();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.camera_alt_rounded),
                    SizedBox(
                      width: 20,
                    ),
                    const Text('Select image from camera'),
                  ],
                ),
              ).paddingOnly(bottom: 10),
              GestureDetector(
                onTap: () {
                  productController.pickImage(false);
                  Get.back();
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.photo),
                      SizedBox(
                        width: 20,
                      ),
                      const Text('Select image from gallery'),
                    ],
                  ),
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 20),
        );
      },
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
